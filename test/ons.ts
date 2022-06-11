import { expect } from "chai";
import { ethers } from "hardhat";
// eslint-disable-next-line node/no-missing-import, camelcase
import { ONS, ONS__factory } from "../typechain";

describe("ONS", function () {
  let owner: any, user: any, random01: any, random02: any;
  let ons: ONS;
  let domain: string;
  let ttl: number;

  beforeEach(async function () {
    // Get signers.
    [owner, user, random01, random02] = await ethers.getSigners();

    domain = ethers.utils.formatBytes32String("lola.opt");
    ttl = dateToUnixTimestamp(dateInXYearsFromNow(1));

    // Deploy the ONS contract.
    // eslint-disable-next-line camelcase
    const ONS: ONS__factory = await ethers.getContractFactory("ONS");
    ons = await ONS.deploy();
    await ons.deployed();
  });

  /*************************************************************************************************
                                            Core
  *************************************************************************************************/

  describe("Register", async function () {
    it("Should register a domain", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      // Check that the domain records are correct.
      const domainOwner = await ons.getOwner(domain);
      expect(domainOwner).to.equal(owner.address);

      const domainController = await ons.getController(domain);
      expect(domainController).to.equal(owner.address);

      const domainAddress = await ons.getAddress(domain);
      expect(domainAddress).to.equal(owner.address);

      const domainTTL = await ons.getTTL(domain);
      expect(domainTTL).to.equal(ttl);
    });

    it("Should register a domain with custom parameters", async function () {
      const controller = random01.address;
      const optimismAddress = random02.address;

      // Register a domain with parameters.
      const registerTx = await ons.registerWithParameters(
        domain,
        controller,
        optimismAddress,
        ttl
      );
      await registerTx.wait();

      // Check that the domain records are correct.
      const domainOwner = await ons.getOwner(domain);
      expect(domainOwner).to.equal(owner.address);

      const domainController = await ons.getController(domain);
      expect(domainController).to.equal(controller);

      const domainAddress = await ons.getAddress(domain);
      expect(domainAddress).to.equal(optimismAddress);

      const domainTTL = await ons.getTTL(domain);
      expect(domainTTL).to.equal(ttl);
    });

    it("Should fail when trying to register a domain with an empty string", async function () {
      // Register a domain with an empty string with both functions (standard and with parameters).
      await expect(
        ons.register(ethers.utils.formatBytes32String(""), ttl)
      ).to.be.revertedWith("EmptyByteString");

      await expect(
        ons.registerWithParameters(
          ethers.utils.formatBytes32String(""),
          random01.address,
          random02.address,
          ttl
        )
      ).to.be.revertedWith("EmptyByteString");
    });

    it("Should fail when trying to register a domain with an empty ttl", async function () {
      // Register a domain with an empty ttl with both functions (standard and with parameters).
      await expect(ons.register(domain, 0)).to.be.revertedWith("EqualToZero");

      await expect(
        ons.registerWithParameters(
          domain,
          random01.address,
          random02.address,
          0
        )
      ).to.be.revertedWith("EqualToZero");
    });

    it("Should fail when trying to register an already registered domain", async function () {
      // Register an already registered domain with both functions (standard and with parameters).
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(ons.register(domain, ttl)).to.be.revertedWith(
        `DomainAlreadyExists("${domain}")`
      );

      await expect(
        ons.registerWithParameters(
          domain,
          random01.address,
          random02.address,
          ttl
        )
      ).to.be.revertedWith(`DomainAlreadyExists("${domain}")`);
    });
  });

  describe("Deregister", async function () {
    it("Should register a domain and then deregister it", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      // Deregister the domain.
      const deregisterTx = await ons.deregister(domain);
      await deregisterTx.wait();

      // Check that trying to get the domain records reverts.
      await expect(ons.getOwner(domain)).to.be.revertedWith(
        "DomainDoesNotExist"
      );

      await expect(ons.getController(domain)).to.be.revertedWith(
        "DomainDoesNotExist"
      );

      await expect(ons.getAddress(domain)).to.be.revertedWith(
        "DomainDoesNotExist"
      );

      await expect(ons.getTTL(domain)).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to deregister a domain with an empty string", async function () {
      await expect(
        ons.deregister(ethers.utils.formatBytes32String(""))
      ).to.be.revertedWith("EmptyByteString");
    });

    it("Should fail when trying to deregister a domain that is not registered", async function () {
      await expect(
        ons.deregister(ethers.utils.formatBytes32String("arandomdomain.opt"))
      ).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to deregister a domain with a different account than the current owner", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(ons.connect(user).deregister(domain)).to.be.revertedWith(
        `Unauthorised("${user.address}", "owner")`
      );
    });
  });

  /*************************************************************************************************
                                            Setters
  *************************************************************************************************/

  describe("SetOwner", async function () {
    it("Should set the owner of a domain", async function () {
      const newOwner = random01.address;

      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      // Set a new domain's owner.
      const setOwnerTx = await ons.setOwner(domain, newOwner);
      await setOwnerTx.wait();

      // Check that the new domain's owner has been updated.
      const domainOwner = await ons.getOwner(domain);
      expect(domainOwner).to.equal(newOwner);
    });

    it("Should fail when trying to set the domain's owner with an empty string", async function () {
      await expect(ons.setOwner(domain, random01.address)).to.be.revertedWith(
        "DomainDoesNotExist"
      );
    });

    it("Should fail when trying to set the domain's owner that is not registered", async function () {
      await expect(
        ons.setOwner(
          ethers.utils.formatBytes32String("arandomdomain.opt"),
          random01.address
        )
      ).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to set the domain's owner with a different account than the current owner", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(
        ons.connect(user).setOwner(domain, random01.address)
      ).to.be.revertedWith(`Unauthorised("${user.address}", "owner")`);
    });

    it("Should fail when trying to set the domain's owner with an empty address", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(
        ons.setOwner(domain, ethers.constants.AddressZero)
      ).to.be.revertedWith("NullAddress");
    });
  });

  describe("SetController", async function () {
    it("Should set the controller of a domain", async function () {
      const newController = random01.address;

      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      // Set a new domain's controller.
      const setControllerTx = await ons.setController(domain, newController);
      await setControllerTx.wait();

      // Check that the new domain's controller has been updated.
      const domainController = await ons.getController(domain);
      expect(domainController).to.equal(newController);
    });

    it("Should fail when trying to set the domain's controller with an empty string", async function () {
      await expect(
        ons.setController(domain, random01.address)
      ).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to set the domain's controller that is not registered", async function () {
      await expect(
        ons.setController(
          ethers.utils.formatBytes32String("arandomdomain.opt"),
          random01.address
        )
      ).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to set the domain's controller with a different account than the current owner", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(
        ons.connect(user).setController(domain, random01.address)
      ).to.be.revertedWith(`Unauthorised("${user.address}", "owner")`);
    });
  });

  describe("SetAddress", async function () {
    it("Should set the address of a domain using the owner account", async function () {
      const newAddress = random01.address;

      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      // Set a new domain's address.
      const setAddressTx = await ons.setAddress(domain, newAddress);
      await setAddressTx.wait();

      // Check that the new domain's address has been updated.
      const domainAddress = await ons.getAddress(domain);
      expect(domainAddress).to.equal(newAddress);
    });

    it("Should set the address of a domain using the controller account", async function () {
      const controller = random01;
      const optimismAddress = owner.address;
      const newAddress = random02.address;

      // Register a domain.
      const registerTx = await ons.registerWithParameters(
        domain,
        controller.address,
        optimismAddress,
        ttl
      );
      await registerTx.wait();

      // Set a new domain's address.
      const setAddressTx = await ons
        .connect(controller)
        .setAddress(domain, newAddress);
      await setAddressTx.wait();

      // Check that the new domain's address has been updated.
      const domainAddress = await ons.getAddress(domain);
      expect(domainAddress).to.equal(newAddress);
    });

    it("Should fail when trying to set the domain's address with an empty string", async function () {
      await expect(ons.setAddress(domain, random01.address)).to.be.revertedWith(
        "DomainDoesNotExist"
      );
    });

    it("Should fail when trying to set the domain's address that is not registered", async function () {
      await expect(
        ons.setAddress(
          ethers.utils.formatBytes32String("arandomdomain.opt"),
          random01.address
        )
      ).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to set the domain's address with a different account than the current owner or the current controller", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(
        ons.connect(user).setAddress(domain, random01.address)
      ).to.be.revertedWith(
        `Unauthorised("${user.address}", "owner or controller")`
      );
    });
  });

  describe("SetTTL", async function () {
    it("Should set the ttl of a domain using the owner account", async function () {
      const newTTL = dateToUnixTimestamp(dateInXYearsFromNow(5));

      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      // Set a new domain's ttl.
      const setTTLTx = await ons.setTTL(domain, newTTL);
      await setTTLTx.wait();

      // Check that the new domain's ttl has been updated.
      const domainTTL = await ons.getTTL(domain);
      expect(domainTTL).to.equal(newTTL);
    });

    it("Should set the ttl of a domain using the controller account", async function () {
      const controller = random01;
      const optimismAddress = owner.address;
      const newTTL = dateToUnixTimestamp(dateInXYearsFromNow(5));

      // Register a domain.
      const registerTx = await ons.registerWithParameters(
        domain,
        controller.address,
        optimismAddress,
        newTTL
      );
      await registerTx.wait();

      // Set a new domain's ttl.
      const setTTLTx = await ons.connect(controller).setTTL(domain, newTTL);
      await setTTLTx.wait();

      // Check that the new domain's ttl has been updated.
      const domainTTL = await ons.getTTL(domain);
      expect(domainTTL).to.equal(newTTL);
    });

    it("Should fail when trying to set the domain's ttl with an empty string", async function () {
      await expect(ons.setTTL(domain, 1)).to.be.revertedWith(
        "DomainDoesNotExist"
      );
    });

    it("Should fail when trying to set the domain's ttl with an empty integer", async function () {
      await expect(ons.setTTL(domain, 0)).to.be.revertedWith("EqualToZero");
    });

    it("Should fail when trying to set the domain's ttl that is not registered", async function () {
      await expect(
        ons.setTTL(ethers.utils.formatBytes32String("arandomdomain.opt"), 1)
      ).to.be.revertedWith("DomainDoesNotExist");
    });

    it("Should fail when trying to set the domain's ttl with a different account than the current owner or the current controller", async function () {
      // Register a domain.
      const registerTx = await ons.register(domain, ttl);
      await registerTx.wait();

      await expect(ons.connect(user).setTTL(domain, 1)).to.be.revertedWith(
        `Unauthorised("${user.address}", "owner or controller")`
      );
    });
  });
});

function dateToUnixTimestamp(date: Date): number {
  return Math.floor(date.getTime() / 1000);
}

function dateInXYearsFromNow(years: number): Date {
  return new Date(new Date().setFullYear(new Date().getFullYear() + years));
}
