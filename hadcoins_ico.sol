//Hadcoins ico

pragma solidity  >=0.8.2 < 0.9.0;
contract hadcoin_ico{
    //introducing the maximum number of hadcoins available for sale
    uint public max_hadcoins=1000000;

    // introducing the USD to hadcoins conversion rate 
    uint public usd_to_hadcoins=1000;
    
    //introducing the total number of hadcoins that have been bought by the investors
    uint public total_hadcoins_bought=0;
    //mapping from the investors address to its equity in hadcoins and USD
    mapping(address=>uint)equity_hadcoins;
    mapping(address=>uint)equity_usd;
    //checking if an investor can buy hadcoins
    modifier can_buy_hadcoins(uint usd_invested){
        //this is the condition we must check
        require(usd_invested * usd_to_hadcoins + total_hadcoins_bought <= max_hadcoins);
        _;
    }
    //getting the equity in hadcoins of an investor

    function equity_in_hadcoins(address investor) external constant returns(uint){
            //the function with which we will interact in Myetherwallet
            return equity_hadcoins[investor];
        }
    //getting the equity in usd of an investor
    function equity_in_usd(address investor) external constant returns(uint){
            //the function with which we will interact in Myetherwallet
            return equity_usd[investor];
        }
    //buying hadcoins
    function buy_hadcoins(address investor , uint usd_invested) external
    can_buy_hadcoins(usd_invested){
        uint hadcoins_bought= usd_invested* usd_to_hadcoins;
        equity_hadcoins[investor]+=hadcoins_bought;
        equity_usd[investor]= equity_hadcoins[investor]/1000;
        total_hadcoins_bought+=hadcoins_bought;
    }
    //selling hadcoins
    function sell_hadcoins(address investor , uint hadcoins_sold) external{
        equity_hadcoins[investor] -=hadcoins_sold;
        equity_usd[investor]= equity_hadcoins[investor]/1000;
        total_hadcoins_bought-=hadcoins_sold;       
    }
}
