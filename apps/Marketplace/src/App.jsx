import {
  BrowserRouter,
  Routes,
  Route
} from "react-router-dom";
import Navigation from './Navbar';
import Home from './Home.jsx'
import Create from './Create.jsx'
import MyListedItems from './MyListedItems.jsx'
import MyPurchases from './MyPurchases.jsx'
import MarketplaceAbi from '../../../artifacts/contracts/MarketPlace.sol/MarketPlace.json'
import MarketplaceAddress from '../../../artifacts/contracts/MarketPlace.sol/MarketPlace-address.json'
import TicketAbi from '../../../artifacts/contracts/Ticket.sol/Ticket.json'
import TicketAddress from '../../../artifacts/contracts/Ticket.sol/Tiket-address.json'
import { SetStateAction, useState } from 'react'
import { ethers } from "ethers"
import { Spinner } from 'react-bootstrap'
import './App.css';

function App() {
  const [loading, setLoading] = useState(true)
  const [account, setAccount] = useState(null)
  const [ticket, setTicket] = useState({})
  const [marketplace, setMarketplace] = useState({})
  // MetaMask Login/Connect
  const web3Handler = async () => {
    const accounts = await window.ethereum.request({ method: 'eth_requestAccounts' });
    setAccount(accounts[0])
    // Get provider from Metamask
    const provider = new ethers.providers.Web3Provider(window.ethereum)
    // Set signer
    const signer = provider.getSigner()

    window.ethereum.on('chainChanged', (chainId) => {
      window.location.reload();
    })

    window.ethereum.on('accountsChanged', async function (accounts) {
      setAccount(accounts[0])
      await web3Handler()
    })
    loadContracts(signer)
  }
  const loadContracts = async (signer) => {
    // Get deployed copies of contracts
    const marketplace = new ethers.Contract(MarketplaceAddress.address, MarketplaceAbi.abi, signer)
    setMarketplace(marketplace)
    const ticket = new ethers.Contract(TicketAddress.address, TicketAbi.abi, signer)
    setTicket(ticket)
    setLoading(false)
  }

  return (
    <BrowserRouter>
      <div className="App">
        <>
          <Navigation web3Handler={web3Handler} account={account} />
        </>
        <div>
          {loading ? (
            <div style={{ display: 'flex', justifyContent: 'center', alignItems: 'center', minHeight: '80vh' }}>
              <Spinner animation="border" style={{ display: 'flex' }} />
              <p className='mx-3 my-0'>Awaiting Metamask Connection...</p>
            </div>
          ) : (
            <Routes>
              <Route path="/" element={
                <Home marketplace={marketplace} ticket={ticket} />
              } />
              <Route path="/create" element={
                <Create marketplace={marketplace} ticket={ticket} />
              } />
              <Route path="/my-listed-items" element={
                <MyListedItems marketplace={marketplace} ticket={ticket} account={account} />
              } />
              <Route path="/my-purchases" element={
                <MyPurchases marketplace={marketplace} ticket={ticket} account={account} />
              } />
            </Routes>
          )}
        </div>
      </div>
    </BrowserRouter>

  );
}

export default App;