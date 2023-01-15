// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

interface ERC20Interface {

    //function name() public view returns (string)
    //function symbol() public view returns (string)
    //function decimals() public view returns (uint8)
    // For a token to follow ERC-20 standard it should implement below methods
    // Total supply which defines total supply of tokens and smart contract will refuse to create any further tokens after certain limit reached
    function totalSupply() external view   returns (uint256);
    // retun the number of tokens for a wallet address given
    function balanceOf(address _owner) external view  returns (uint256 balance);
    // Transfer certain amount of tokens from total supply to specific user
    function transfer(address _to, uint256 _value) external  returns (bool success);
    // transfer from one user to another user
    function transferFrom(address _from, address _to, uint256 _value) external  returns (bool success);
    // verifies whether smart contract allowed to allocate certain number of tokens to user considering the total supply
    function approve(address _spender, uint256 _value) external  returns (bool success);
    //If a specific user has enough balance to send tokens to another user
    function allowance(address _owner, address _spender) external view returns (uint256 remaining);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);

}

contract MyToken is ERC20Interface {

    string public symbol;
    string public tokenName;
    uint8 public decimals;
    uint256 public _totalsupply;

    mapping(address => uint256) balances;
    mapping(address => mapping(address => uint256)) allowed;

    constructor() {
        symbol = "NLR";
        tokenName = "Newbie Coin";
        decimals = 2;
        _totalsupply = 1000000;
        balances[0xdF9Afc29acd13a83E9831E958E5669aC7BBC39C9] = _totalsupply;
        emit Transfer(address(0), 0xdF9Afc29acd13a83E9831E958E5669aC7BBC39C9, _totalsupply);    

   }

    function totalSupply() public view override returns (uint256) {
       return _totalsupply - balances[address(0)];

   }

    function balanceOf(address _owner) public view override returns (uint256 balance) {
       return balances[_owner];
   }

    function transfer(address _to, uint256 _value) public override returns (bool success) {
       balances[msg.sender] = balances[msg.sender] - _value;
       balances[_to] = balances[_to] + _value;
       emit Transfer(msg.sender, _to, _value);  
       return true;
   }

    function transferFrom(address _from, address _to, uint256 _value) public override returns (bool success) {
       balances[_from] = balances[_from] - _value;
       allowed[_from][msg.sender] = allowed[_from][msg.sender] - _value;
       balances[_to] = balances[_to] + _value;
       emit Transfer(_from,_to,_value);
       return true;
   }

    function approve(address _spender, uint256 _value) public override returns (bool success) {
       allowed[msg.sender][_spender] = _value;
       emit Approval(msg.sender,_spender,_value);
       return true;
   }

    function allowance(address _owner, address _spender) public view  override returns (uint256 remaining) {
       return allowed[_owner][_spender];
   }



}
