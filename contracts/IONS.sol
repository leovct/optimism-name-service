//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.12;

/**
 * @title Optimsim Name Service Interface v0.0.0
 * @author leovct
 * @dev Interface of the distributed naming system based on the Optimism blockchain, highly
 * inspired by the Ethereum Name Service (ENS).
 */
interface IONS {
    /***********************************************************************************************
                                            Events
    ***********************************************************************************************/

    /**
     * @dev Event issued when a domain is registered.
     * @param domain the hash of the domain.
     * @param ownerAddress the new address of the domain's owner.
     * @param controllerAddress the new address of the domain's controller.
     * @param optimismAddress the new optimism address to which the domain points.
     * @param ttl the new ttl of the domain.
     */
    event Register(
        bytes indexed domain,
        address ownerAddress,
        address controllerAddress,
        address optimismAddress,
        uint256 ttl
    );

    /**
     * @dev Event issued when a domain is deregistered by its owner.
     * @param domain the hash of the domain.
     */
    event Deregister(bytes indexed domain);

    /**
     * @dev Event issued when the address of a domain's owner changes.
     * @param domain the hash of the domain.
     * @param ownerAddress the new address of the domain's owner.
     */
    event NewOwner(bytes32 indexed domain, address ownerAddress);

    /**
     * @dev Event issued when the address of a domain's controller changes.
     * @param domain the hash of the domain.
     * @param controllerAddress the new address of the domain's controller.
     */
    event NewController(bytes32 indexed domain, address controllerAddress);

    /**
     * @dev Event issued when the address to which a domain points changes.
     * @param domain the hash of the domain.
     * @param optimismAddress the new optimism address to which the domain points.
     */
    event NewAddress(bytes32 indexed domain, address optimismAddress);

    /**
     * @dev Event issued when the TTL of a domain changes.
     * @param domain the hash of the domain.
     * @param ttl the new ttl of the domain.
     */
    event NewTTL(bytes32 indexed domain, uint256 ttl);

    /***********************************************************************************************
                                            Core functions
    ***********************************************************************************************/

    /**
     * @dev Register a new domain.
     * @param domain the hash of the domain.
     * @param ttl the ttl of the domain.
     * @dev This function should emit a Register event.
     */
    function register(bytes32 domain, uint256 ttl) external;

    /**
     * @dev Register a new domain by specifying all the parameters.
     * @param domain the hash of the domain.
     * @param controllerAddress the address of the domain's controller.
     * @param optimismAddress the addres to which the domain points.
     * @param ttl the ttl of the domain.
     * @dev This function should emit a Register event.
     */
    function registerWithParameters(
        bytes32 domain,
        address controllerAddress,
        address optimismAddress,
        uint256 ttl
    ) external;

    /**
     * @dev Deregister a domain. The domain can then be registered by anyone.
     * @param domain the hash of the domain.
     * This function should emit an Deregister event.
     */
    function deregister(bytes32 domain) external;

    /***********************************************************************************************
                                            Getters
    ***********************************************************************************************/

    /**
     * @dev Get the addres of of a domain's owner.
     * @param domain the hash of the domain.
     * @return _ the address of the domain's owner.
     */
    function getOwner(bytes32 domain) external view returns (address);

    /**
     * @dev Get the address of a domain's controller.
     * @param domain the hash of the domain.
     * @return _ the address of the domain's controller.
     */
    function getController(bytes32 domain) external view returns (address);

    /**
     * @dev Get the address to which the domain points.
     * @param domain the hash of the domain.
     * @return _ the address to which the domain points.
     */
    function getAddress(bytes32 domain) external view returns (address);

    /**
     * @dev Get the ttl of a domain.
     * @param domain the hash of the domain.
     * @return _ the ttl of the domain.
     */
    function getTTL(bytes32 domain) external view returns (uint256);

    /***********************************************************************************************
                                            Setters
    ***********************************************************************************************/

    /**
     * @dev Set the address of the domain's owner.
     * @param domain the hash of the domain.
     * @param ownerAddress the new address of the domain's owner.
     * @dev This function should emit a NewOwner event.
     */
    function setOwner(bytes32 domain, address ownerAddress) external;

    /**
     * @dev Set the address of the domain's controller.
     * @param domain the hash of the domain.
     * @param controllerAddress the new address of the domain's controller.
     * @dev This function should emit a NewController event.
     */
    function setController(bytes32 domain, address controllerAddress) external;

    /**
     * @dev Set the address to which the domain points.
     * @param domain the hash of the domain.
     * @param optimismAddress the new optimism address to which the domain points.
     * @dev This function should emit a NewAddress event.
     */
    function setAddress(bytes32 domain, address optimismAddress) external;

    /**
     * @dev Set the ttl of a domain.
     * @param domain the hash of the domain.
     * @param ttl the new ttl of the domain.
     * @dev This function should emit a NewTTL event.
     */
    function setTTL(bytes32 domain, uint256 ttl) external;
}
