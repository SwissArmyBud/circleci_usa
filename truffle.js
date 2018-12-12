module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8545,
      network_id: 1234,
      gas: 70 * 100000,
      gasPrice: 20 * 1000000000
    }
  }
}