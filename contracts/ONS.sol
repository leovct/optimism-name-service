//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.14;

import "./IONS.sol";

/**
 * @title Optimsim Name Service Contract v0.0.0
 * @author leovct
 * @notice Implementation of the distributed naming system based on the Optimism blockchain, highly
 * inspired by the Ethereum Name Service (ENS).
 * @dev Custom errors are used instead of require statements because it costs less gas.
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
    mapping(bytes32 => Record) private domainToRecord;

    // This mapping allows to know if a domain exists or not.
    mapping(bytes32 => bool) private domainToExist;

    /***********************************************************************************************
                                            Core
    ***********************************************************************************************/

    function register(bytes32 _domain, uint256 _ttl) external override {
        verifyBytes32IsNotEmpty(_domain);
        verifyUintIsNotEqualToZero(_ttl);
        verifyDomainDoesNotExist(_domain);

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
    ) external override {
        verifyBytes32IsNotEmpty(_domain);
        verifyUintIsNotEqualToZero(_ttl);
        verifyDomainDoesNotExist(_domain);

        domainToExist[_domain] = true;
        domainToRecord[_domain] = Record(
            msg.sender,
            _controllerAddress,
            _optimismAddress,
            _ttl
        );
    }

    function deregister(bytes32 _domain) external override {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);
        onlyOwner(_domain);

        domainToExist[_domain] = false;
    }

    /***********************************************************************************************
                                            Getters
    ***********************************************************************************************/

    function getOwner(bytes32 _domain)
        external
        view
        override
        returns (address)
    {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);

        return domainToRecord[_domain].ownerAddress;
    }

    function getController(bytes32 _domain)
        external
        view
        override
        returns (address)
    {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);

        return domainToRecord[_domain].controllerAddress;
    }

    function getAddress(bytes32 _domain)
        external
        view
        override
        returns (address)
    {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);

        return domainToRecord[_domain].optimismAddress;
    }

    function getTTL(bytes32 _domain) external view override returns (uint256) {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);

        return domainToRecord[_domain].ttl;
    }

    /***********************************************************************************************
                                            Setters
    ***********************************************************************************************/

    function setOwner(bytes32 _domain, address _ownerAddress)
        external
        override
    {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);
        verifyAddressIsNotNull(_ownerAddress);
        onlyOwner(_domain);

        domainToRecord[_domain].ownerAddress = _ownerAddress;
        emit NewOwner(_domain, _ownerAddress);
    }

    /**
     * @dev The controller address can be set to the black hole addres.
     */
    function setController(bytes32 _domain, address _controllerAddress)
        external
        override
    {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);
        onlyOwner(_domain);

        domainToRecord[_domain].controllerAddress = _controllerAddress;
        emit NewController(_domain, _controllerAddress);
    }

    /**
     * @dev The optimism address can be set to the black hole addres.
     */
    function setAddress(bytes32 _domain, address _optimismAddress)
        external
        override
    {
        verifyBytes32IsNotEmpty(_domain);
        verifyDomainExists(_domain);
        onlyOwnerOrController(_domain);

        domainToRecord[_domain].optimismAddress = _optimismAddress;
        emit NewAddress(_domain, _optimismAddress);
    }

    function setTTL(bytes32 _domain, uint256 _ttl) external override {
        verifyBytes32IsNotEmpty(_domain);
        verifyUintIsNotEqualToZero(_ttl);
        verifyDomainExists(_domain);
        onlyOwnerOrController(_domain);

        domainToRecord[_domain].ttl = _ttl;
        emit NewTTL(_domain, _ttl);
    }

    /***********************************************************************************************
                                            Custom errors
    ***********************************************************************************************/

    error DomainDoesNotExist(bytes32 domain);
    error DomainAlreadyExists(bytes32 domain);
    error EmptyByteString();
    error EqualToZero();
    error NullAddress();
    error Unauthorised(address callerAddress, string expectedCallers);

    /**
     * @dev Verify that a domain exists.
     * @param _domain the domain.
     */
    function verifyDomainExists(bytes32 _domain) internal view {
        if (!domainToExist[_domain]) {
            revert DomainDoesNotExist({domain: _domain});
        }
    }

    /**
     * @dev Verify that a domain does not exist.
     * @param _domain the domain.
     */
    function verifyDomainDoesNotExist(bytes32 _domain) internal view {
        if (domainToExist[_domain]) {
            revert DomainAlreadyExists({domain: _domain});
        }
    }

    /**
     * @dev Verify that a bytes32 parameter is not empty.
     * @param _str the bytes32 parameter.
     */
    function verifyBytes32IsNotEmpty(bytes32 _str) internal pure {
        if (_str == bytes32(0)) {
            revert EmptyByteString();
        }
    }

    /**
     * @dev Verify that an unsigned integer parameter is not equal to zero.
     * @param _n the unsigned parameter.
     */
    function verifyUintIsNotEqualToZero(uint256 _n) internal pure {
        if (_n == 0) {
            revert EqualToZero();
        }
    }

    /**
     * @dev Verify that an address parameter is not  null.
     * @param _address the address parameter.
     */
    function verifyAddressIsNotNull(address _address) internal pure {
        if (_address == address(0)) {
            revert NullAddress();
        }
    }

    /**
     * @dev Verify that only the owner of the domain can call this method.
     * @param _domain the domain.
     */
    function onlyOwner(bytes32 _domain) internal view {
        if (msg.sender != domainToRecord[_domain].ownerAddress) {
            revert Unauthorised({
                callerAddress: msg.sender,
                expectedCallers: "owner"
            });
        }
    }

    /**
     * @dev Verify that only the owner or the controller of the domain can call this method.
     * @param _domain the domain.
     */
    function onlyOwnerOrController(bytes32 _domain) internal view {
        if (
            msg.sender != domainToRecord[_domain].ownerAddress &&
            msg.sender != domainToRecord[_domain].controllerAddress
        ) {
            revert Unauthorised({
                callerAddress: msg.sender,
                expectedCallers: "owner or controller"
            });
        }
    }
}
