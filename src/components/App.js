import React, { Component } from 'react';
import Web3 from 'web3';
import detectEthereumProvider from '@metamask/detect-provider';
import CryptoBird from '../abis/CryptoBirdz.json';

class App extends Component {

    async componentDidMount() {
        await this.loadWeb3();
        await this.loadBlockchainData();
    }

    // first up is to detect ethereum provider
    async loadWeb3() {
        const provider = await detectEthereumProvider();

        // modern browsers
        if (provider) {
            console.log('Ethereum wallet is connected');
            window.web3 = new Web3(provider);
        } else {
            console.log('no ethereum wallet detected');
        }
    }

    async loadBlockchainData() {
        const web3 = window.web3;
        const accounts = await window.web3.eth.getAccounts();
        this.setState({ account: accounts })

        const networkId = await web3.eth.net.getId();
        const networkData = CryptoBird.networks[networkId];
        if (networkData) {
            const abi = CryptoBird.abi;
            const address = networkData.address;
            const contract = new web3.eth.Contract(abi, address);
            this.setState({ contract });

            const totalSupply = await contract.methods.totalSupply().call();
            this.setState({ totalSupply });

            // load crypto birdz
            for (const i = 0; i < totalSupply; i++) {
                const cryptoBird = await contract.methods.cryptoBirdz(i).call();
                this.setState({
                    cryptoBirdz: [...this.state.cryptoBirdz, cryptoBird]
                });
            }


        } else {
            window.alert('Smart contract not deployed!')
        }

    }

    mint = (cryptoBird) => {
        this.state.contract.methods.mint(cryptoBird).send({ from: this.state.account[0] })
            .once('receipt', (receipt) => {
                this.state({
                    cryptoBirdz: [...this.state.cryptoBirdz, cryptoBird]
                })
            })

    }

    constructor(props) {
        super(props);
        this.state = {
            account: '',
            contract: null,
            totalSupply: 0,
            cryptoBirdz: []
        }
    }

    render() {
        return (
            < div >
                {console.log(this.state.cryptoBirdz)}
                <nav className='navbar navbar-dark fixed-top bg-dark flex-md-nowrap p-0 shadow'>
                    <div className='navbar-brand col-sem-3 col-md-3 mr-0' style={{ color: 'white' }}>
                        Crypto Birdz NFTs (Non-Fungible Tokens)
                    </div>
                    <ul className='navbar-nav px-3'>
                        <li className='nav-item text-nowrap d-none d-sm-none d-sm-block'>
                            <small className='text-white'>
                                {this.state.account}
                            </small>
                        </li>
                    </ul>
                </nav>

                <div className='container-fluid mt-1'>
                    <div className='row'>
                        <main role='main'
                            className='col-lg-12 d-flex text-center'>
                            <div className='content mr-auto ml-auto'
                                style={{ opacity: '0.8' }}>
                                <h1>CryptoBirdz - NFT Marketplace</h1>
                                <form onSubmit={(event) => {
                                    event.preventDefault()
                                    const cryptoBird = this.cryptoBird.value
                                    this.mint(cryptoBird)
                                }}>
                                    <input type='text' placeholder='Add a file location' className='form-control mb-1' ref={(input) => { this.cryptoBird = input }} />
                                    <input style={{ margin: '6px' }} type='submit' className='btn btn-primary btn-black' value='MINT' />
                                </form>
                            </div>
                        </main>
                    </div>
                </div >
            </div >
        )
    }
}

export default App;