// Allows us to use ES6 in our migrations and tests.

module.exports = {
    rpc: {
        host: 'localhost',
        port: 8545,
        gas: 1900000,
    },
    migrations_directory: './migrations'
}
