#! /bin/sh
circom location.circom --r1cs --wasm --sym --c
node location_js/generate_witness.js location_js/location.wasm input.json witness.wtns

snarkjs powersoftau new bn128 8 pot14_0000.ptau
snarkjs powersoftau contribute pot14_0000.ptau pot14_0001.ptau --name="First contribution"
snarkjs powersoftau prepare phase2 pot14_0001.ptau pot14_final.ptau
snarkjs groth16 setup location.r1cs pot14_final.ptau location_0000.zkey
snarkjs zkey contribute location_0000.zkey location_0001.zkey --name="Key name"
snarkjs zkey export verificationkey location_0001.zkey verification_key.json
snarkjs groth16 prove location_0001.zkey witness.wtns proof.json public.json
snarkjs groth16 verify verification_key.json public.json proof.json -v