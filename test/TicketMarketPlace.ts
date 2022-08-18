import { MarketPlace } from './../typechain-types/contracts/MarketPlace';
import { NameChangedEvent } from './../typechain-types/did/Identity';
import { Ticket } from './../typechain-types/contracts/Ticket';
import { ethers } from 'hardhat';
import { GetContractTypeFromFactory } from '../typechain-types/common';
const {expect} =require("chai");

describe("TicketMarcketPlace", async function(){
    let deployer,add1,add2, ticket,marketplace;
    let feePercent=1;

    this.beforeAll(async () => {
        const Ticket = await ethers.getContractFactory("Ticket");
        const MarcketPlace = await ethers.getContractFactory("MarketPlace");
        [deployer,add1,add2]= await ethers.getSigners();
        ticket= await Ticket.deploy();
        const marcketplace = await MarcketPlace.deploy(feePercent); 
    })

    it("should track name and symbole of the ticket collection", async function(){

        console.log(ticket);
        
        expect(await ticket.name()).to.equal("SportTicket");
        expect(await ticket.symbole()).to.equal("Ticket");
    })


    it("should track name and symbole of the ticket collection", async function(){
        expect(await ticket.name()).to.equal("SportTicket");
        expect(await ticket.symbole()).to.equal("Ticket");
    })

    it("should track feeAccount and feePercent of the MarcketPllace", async function(){
        expect(await this.MarketPlace.name()).to.equal(this.deployer.address);
        expect(await this.MarketPlace.symbole()).to.equal(this.feePercent);
    })
});


// describe("Deployment",function(){
//     it("should track name and symbole of the ticket collection", async function(){
//         expect(await this.ticket.name()).to.equal("SportTicket");
//         expect(await this.ticket.symbole()).to.equal("Ticket");
//     })
//     it("should track feeAccount and feePercent of the MarcketPllace", async function(){
//         expect(await this.MarketPlace.name()).to.equal(this.deployer.address);
//         expect(await this.MarketPlace.symbole()).to.equal(this.feePercent);
//     })
// });
// describe("Minting Tickets", function(){
//     it("should track ech minted Ticket", async function(){
//         await this.ticket.connect(this.add1).mint(this.URI)
//         expect(await this.ticket.tokenCount()).to().equal(1);
//         expect(await this.ticket.balanceOf(this.add1.address)).to().equal(1);
//         expect(await this.ticket.tokenURI(1)).to().equal(this.URI);
//         await this.ticket.connect(this.add2).mint(this.URI)
//         expect(await this.ticket.tokenCount()).to().equal(2);
//         expect(await this.ticket.balanceOf(this.add1.address)).to().equal(1);
//         expect(await this.ticket.tokenURI(2)).to().equal(this.URI);

//     });
// });
// describe("Making Market place items", function(){
// this.beforeEach( async function(){
//     await this.ticket.connect(this.add1).mint(this.URI)
//     await this.ticket.connect(this.add1).setApprovalForAll(this.marketplace.address.true)
// })
// it("hould track newly created item, transfer Ticket fromseller to market place and emit offered event", async function (){
// await expect (this.marketplace.connect(this.add1).makeItem(this.ticket.address, 1,this.toWei(1))).to.emit(this.marketplace,"Offered").withArg(
//     1,this.ticket.address,1,this.toWei,this.add1.address
// )
// expect(await this.tiket.ownerOf(1)).to.equal(this.MarketPlace.address);
// expect(await this.MarketPlace.itemCount()).to.equal(1);
// const item =await this.marketplace.Items(1);
// expect(await this.MarketPlace.itemCount()).to.equal(1);
// expect(this.ticket.item).to.equal(this.ticket.address);
// expect(item.tokenId).to.equal(1);
// expect(item.price).to.equal(this.toWei(1));
// expect(item.sold).to.equal(false);
// it("should fail if price is set to zero", async function(){
//  await expect (
//     this.MarketPlace.connect(this.add1).makeItem(this.ticket.address,1,0)).to.be.revertedWith("Price must be greater than zero");
// });
// });
// describe("Purchasing marketplace items", function(){
//     this.beforeEach(async function(){
//         await this.ticket.connect(this.add1).mint(this.URI);
//         await this.ticket.connect(this.add1).setApprouvalForAll(this.marketplace.address,true);
//         await this.marketplace.connect(this.add1).makeItem(this.tiket.address,1,this.toWei(2));
//     })
//     it("dhould update item as sold,pay saller, transfer tiket to buyer, charge fees and emit a bougth event", async function(){
//         const sellerIntialEthBal= await this.add1.getBalance();
//         const feeAccountInitialEthBal= await this.deployer.getBalance();
//         let totalPriceInWei = await this.marketplace.getTotalPrice(1);
//         await expect(this.marketplace.connect.perchaicetem(1,{value:this.totalPriceInWei}))
//         .to.emit(this.marketplace," Bought").withArgs(1,this.tiket.address,1,this.toWei(this.price),this.add1.address,this.add2.address)
//         const sellerFinalEthBal= await this.add1.getBalance();
//         const feeAccountFinalEthBal= await this.deployer.getBalance();
//         expect (+this.fromWei(feeAccountFinalEthBal)).to.equal(+this.fee+this.fromWei(sellerFinalEthBal))
//         const fee=(this.feePercent/100)* this.price;
//         expect (+this.fromWei(feeAccountFinalEthBal)).to.equal(+this.price+this.fromWei(sellerFinalEthBal))
//         expect((await this.ticket.ownerOf(1))).to.equal(this.add2.address);
//         expect((await this.marketplace.items(1)).sold).to.equal(true);
        
//     })

// });
// })


