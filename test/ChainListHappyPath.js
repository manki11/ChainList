var ChainList= artifacts.require("./ChainList.sol");


contract('ChainList', function (accounts) {

    var ChainListInstance;
    var seller= accounts[1];
    var articleName= "article1";
    var articleDesc="Desc of article 1";
    var articlePrice=10;

    // Test case to check initial values
    it("should be initialized with empty values", function () {
        return ChainList.deployed().then(function (instance) {
            return instance.getArticle.call();
        }).then(function (data) {
            assert.equal(data[0],0x0, "Seller must be empty");
            assert.equal(data[1],'', "Article name must be empty");
            assert.equal(data[2],'', "Desc must be empty");
            assert.equal(data[3].toNumber(),0, "Article Price must be 0");
        });
    });

    //Test case to sell Article
    it("should sell an article", function() {
        return ChainList.deployed().then(function(instance) {
            ChainListInstance = instance;
            return ChainListInstance.sellArticle(articleName, articleDesc, web3.toWei(articlePrice, "ether"), {
                from: seller
            });
        }).then(function() {
            return ChainListInstance.getArticle.call();
        }).then(function(data) {
            assert.equal(data[0], seller, "seller must be " + seller);
            assert.equal(data[1], articleName, "article name must be " + articleName);
            assert.equal(data[2], articleDesc, "article descriptio must be " + articleDesc);
            assert.equal(data[3].toNumber(), web3.toWei(articlePrice, "ether"), "article price must be " + web3.toWei(articlePrice, "ether"));
        });
    });

    // Test case: should check events
    it("should trigger an event when a new article is sold", function() {
        return ChainList.deployed().then(function(instance) {
            chainListInstance = instance;
            watcher = chainListInstance.sellArticleEvent();
            return chainListInstance.sellArticle(
                articleName,
                articleDesc,
                web3.toWei(articlePrice, "ether"), {from: seller}
            );
        }).then(function() {
            return watcher.get();
        }).then(function(events) {
            assert.equal(events.length, 1, "should have received one event");
            assert.equal(events[0].args._seller, seller, "seller must be " + seller);
            assert.equal(events[0].args._name, articleName, "article name must be " + articleName);
            assert.equal(events[0].args._price.toNumber(), web3.toWei(articlePrice, "ether"), "article price must be " + web3.toWei(articlePrice, "ether"));
        });
    });

});