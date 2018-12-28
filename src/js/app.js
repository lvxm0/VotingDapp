App = {
  web3Provider: null,
  Voting: null,

  init: function() {
   return App.initWeb3();
   console.log("init");
  },

  initWeb3: function() {
    if (typeof web3 !== 'undefined') {
      App.web3Provider = web3.currentProvider;
      web3 = new Web3(web3.currentProvider);
    } else {
      App.web3Provider = new Web3.providers.HttpProvider("http://127.0.0.1:7545")
      web3 = new Web3(App.web3Provider);
    }
    return App.initContract();
  },


  initData: function() {
    let candidates = {1: "candidate-1", 2: "candidate-2", 3: "candidate-3"}
    let candidateNames = Object.keys(candidates);
    for (var i = 0; i < candidateNames.length; i++) {
      let name = candidateNames[i];
      console.log(name);
      App.Voting.deployed().then(function(contractInstance) {

          let count = contractInstance.queryVote.call(name);
          console.log(count);
          return count;

          //return contractInstance.queryVote(name);
        }).then(function(v) {
          console.log(v);
          console.log("#" + candidates[name]);
          $("#" + candidates[name]).html(v.toString());
        }).catch(function(err) {
          console.log(err.message);
        });
      }
  },

  initContract: function() {
    $.getJSON('VotingSystem.json', function (data) {
        App.Voting = TruffleContract(data);
        App.Voting.setProvider(App.web3Provider);


      //  return App.initData();
    });

    $("#vote").on("click", App.castVote);
    $("#give").on("click", App.giveRightToVote);
    $("#delegate").on("click", App.delegate);

    //return App.bindEvents();
  },
/*
  bindEvents: function() {
    $(document).on('click', '.btn-adopt', App.handleAdopt);
  },
*/

   castVote: function() {

    let candidateName = $("#candidate").val();

    App.Voting.deployed().then(function(contractInstance) {
        return contractInstance.castVote(candidateName);
      }).then(function(v) {
        App.initData();
      }).catch(function(err) {
        console.log(err.message);
      });

  },

giveRightToVote: function() {
    let addr = $("#giveaddr").val();

    App.Voting.deployed().then(function(contractInstance) {
        return contractInstance.giveRightToVote(addr);
      }).then(function(v) {
        App.initData();
      }).catch(function(err) {
        console.log(err.message);
      });
},

delegate: function() {
    let addr = $("#deladdr").val();

    App.Voting.deployed().then(function(contractInstance) {
        return contractInstance.delegate(addr);
      }).then(function(v) {
        App.initData();
      }).catch(function(err) {
        console.log(err.message);
      });
}


};

$(function() {
  $(window).load(function() {
    App.init();
  });
});
