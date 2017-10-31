pragma solidity ^0.4.11;


contract ChainList {

    // State Variables
    address seller;
    address buyer;
    string name;
    string description;

    uint256 price;

    //Events
    event sellArticleEvent(address indexed _seller, string _name, uint256 _price);

    event buyArticleEvent(address indexed _seller, address indexed _buyer, string _name, uint256 _price);


    //Sell an article
    function sellArticle(string _name, string _description, uint256 _price) public {
        seller = msg.sender;
        name = _name;
        description = _description;
        price = _price;
        sellArticleEvent(seller, name, price);
    }

    //Get an article
    function getArticle() public constant returns (
    address _seller,
    address _buyer,
    string _name,
    string _description,
    uint256 _price
    ){
        return (seller, buyer, name, description, price);
    }

    //Buy an article
    function buyArticle() payable public {

        require(seller != 0x0);
        require(buyer == 0x0);
        require(msg.sender != seller);
        require(msg.value == price);
        buyer= msg.sender;
        seller.transfer(msg.value);

        buyArticleEvent(seller, buyer, name, price);

    }


}