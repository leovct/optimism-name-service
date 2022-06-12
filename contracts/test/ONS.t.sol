// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;

import "../contracts/ONS.sol";
import "forge-std/Test.sol";

contract ONSTest is Test {
    ONS ons;

    function setUp() public {
        ons = new ONS();
    }

    /***********************************************************************************************
                                            Core
    ***********************************************************************************************/

    // @Register

    function testRegister(bytes32 _domain, uint256 _ttl) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_ttl > 0);

        ons.register(_domain, _ttl);

        address owner = address(this);
        assertEq(ons.getOwner(_domain), owner);
        assertEq(ons.getController(_domain), owner);
        assertEq(ons.getAddress(_domain), owner);
        assertEq(ons.getTTL(_domain), _ttl);
    }

    function testCannotRegisterWithEmptyDomain(uint256 _ttl) public {
        vm.assume(_ttl > 0);

        vm.expectRevert(ONS.IsEmpty.selector);
        ons.register(bytes32(0), _ttl);
    }

    function testCannotRegisterWithTTLIsEqualToZero(bytes32 _domain) public {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(ONS.IsEqualToZero.selector);
        ons.register(_domain, 0);
    }

    function testCannotRegisterAlreadyRegisteredDomain(
        bytes32 _domain,
        uint256 _ttl
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_ttl > 0);

        ons.register(_domain, _ttl);

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsRegistered(bytes32)", _domain)
        );
        ons.register(_domain, _ttl);
    }

    // @RegisterWithParameters

    function testRegisterWithParameters(
        bytes32 _domain,
        address _controllerAddress,
        address _optimismAddress,
        uint256 _ttl
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_controllerAddress != address(0));
        vm.assume(_optimismAddress != address(0));
        vm.assume(_ttl > 0);

        ons.registerWithParameters(
            _domain,
            _controllerAddress,
            _optimismAddress,
            _ttl
        );

        assertEq(ons.getOwner(_domain), address(this));
        assertEq(ons.getController(_domain), _controllerAddress);
        assertEq(ons.getAddress(_domain), _optimismAddress);
        assertEq(ons.getTTL(_domain), _ttl);
    }

    function testCannotRegisterWithParametersAndEmptyDomain(
        address _controllerAddress,
        address _optimismAddress,
        uint256 _ttl
    ) public {
        vm.assume(_controllerAddress != address(0));
        vm.assume(_optimismAddress != address(0));
        vm.assume(_ttl > 0);
        vm.expectRevert(ONS.IsEmpty.selector);

        ons.registerWithParameters(
            bytes32(0),
            _controllerAddress,
            _optimismAddress,
            0
        );
    }

    function testCannotRegisterWithParametersAndTTLIsEqualToZero(
        bytes32 _domain,
        address _controllerAddress,
        address _optimismAddress
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_controllerAddress != address(0));
        vm.assume(_optimismAddress != address(0));
        vm.expectRevert(ONS.IsEqualToZero.selector);

        ons.registerWithParameters(
            _domain,
            _controllerAddress,
            _optimismAddress,
            0
        );
    }

    function testCannotRegisterWithParametersAndAlreadyRegisteredDomain(
        bytes32 _domain,
        address _controllerAddress,
        address _optimismAddress,
        uint256 _ttl
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_controllerAddress != address(0));
        vm.assume(_optimismAddress != address(0));
        vm.assume(_ttl > 0);

        ons.registerWithParameters(
            _domain,
            _controllerAddress,
            _optimismAddress,
            _ttl
        );

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsRegistered(bytes32)", _domain)
        );
        ons.registerWithParameters(
            _domain,
            _controllerAddress,
            _optimismAddress,
            _ttl
        );
    }

    // @Deregister
    // Note: how to test the execution of a method using another account than the owner one?

    function testDeregister(bytes32 _domain) public {
        vm.assume(_domain != bytes32(0));

        ons.register(_domain, 1);
        ons.deregister(_domain);
    }

    function testCannotDeregisterWithEmptyDomain() public {
        vm.expectRevert(ONS.IsEmpty.selector);
        ons.deregister(bytes32(0));
    }

    function testCannotDeregisterDomainThatDoesNotExist(bytes32 _domain)
        public
    {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.deregister(_domain);
    }

    // @Resolve

    function testResolveWithRegister(bytes32 _domain) public {
        vm.assume(_domain != bytes32(0));

        ons.register(_domain, 1);
        assertEq(ons.resolve(_domain), address(this));
    }

    function testResolveWithRegisterWithParameters(
        bytes32 _domain,
        address _controllerAddress,
        address _optimismAddress,
        uint256 _ttl
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_controllerAddress != address(0));
        vm.assume(_optimismAddress != address(0));
        vm.assume(_ttl > 0);

        ons.registerWithParameters(
            _domain,
            _controllerAddress,
            _optimismAddress,
            _ttl
        );
        assertEq(ons.resolve(_domain), _optimismAddress);
    }

    function testCannotResolveWithRegisterAndEmptyDomain() public {
        vm.expectRevert(ONS.IsEmpty.selector);
        ons.resolve(bytes32(0));
    }

    function testCannotResolveWithRegisterAndUnregisteredDomain(bytes32 _domain)
        public
    {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.resolve(_domain);
    }

    /***********************************************************************************************
                                            Getters
    ***********************************************************************************************/

    // @GetOwner

    function testCannotGetOwnerOfEmptyDomain() public {
        vm.expectRevert(ONS.IsEmpty.selector);
        ons.getOwner(bytes32(0));
    }

    function testCannotGetOwnerOfDomainThatDoesNotExist(bytes32 _domain)
        public
    {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.getOwner(_domain);
    }

    // @GetController

    function testCannotGetControllerOfEmptyDomain() public {
        vm.expectRevert(ONS.IsEmpty.selector);
        ons.getController(bytes32(0));
    }

    function testCannotGetControllerOfDomainThatDoesNotExist(bytes32 _domain)
        public
    {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.getController(_domain);
    }

    // @GetAddress

    function testCannotGetAddressOfEmptyDomain() public {
        vm.expectRevert(ONS.IsEmpty.selector);
        ons.getAddress(bytes32(0));
    }

    function testCannotGetAddressOfDomainThatDoesNotExist(bytes32 _domain)
        public
    {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.getAddress(_domain);
    }

    // @GetTTL

    function testCannotGetTTLOfEmptyDomain() public {
        vm.expectRevert(ONS.IsEmpty.selector);
        ons.getTTL(bytes32(0));
    }

    function testCannotGetTTLOfDomainThatDoesNotExist(bytes32 _domain) public {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.getTTL(_domain);
    }

    /***********************************************************************************************
                                            Setters
    ***********************************************************************************************/

    // @SetOwner
    // Note: how to test the execution of a method using another account than the owner one?

    function testSetOwner(bytes32 _domain, address _ownerAddress) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_ownerAddress != address(0));

        ons.register(_domain, 1);

        ons.setOwner(_domain, _ownerAddress);
        assertEq(ons.getOwner(_domain), _ownerAddress);
    }

    function testCannotSetOwnerOfEmptyDomain(address _ownerAddress) public {
        vm.assume(_ownerAddress != address(0));

        vm.expectRevert(ONS.IsEmpty.selector);
        ons.setOwner(bytes32(0), _ownerAddress);
    }

    function testCannotSetOwnerOfDomainThatDoesNotExist(
        bytes32 _domain,
        address _ownerAddress
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_ownerAddress != address(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.setOwner(_domain, _ownerAddress);
    }

    function testCannotSetOwnerWithIsNull(bytes32 _domain) public {
        vm.assume(_domain != bytes32(0));

        ons.register(_domain, 1);

        vm.expectRevert(ONS.IsNull.selector);
        ons.setOwner(_domain, address(0));
    }

    // @SetController
    // Note: how to test the execution of a method using another account than the owner one?

    function testSetController(bytes32 _domain, address _controllerAddress)
        public
    {
        vm.assume(_domain != bytes32(0));
        vm.assume(_controllerAddress != address(0));

        ons.register(_domain, 1);

        ons.setController(_domain, _controllerAddress);
        assertEq(ons.getController(_domain), _controllerAddress);
    }

    function testCannotSetControllerOfEmptyDomain(address _controllerAddress)
        public
    {
        vm.assume(_controllerAddress != address(0));

        vm.expectRevert(ONS.IsEmpty.selector);
        ons.setController(bytes32(0), _controllerAddress);
    }

    function testCannotSetControllerOfDomainThatDoesNotExist(
        bytes32 _domain,
        address _controllerAddress
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_controllerAddress != address(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.setController(_domain, _controllerAddress);
    }

    // @SetAddress
    // Note: how to test the execution of a method using another account than the owner one?

    function testSetAddress(bytes32 _domain, address _optimismAddress) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_optimismAddress != address(0));

        ons.register(_domain, 1);

        ons.setAddress(_domain, _optimismAddress);
        assertEq(ons.getAddress(_domain), _optimismAddress);
    }

    function testCannotSetAddressOfEmptyDomain(address _optimismAddress)
        public
    {
        vm.assume(_optimismAddress != address(0));

        vm.expectRevert(ONS.IsEmpty.selector);
        ons.setAddress(bytes32(0), _optimismAddress);
    }

    function testCannotSetAddressOfDomainThatDoesNotExist(
        bytes32 _domain,
        address _optimismAddress
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_optimismAddress != address(0));

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.setAddress(_domain, _optimismAddress);
    }

    // @SetTTL
    // Note: how to test the execution of a method using another account than the owner one?

    function testSetTTL(bytes32 _domain, uint256 _ttl) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_ttl > 0);

        ons.register(_domain, 1);

        ons.setTTL(_domain, _ttl);
        assertEq(ons.getTTL(_domain), _ttl);
    }

    function testCannotSetTTLOfEmptyDomain(uint256 _ttl) public {
        vm.assume(_ttl > 0);

        vm.expectRevert(ONS.IsEmpty.selector);
        ons.setTTL(bytes32(0), _ttl);
    }

    function testCannotSetTTLIsEqualToZero(bytes32 _domain) public {
        vm.assume(_domain != bytes32(0));

        vm.expectRevert(ONS.IsEqualToZero.selector);
        ons.setTTL(_domain, 0);
    }

    function testCannotSetTTLOfDomainThatDoesNotExist(
        bytes32 _domain,
        uint256 _ttl
    ) public {
        vm.assume(_domain != bytes32(0));
        vm.assume(_ttl > 0);

        vm.expectRevert(
            abi.encodeWithSignature("DomainIsNotRegistered(bytes32)", _domain)
        );
        ons.setTTL(_domain, _ttl);
    }
}
