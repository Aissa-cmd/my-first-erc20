// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.30;

contract Ownable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

contract ERC20 is Ownable {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    string public name;
    string public symbol;
    uint8 public immutable decimals;
    uint256 public totalSupply;

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    function transfer(address to, uint256 value) external returns (bool) {
        return _transfer(msg.sender, to, value);
    }

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool) {
        require(
            allowance[from][msg.sender] >= value,
            "ERC20: allowance too low"
        );

        allowance[from][msg.sender] -= value;

        emit Approval(from, msg.sender, allowance[from][msg.sender]);

        return _transfer(from, to, value);
    }

    function approve(address spender, uint256 value) external returns (bool) {
        allowance[msg.sender][spender] += value;

        emit Approval(msg.sender, spender, allowance[msg.sender][spender]);

        return true;
    }

    function mint(address to, uint256 value) external onlyOwner {
        _mint(to, value);
    }

    function burn(address from, uint256 value) external onlyOwner {
        _burn(from, value);
    }

    function _transfer(
        address from,
        address to,
        uint256 value
    ) private returns (bool) {
        require(balanceOf[from] >= value, "ERC20: insufficient balance");

        balanceOf[from] -= value;
        balanceOf[to] += value;

        emit Transfer(from, to, value);

        return true;
    }

    function _mint(address to, uint256 value) internal {
        balanceOf[to] += value;
        totalSupply += value;

        emit Transfer(address(0), to, value);
    }

    function _burn(address from, uint256 value) internal {
        balanceOf[from] -= value;
        totalSupply -= value;

        emit Transfer(from, address(0), value);
    }
}
