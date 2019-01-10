/*
Truffle config docs can be found at:
https://truffleframework.com/docs/truffle/reference/configuration
*/
// This config must match the .circleci/config.yml truffle container config
module.exports = {
  networks: {
    development: {
      host: 'localhost',
      port: 8080,
      network_id: 4321,
      gasPrice: (20000000000).toString(),
      gas: (7500000).toString()
    }
  },
  /* Mocha config docs can be found at: https://github.com/mochajs/mocha/wiki/Using-mocha-programmatically#set-options
  */
  mocha: {
    useColors: true
  }
}
