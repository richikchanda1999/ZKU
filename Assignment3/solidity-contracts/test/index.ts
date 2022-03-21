import { ethers } from "hardhat";

describe("PseudoRandomGenerator", function () {
  it("Should generate random numbers", async function () {
    const Greeter = await ethers.getContractFactory("PseudoRandomGenerator");
    const greeter = await Greeter.deploy();
    await greeter.deployed();

    for (let i = 0; i < 20; i++) {
      const tx = await greeter.genRandom();
      await tx.wait();

      const random = await greeter.getDiceRoll();
      console.log(random.toNumber());
    }
  });
});
