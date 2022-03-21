pragma circom 2.0.0;

include "../circomlib/circuits/comparators.circom";

// Template that calculates the area of the triangle
template getAreaOfTraingle() {
    // Inputs
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input x3;
    signal input y3;

    // Output
    signal output localArea;

    // Calculating the individual determinants
    signal m1;
    m1 <== x2 * y3;
    signal m2;
    m2 <== x3 * y2;
    signal temp1;
    temp1 <== m1 - m2;

    signal m3;
    m3 <== x3 * y1;
    signal m4;
    m4 <== x1 * y3;
    signal temp2;
    temp2 <== m3 - m4;

    signal m5;
    m5 <== x1 * y2;
    signal m6;
    m6 <== x2 * y1;
    signal temp3;
    temp3 <== m5 - m6;

    // Adding up the determinant result
    signal temp4;
    temp4 <== temp1 + temp2;
    signal temp5;
    temp5 <== temp4 + temp3;
    // Not dividing by 2, as the area is not our main concern here
    // Our point of concern is whether the area is 0 or not
    // a / 2 is 0 iff a is 0
    localArea <== temp5;
}

// Template that checks if the distance between two points is less than the given energy
template isValid() {
    // Inputs
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input energy;

    // Output
    signal output out;

    // Squaring the energy, so that I do not have to do the square root of distance
    signal tempEnergy;
    tempEnergy <== energy ** 2;

    // Calculating the distance
    signal m1;
    m1 <== x1 - x2;
    signal m2;
    m2 <== y1 - y2;

    signal temp1;
    temp1 <== m1 ** 2;

    signal temp2;
    temp2 <== m2 ** 2;

    signal sum;
    sum <== temp1 + temp2;

    // Checking if the distance is less than the energy
    component leq = LessEqThan(100);
    leq.in[0] <== sum;
    leq.in[1] <== tempEnergy;
    out <== leq.out;
}

// Template that checks if all the conditions required are met
template verify() {
    // Inputs
    signal input a;
    signal input b;
    signal input c;

    // Output
    signal output out;

    // Reversing the result for area being zero
    // If area is zero, temp1 is zero, otherwise 1
    signal temp1;
    temp1 <== 1 - a;

    // Adding temp1 to the truth value of (move from A to B is valid)
    // If the move is permitted, only then will temp2 contain the value 2
    // Any other combination of inputs will result in temp2 being at most 1
    signal temp2;
    temp2 <== temp1 + b;

    // Adding temp2 to the truth value of (move from B to C is valid)
    // If the move is permitted, only then will temp3 contain the value 3
    // Any other combination of inputs will result in temp3 being at most 2
    signal temp3;
    temp3 <== temp2 + c;

    // Subtracting 3 from the value of temp4
    // If the move is permitted, only then will temp4 contain the value 0
    // Any other combination of inputs will result in temp4 having a negative value
    signal temp4;
    temp4 <== temp3 - 3;

    // Checking if the value of temp4 is 0
    component zero = IsZero();
    zero.in <== temp4;
    out <== zero.out;
}

// Main template
template Main() {
    // Private Inputs
    signal input Ax;
    signal input Ay;
    signal input Bx;
    signal input By;
    signal input Cx;
    signal input Cy;
    signal input energy;

    // Public outputs
    // out[0] - Whether the area of triangle is zero or not
    // out[1] - Whether the move from A to B is valid or not
    // out[2] - Whether the move from B to C is valid or not
    // out[3] - Whether out[0] is 0 and out[1] and out[2] are 1
    signal output out[4];

    // Calculating the area of triangle
    component calcArea = getAreaOfTraingle();
    calcArea.x1 <== Ax;
    calcArea.y1 <== Ay;
    calcArea.x2 <== Bx;
    calcArea.y2 <== By;
    calcArea.x3 <== Cx;
    calcArea.y3 <== Cy;

    signal area;
    area <== calcArea.localArea;

    // Checking if the area is zero
    component zero = IsZero();
    zero.in <== area;
    out[0] <== zero.out;

    // Checking if the move from A to B is valid
    component validMove1 = isValid();
    validMove1.x1 <== Ax;
    validMove1.y1 <== Ay;
    validMove1.x2 <== Bx;
    validMove1.y2 <== By;
    validMove1.energy <== energy;
    out[1] <== validMove1.out;

    // Checking if the move from B to C is valid
    component validMove2 = isValid();
    validMove2.x1 <== Bx;
    validMove2.y1 <== By;
    validMove2.x2 <== Cx;
    validMove2.y2 <== Cy;
    validMove2.energy <== energy;
    out[2] <== validMove2.out;

    // Checking if the area is zero and the moves are valid
    component finalComp = verify();
    finalComp.a <== out[0];
    finalComp.b <== out[1];
    finalComp.c <== out[2];
    out[3] <== finalComp.out;
}

component main = Main();