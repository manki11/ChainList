pragma solidity ^0.4.11;


contract ChainList {
    //Custom Types
    struct Article {
    uint id;
    address seller;
    address buyer;
    string name;
    string description;
    uint256 price;
    }

    // State Variables
    mapping(uint => Article) public articles;
    uint articleCounter;

    //Events
    event sellArticleEvent(uint indexed_id,address indexed _seller, string _name, uint256 _price);

    event buyArticleEvent(uint indexed_id,address indexed _seller, address indexed _buyer, string _name, uint256 _price);


    //Sell an article
    function sellArticle(string _name, string _description, uint256 _price) public {
        articleCounter++;

        articles[articleCounter]= Article (
            articleCounter,
            msg.sender,
            0x0,
            _name,
            _description,
            _price
        );

        sellArticleEvent(articleCounter,msg.sender, _name, _price);
    }

    //fetch no of articles
    function getNumberOfArticles() public constant returns (uint){
        return articleCounter;
    }

    //get all articles for sale
    function getArticlesForSale() public constant returns(uint[]){

        require(articleCounter>0);

        uint[] memory articleIds = new uint [](articleCounter);

        uint noOfArticlesForSale=0;

        for(uint i;i<articleCounter;i++){
            if(articles[i].buyer== 0x0){
                articleIds[noOfArticlesForSale]= articles[i].id;
                noOfArticlesForSale++;
            }
        }

        uint[] memory forSale= new uint[](noOfArticlesForSale);
        for(uint j;j<noOfArticlesForSale;j++){
            forSale[j]=articleIds[j];
        }

        return (forSale);
    }

    //Buy an article
    function buyArticle(uint _id) payable public {

        //check whether there is at least one article
        require(articleCounter>0);
        //check whether article exists
        require(_id>0 && _id<articleCounter);
        // retrieve the article
        Article storage article = articles[_id];
        // check conditions
        require(article.buyer == 0x0);
        require(msg.sender != article.seller);
        require(msg.value == article.price);
        article.buyer= msg.sender;
        article.seller.transfer(msg.value);

        buyArticleEvent(_id,article.seller, article.buyer, article.name, article.price);

    }


}