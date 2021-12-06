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

  const usdcETH = "0x7e8d0e1ad361eba94abc06898f52d9e2c4cda04b"
    // await oracle.updateReporter(admin, true);
  await deployer.deploy(onChain, usdcETH);
  await onChain.deployed();

};