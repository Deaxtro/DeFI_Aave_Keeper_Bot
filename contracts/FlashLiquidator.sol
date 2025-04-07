// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import {IPoolAddressesProvider, IPool} from "@aave/core-v3/contracts/interfaces/IPoolAddressesProvider.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

interface IFlashLoanReceiver {
    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external returns (bool);
}

contract FlashLiquidator is IFlashLoanReceiver {
    IPoolAddressesProvider public immutable provider;
    address public owner;

    event ProfitWithdrawn(address to, uint amount);

    constructor(address _provider) {
        provider = IPoolAddressesProvider(_provider);
        owner = msg.sender;
    }

    function executeOperation(
        address[] calldata assets,
        uint256[] calldata amounts,
        uint256[] calldata premiums,
        address initiator,
        bytes calldata params
    ) external override returns (bool) {
        // Decode parameters
        (address user, address collateralAsset, address debtAsset, uint256 debtToCover) = abi.decode(
            params,
            (address, address, address, uint256)
        );

        IPool pool = IPool(provider.getPool());

        // Approve the pool to pull the debt asset
        IERC20(debtAsset).approve(address(pool), debtToCover);

        // Perform liquidation
        pool.liquidationCall(collateralAsset, debtAsset, user, debtToCover, false);

        // Repay the flash loan
        uint totalOwed = amounts[0] + premiums[0];
        IERC20(assets[0]).approve(address(pool), totalOwed);

        return true;
    }

    function withdrawProfit(address token) external {
        require(msg.sender == owner, "Not owner");
        uint balance = IERC20(token).balanceOf(address(this));
        IERC20(token).transfer(owner, balance);
        emit ProfitWithdrawn(owner, balance);
    }
}
