const { expect } = require("chai");
const { ethers } = require("hardhat");
const { loadFixture } = require("@nomicfoundation/hardhat-toolbox/network-helpers");

describe("NFTm dApp Test", function () {
  async function deployEmreTokenFixture() {
    const [owner, addr1, addr2] = await ethers.getSigners();
    const Emre = await ethers.getContractFactory("NFTCreator");
    const emre = await Emre.deploy();
    return { emre, owner, addr1, addr2 };
  }

  it("should mint a new token", async function () {
    const { emre, owner, addr1 } = await loadFixture(deployEmreTokenFixture);

    const tokenId = 1;
    const tokenURI = "https://example.com/nft";

    await emre.connect(owner).mint(addr1.address, tokenId, tokenURI);

    const ownerOfToken = await emre.ownerOf(tokenId);
    expect(ownerOfToken).to.equal(addr1.address);

    const tokenURIFromContract = await emre.tokenURI(tokenId);
    expect(tokenURIFromContract).to.equal(tokenURI);
  });
});