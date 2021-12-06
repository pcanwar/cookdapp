const Oracle = artifacts.require("Oracle.sol");
const Client = artifacts.require("Client.sol");
const onChain = artifacts.require("onChain.sol");

module.exports = async function (deployer, _network, address) {
  // const [admin, reporter, _] = addresses;
  const admin = address[0];

  await deployer.deploy(Oracle, admin);
  const oracle = await Oracle.deployed();

  await deployer.deploy(Client, oracle.address);
  await Client.deployed();

  const usdcETH = "0x34965ba0ac2451A34a0471F04CCa3F990b8dea27"
    // await oracle.updateReporter(admin, true);
  await deployer.deploy(onChain, usdcETH);
  await onChain.deployed();

};