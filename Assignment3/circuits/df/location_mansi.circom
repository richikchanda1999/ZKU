
include "../circomlib/circuits/mimcsponge.circom"
include "../circomlib/circuits/comparators.circom"
include "../darkforest-v0.3/circuits/range_proof/circuit.circom"

template calculateSlope(){
    signal input in[4];
    signal X;
    signal Y;
    signal output out;

    if(in[0] < in[1]){
        X <== in[1] - in[0];
    }
    else{
        X <== in[0] - in[1];
    }

    if(in[2] < in[3]){
        Y <== in[3] - in[2];
    }
    else{
        Y <== in[2] - in[3];
    }

    out <== Y \ X;

    return out;
}

template Main() {
    signal input x1;
    signal input y1;
    signal input x2;
    signal input y2;
    signal input x3;
    signal input y3;
    signal input energy;

    signal output result;

    /* check abs(x1), abs(y1), abs(x2), abs(y2) < 2 ** 32 */
    component rp = MultiRangeProof(4, 40, 2 ** 32);
    rp.in[0] <== x1;
    rp.in[1] <== y1;
    rp.in[2] <== x2;
    rp.in[3] <== y2;

    /* checks if the point lies on a triangle */

    component comp1 = IsEqual();
    component slope1 = calculateSlope();
    component slope2 = calculateSlope();
    signal s1;
    signal s2;
    signal isSlopeSame;
    slope1.in[0] <== x1;
    slope1.in[1] <== x2;
    slope1.in[2] <== y1;
    slope1.in[3] <== y2;
    s1 <== slope1.out;

    slope2.in[0] <== x1;
    slope2.in[1] <== x2;
    slope2.in[2] <== y1;
    slope2.in[3] <== y2;
    s2 <== slope2.out;

    /* if slope of the line joining A and B and B and C
    are same, then it is not a triangle */
    comp1.in[0] <== s1;
    comp1.in[1] <== s2;
    isSlopeSame <== comp1.out;
    isSlopeSame === 0

    /*check energy bound */
    signal jump1;
    signal jump2;
    jump1 <== 


    //if euclidean distance between 2 points < Energy
    //passed



}

component main = Main();