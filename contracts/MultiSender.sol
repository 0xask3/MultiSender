//SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.6;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiSender is Ownable{
    using SafeMath for uint256;

    uint256 private fee;
    uint256 private arrayLimit;

    event Multisended(uint256 total, address tokenAddress);
    event ClaimedFees(address token, address owner, uint256 balance);

    receive() external payable {}

    constructor() {
        setArrayLimit(200);
        setFee(0);
    }
 

    function getArrayLimit() public view returns(uint256) {
        return arrayLimit;
    }

    function setArrayLimit(uint256 _newLimit) public onlyOwner {
        require(_newLimit != 0);
        arrayLimit = _newLimit;
    }


    function getFee() public view returns(uint256) {
        return fee;
    }


    function setFee(uint256 _newFee) public onlyOwner {
        fee = _newFee;
    }

    function multisendToken(address token, address[] memory _contributors, uint256[] memory _balances) external payable {
        uint256 total = 0;
        require(msg.value >= fee,"Insufficient amount of ether provided");
        require(_contributors.length <= getArrayLimit(),"Array length exceeds limit");
        require(_contributors.length == _balances.length,"Array length mismatch");
        IERC20 erc20token = IERC20(token);

        for (uint8 i = 0; i < _contributors.length; i++) {
            erc20token.transferFrom(msg.sender, _contributors[i], _balances[i]);
            total += _balances[i];
        }

        emit Multisended(total, token);
    }

    function multisendEther(address payable[] memory _contributors, uint256[] memory _balances) external payable {
        uint256 total = msg.value;
        require(total >= fee,"Insufficient amount of ether provided");
        require(_contributors.length == _balances.length,"Array length mismatch");
        require(_contributors.length <= getArrayLimit(),"Array length exceeds limit");
        total = total.sub(fee);

        for (uint8 i = 0; i < _contributors.length; i++) {
            require(total >= _balances[i]);
            total = total.sub(_balances[i]);
            _contributors[i].transfer(_balances[i]);
        }

        emit Multisended(msg.value, 0x000000000000000000000000000000000000bEEF);
    }

    function claimFees(address _token) external onlyOwner {
        if (_token == address(0x0)) {
            payable(owner()).transfer(address(this).balance);
            return;
        }
        IERC20 erc20token = IERC20(_token);
        uint256 balance = erc20token.balanceOf(address(this));
        erc20token.transfer(owner(), balance);
        emit ClaimedFees(_token, owner(), balance);
    }

}