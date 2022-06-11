//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./IONS.sol";

/**
 * @title Optimsim Name Service Contract v0.0.0
 * @author leovct
 * @notice Implementation of the distributed naming system based on the Optimism blockchain, highly
 * inspired by the Ethereum Name Service (ENS).
 */
contract ONS is IONS {
    struct Record {
        // The address of the domain's owner.
        address ownerAddress;
        // The address of the controller's owner.
        address controllerAddress;
        // The address linked to this domain.
        address optimismAddress;
        // The date when this domain will expire and can be renewed by its current owner or
        // requested by someone else.
        uint256 ttl;
    }

    // This mapping allows to obtain the records of a domain.
    mapping(bytes32 => Record) domainToRecord;

    // This mapping allows to know if a domain exists or not.
    mapping(bytes32 => bool) domainToExist;

    /***********************************************************************************************
                                            Modifiers
    ***********************************************************************************************/

    /**
     * @dev Call the function only if the domain exists.
     * @param _domain the hash of the domain.
     */
    modifier exist(bytes32 _domain) {
        require(domainToExist[_domain], "The domain does not exist");
        _;
    }

    /**
     * @dev Call the function only if the domain does not exist.
     * @param _domain the hash of the domain.
     */
    modifier doesNotExist(bytes32 _domain) {
        require(!domainToExist[_domain], "The domain already exists");
        _;
    }

    /**
     * @dev Call the function only if the provided bytes string is not empty.
     * @param _bytes the bytes string.
     */
    modifier notEmpty(bytes32 _bytes) {
        require(_bytes != bytes32(0), "The bytes parameter cannot be empty");
        _;
    }

    /**
     * @dev Call the function only if the provided unsigned integer is strictly superior to zero.
     * @param _n the unsigned integer.
     */
    modifier superiorToZero(uint256 _n) {
        require(
            _n > 0,
            "The unsigned integer parameter cannot be equal to zero"
        );
        _;
    }

    /**
     * @dev Only authorize the owner of the domain to call the function.
     * @param _domain the hash of the domain.
     */
    modifier onlyOwner(bytes32 _domain) {
        require(
            msg.sender == domainToRecord[_domain].ownerAddress,
            "Only the owner can call this method"
        );
        _;
    }

    /**
     * @dev Only authorize the owner and the controller of the domain to call the function.
     * @param _domain the hash of the domain.
     */
    modifier onlyOwnerOrController(bytes32 _domain) {
        require(
            msg.sender == domainToRecord[_domain].ownerAddress ||
                msg.sender == domainToRecord[_domain].controllerAddress,
            "Only the owner and the controller can call this method"
        );
        _;
    }

    /***********************************************************************************************
                                            Core
    ***********************************************************************************************/

    function register(bytes32 _domain, uint256 _ttl)
        external
        override
        notEmpty(_domain)
        superiorToZero(_ttl)
        doesNotExist(_domain)
    {
        domainToExist[_domain] = true;
        domainToRecord[_domain] = Record(
            msg.sender,
            msg.sender,
            msg.sender,
            _ttl
        );
    }

    /**
     * @dev The controller and optimism addresses can be set to the black hole addres.
     */
    function registerWithParameters(
        bytes32 _domain,
        address _controllerAddress,
        address _optimismAddress,
        uint256 _ttl
    )
        external
        override
        notEmpty(_domain)
        superiorToZero(_ttl)
        doesNotExist(_domain)
    {
        domainToExist[_domain] = true;
        domainToRecord[_domain] = Record(
            msg.sender,
            _controllerAddress,
            _optimismAddress,
            _ttl
        );
    }

    function deregister(bytes32 _domain)
        external
        override
        notEmpty(_domain)
        exist(_domain)
        onlyOwner(_domain)
    {
        domainToExist[_domain] = false;
    }

    /***********************************************************************************************
                                            Getters
    ***********************************************************************************************/

    function getOwner(bytes32 _domain)
        external
        view
        override
        notEmpty(_domain)
        exist(_domain)
        returns (address)
    {
        return domainToRecord[_domain].ownerAddress;
    }

    function getController(bytes32 _domain)
        external
        view
        override
        notEmpty(_domain)
        exist(_domain)
        returns (address)
    {
        return domainToRecord[_domain].controllerAddress;
    }

    function getAddress(bytes32 _domain)
        external
        view
        override
        notEmpty(_domain)
        exist(_domain)
        returns (address)
    {
        return domainToRecord[_domain].optimismAddress;
    }

    function getTTL(bytes32 _domain)
        external
        view
        override
        notEmpty(_domain)
        exist(_domain)
        returns (uint256)
    {
        return domainToRecord[_domain].ttl;
    }

    /***********************************************************************************************
                                            Setters
    ***********************************************************************************************/

    function setOwner(bytes32 _domain, address _ownerAddress)
        external
        override
        notEmpty(_domain)
        exist(_domain)
        onlyOwner(_domain)
    {
        require(
            _ownerAddress != address(0),
            "The owner address cannot be null"
        );
        domainToRecord[_domain].ownerAddress = _ownerAddress;
        emit NewOwner(_domain, _ownerAddress);
    }

    /**
     * @dev The controller address can be set to the black hole addres.
     */
    function setController(bytes32 _domain, address _controllerAddress)
        external
        override
        notEmpty(_domain)
        exist(_domain)
        onlyOwner(_domain)
    {
        domainToRecord[_domain].controllerAddress = _controllerAddress;
        emit NewController(_domain, _controllerAddress);
    }

    /**
     * @dev The optimism address can be set to the black hole addres.
     */
    function setAddress(bytes32 _domain, address _optimismAddress)
        external
        override
        notEmpty(_domain)
        exist(_domain)
        onlyOwnerOrController(_domain)
    {
        domainToRecord[_domain].optimismAddress = _optimismAddress;
        emit NewAddress(_domain, _optimismAddress);
    }

    function setTTL(bytes32 _domain, uint256 _ttl)
        external
        override
        notEmpty(_domain)
        superiorToZero(_ttl)
        exist(_domain)
        onlyOwnerOrController(_domain)
    {
        domainToRecord[_domain].ttl = _ttl;
        emit NewTTL(_domain, _ttl);
    }
}
