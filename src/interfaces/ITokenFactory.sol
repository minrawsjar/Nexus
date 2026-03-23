//SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/** 
 * @title  ITokenFactory
 * @notice Interface for the NEXUS TokenFactory used to deploy ERC-20 clones,
 *         manage a registry, and execute Merkle-based airdrops.
 * @author Swarnim Raj
 */

 interface ITokenFactory {
    /** @notice Onchain metadata struct for deployed tokens, stored in the factory registry.
        *  @param token The address of the deployed token contract.
        *  @param deployer The address of the account that deployed the token.
        *  @param name The name of the deployed token.
        *  @param symbol The symbol of the deployed token.
        *  @param decimals The decimals of the deployed token.
        *  @param maxSupply The maximum supply of the deployed token.
        *  @param deployedAt The timestamp when the token was deployed(Block.timestamp).
     */
    struct TokenConfig {
        address token;
        address deployer;
        string name;
        string symbol;
        uint8 decimals;
        uint256 maxSupply;
        uint256 deployedAt;
    }

    

/*//////////////////////////////////////////////////////////////
                             ERROR
//////////////////////////////////////////////////////////////*/

/// @dev Thrown when invalid decimals are provided for token creation.
error TF__InvalidDecimals(uint8 decimals);

/// @dev Thrown when a zero address is provided where it is not allowed.
error TF__ZeroAddress();

/// @dev Thrown when a token with the same name and symbol already exists.
error TF__TokenAlreadyExists(string name, string symbol);

/// @dev Thrown when a token is deployed with an invalid OR empty name.
error TF__InvalidTokenName(string name);

/// @dev Thrown when a token is deployed with an invalid OR empty symbol.
error TF__InvalidTokenSymbol(string symbol);

/// @dev Thrown when Token is not registered in the factory registry.
error TF__TokenNotRegistered(address tokenAddress);

/// @dev Thrown when fee is too high for token creation.
error TF__FeeTooHigh(uint256 fee, uint256 maxFee);

/*//////////////////////////////////////////////////////////////
                            EVENTS
//////////////////////////////////////////////////////////////*/

/// @notice Emitted on a successful token deployment {deploToken} call.
event TokenDeployed(
    address indexed token,
    address indexed deployer,
    string name,
    string symbol,
    uint256 initialSupply
);

/// @notice Emitted when deployment fee is updated by the owner.
event DeployFeeUpdated(uint256 oldFee, uint256 newFee);

/// @notice Emitted when accumulated ETH fees are swept
event FeesSwept(address to, uint256 amount);

/*//////////////////////////////////////////////////////////////
                        VIEW FUNCTIONS
//////////////////////////////////////////////////////////////*/

/// @notice ETH fee required to deploy a new token via the factory.
function deployFee() external view returns (uint256);

/// @notice Total number of tokens deployed via the factory.
function totalTokens() external view returns (uint256);

/// @notice Return config for a deployed token by address.
function getTokenConfig(address token) external view returns (TokenConfig memory);

/// @notice Return paginated list of deployed tokens addresses.
function getDeployedTokens(uint256 offset, uint256 limit) external view returns (address[] memory);

/*//////////////////////////////////////////////////////////////
                           EXTERNAL FUNCTIONS
//////////////////////////////////////////////////////////////*/

/** @notice Deploys a new ERC-20 token via the factory.
    *  @param name_ The name of the token.
    *  @param symbol_ The symbol of the token.
    *  @param decimals_ The decimals of the token.
    *  @param initialSupply_ The initial supply of the token.
    *  @param maxSupply_ The maximum supply of the token.
    *  @param owner_ The address of the owner of the token.
    *  @return token The address of the deployed token.
*/

function deployToken(
    string calldata name_,
    string calldata symbol_,
    uint8 decimals_,
    uint256 initialSupply_,
    uint256 maxSupply_
    address owner_
) external payable returns (address token);

/** 
* @notice Update the ETH fee charged per deployment.
* Caller must be the owner of the factory.
* @param newFee The new deployment fee in wei.
*/

function setDeployFee(uint256 newFee) external;

/** @notice Sweep accumulated ETH fees to 'to'
* Caller must be the owner of the factory.
* @param to Recipient of the ETH.
*/
function sweepFees(address payable to) external;

}