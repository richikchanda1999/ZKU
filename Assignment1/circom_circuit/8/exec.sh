#! /bin/sh
circom merkle.circom --r1cs --wasm --sym --c
node merkle_js/generate_witness.js merkle_js/merkle.wasm input.json witness.wtns

snarkjs powersoftau new bn128 16 pot16_0000.ptau
snarkjs powersoftau contribute pot16_0000.ptau pot16_0001.ptau --name="First contribution"
snarkjs powersoftau prepare phase2 pot16_0001.ptau pot16_final.ptau
snarkjs groth16 setup merkle.r1cs pot16_final.ptau merkle_0000.zkey
snarkjs zkey contribute merkle_0000.zkey merkle_0001.zkey --name="Key name"
snarkjs zkey export verificationkey merkle_0001.zkey verification_key.json
snarkjs groth16 prove merkle_0001.zkey witness.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json -v
