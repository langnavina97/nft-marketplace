const { assert } = require('chai');

const CryptoBirdz = artifacts.require('./CryptoBirdz');

require('chai').use(require('chai-as-promised')).should();

contract('CryptoBirdz', (accounts) => {
    let contract;

    before(async () => {
        contract = await CryptoBirdz.deployed();
    });


    describe('deployment', async () => {
        it('deploys successfully', async () => {
            const address = contract.address;
            assert.notEqual(address, '');
            assert.notEqual(address, null);
            assert.notEqual(address, undefined);
            assert.notEqual(address, 0x0);
        });

        it('name matches the contract name', async () => {
            const name = await contract.name();
            assert.equal(name, 'CryptoBird')
        })

        it('symbol matches the contract name', async () => {
            const symbol = await contract.symbol();
            assert.equal(symbol, "CBIRD")
        });
    })

    describe('minting', async () => {
        it('creates a new token', async () => {
            const result = await contract.mint('https...1');
            const totalSupply = await contract.totalSupply();

            //Success
            assert.equal(totalSupply, 1);
            const event = result.logs[0].args;
            assert.equal(event._from, '0x0000000000000000000000000000000000000000', 'from is the contract');
            assert.equal(event._to, accounts[0], 'to is msg.sender');

            // Failure
            await contract.mint('https...1').should.be.rejected;
        })
    })

    describe('indexing', async () => {
        it('lists cryptobirdz', async () => {
            await contract.mint('https...2');
            await contract.mint('https...3');
            await contract.mint('https...4');
            const totalSupply = await contract.totalSupply();

            // loop through list and grab CBirds
            let result = [];
            let cryptoBird;
            for (i = 0; i < totalSupply; i++) {
                cryptoBird = await contract.cryptoBirdz(i);
                result.push(cryptoBird);
            }
            let expected = ['https...1', 'https...2', 'https...3', 'https...4'];
            assert.equal(result.join(','), expected.join(','));
        })
    })
})