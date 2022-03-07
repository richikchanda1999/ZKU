pragma circom 2.0.0;

include "../mimcsponge.circom";

template calculateHash() {
    // Input signal for the left node
    signal input left;
    // Input signal for the right node
    signal input right;
    // The signal that will contain the hashed output
    signal output out;
    // Number of inputs = 2
    // Number of outputs = 1
    // Number of rounds = 220
    component hash = MiMCSponge(2, 220, 1);

    //Setting the nonce as 0
    hash.k <== 0;
    // Setting the left input
    hash.ins[0] <== left;
    // Setting the right input
    hash.ins[1] <== right;
    // Setting the output
    out <== hash.outs[0];
}


template CalculateRoot(N) {
    // The list of input signals, each representing a leaf
    signal input leaves[N];
    // The output signal for the root
    signal output root;

    // An array that stores the hash values
    component hashes[2 * N - 1];
    // Loop control variable to navigate the hashes array
    var i = 2 * N - 2;
    // Counter variable to keep track of nodes at each level of the tree
    var count = 0;
    while(count < N) {
        hashes[i] = calculateHash();
        // Setting the left and right child the same since we are at the leaves
        hashes[i].left <== leaves[count];
        hashes[i].right <== leaves[count];
        // Updating the Loop Control Variable
        i--;
        // Accounting for the leaf currently hashed
        count++;
    }

    // Looping through the hashes array
    var length = N;
    // Continuing the loop until we have reached the starting node
    // The starting node, essentially denotes the root
    while (length > 1) {
        // Whenever we move up a level in the tree
        // The number of nodes is halved
        length = length \ 2;
        // The counter variable is reset
        count = 0;
        // Looping through the nodes at the current level
        while (count < length) {
            hashes[i] = calculateHash();
            // Setting the children among the nodes from the level below it
            // It is ensured that the children have already been hashed before hashing the parent
            hashes[i].left <== hashes[2 * i + 1].out;
            hashes[i].right <== hashes[2 * i + 2].out;
            // Updating the Loop Control Variable
            i--;
            // Accounting for the node currently hashed
            count++;
        }
    }

    // Setting the root hash
    root <== hashes[0].out;
}

// The main component
// The starting point of the circuit
component main {public [leaves]} = CalculateRoot(8);