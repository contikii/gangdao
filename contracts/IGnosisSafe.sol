// SPDX-License-Identifier: MIT
pragma solidity >=0.7.0 <0.9.0;

// Stripped down version of @gnosis.pm/safe-contracts/contracts/GnosisSafe.sol

interface IGnosisSafe {
    function getOwners() external view returns (address[] memory);

    // these are extra pretty much. checking against erc165 interface might be hard, due to the proxies of safes.
    function setup(
        address[] calldata _owners,
        uint256 _threshold,
        address to,
        bytes calldata data,
        address fallbackHandler,
        address paymentToken,
        uint256 payment,
        address payable paymentReceiver
    ) external;

    /// @dev Allows to add a module to the whitelist.
    ///      This can only be done via a Safe transaction.
    /// @notice Enables the module `module` for the Safe.
    /// @param module Module to be whitelisted.
    function enableModule(address module) external;

    /// @dev Returns if an module is enabled
    /// @return True if the module is enabled
    function isModuleEnabled(address module) external view returns (bool);
}