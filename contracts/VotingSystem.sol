pragma solidity 0.5.0;

contract VotingSystem {
  //投票人
   struct Voter {
        uint voteCount; // 票数
        bool voted;  // 是否投票
        address delegate; // 委托人
       // uint voteNumber;   // 候选人序号
        uint voteName;// 候选人名称
  }
  modifier restricted() {
    if (msg.sender == chairperson) _;
  }

  //候选人数组
  uint[] public candi_Array;
  
  //投票箱:<候选人名字,票数>的哈希表
  mapping (uint => uint) public ballotBox;
  
  //投票人映射
  mapping(address => Voter) public voters;

  address public chairperson;

  //构造函数将候选人bytes32数组作为参数初始化
   constructor(uint[] memory names) public {
    chairperson = msg.sender;
    voters[chairperson].voteCount = 1;
    candi_Array = names;
    for(uint i = 0; i < candi_Array.length; i++) {
      ballotBox[ candi_Array[i] ] = 0;
    }
  }
 /* function VotingSystem(uint[] names) {
    chairperson = msg.sender;
    voters[chairperson].voteCount = 1;

    candi_Array = names;
  }
*/
  // 查询候选人的票数
  function queryVote(uint name) public  returns (uint) {
    
    bool flag=false;
     for(uint i = 0; i < candi_Array.length; i++) {
      if (candi_Array[i] == name) {
        flag=true;
       // return ballotBox[name];
      }
    }
    require( flag==true);
    return ballotBox[name];
    //if(flag == false) throw;
  }

  // 投票
  function castVote(uint name) public {

    Voter storage sender = voters[msg.sender];
    require(!sender.voted);
    
    sender.voted = true;
    sender.voteName = name;
    ballotBox[name] += sender.voteCount;
    //if(flag == false) throw;

  }
  
  //分发选票，一人一张
  function giveRightToVote(address voter) public{
    require(
            (msg.sender == chairperson) &&
            (voters[voter].voted == false) &&
            (voters[voter].voteCount == 0)
        );
        voters[voter].voteCount = 1;
  }
  
  //把自己的投票授权给别人
 function delegate(address other) public {
        
        Voter storage sender = voters[msg.sender];
        //发送方需要没有投票过
        require(sender.voted == false);
        //不能自己委托自己
        require(other != msg.sender);

        //如果委托人也有委托人，就往前找，直到直到最终的委托人
        while (voters[other].delegate != address(0)) {
            other = voters[other].delegate;
            require(other != msg.sender);
        }

        
        sender.voted = true;
        sender.delegate = other;
        Voter storage reciver = voters[other];
        if (reciver.voted == true) {
           //给委托人权重的人投票
            ballotBox[reciver.voteName] += sender.voteCount;
        } else {
            //增加票数
            reciver.voteCount += sender.voteCount;
        }
    }
}