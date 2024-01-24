pragma solidity 0.5.17;

import "@protocol/ComptrollerFixer.sol";

/// @notice deploy fixer contracts
contract DeployFixerContracts {
    ComptrollerFixer comptroller;

    /// @notice contract creation event
    event ContractCreated(address);

    constructor() public {
        _deployComptrollerFixer();
    }

    /// @notice deploy comptroller fixer contract
    function _deployComptrollerFixer() private {
        comptroller = new ComptrollerFixer();
        require(address(comptroller) != address(0));

        emit ContractCreated(address(comptroller));
    }
}
