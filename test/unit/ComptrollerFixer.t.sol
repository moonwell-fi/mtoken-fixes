pragma solidity 0.5.17;

import "forge-std/Test.sol";

import {TransparentUpgradeableProxy, ITransparentUpgradeableProxy} from "@openzeppelin/contracts/proxy/transparent/TransparentUpgradeableProxy.sol";

import {SigUtils} from "@test/helper/SigUtils.sol";
import {MErc20Immutable} from "@test/mock/MErc20Immutable.sol";
import {ComptrollerFixer} from "@protocol/ComptrollerFixer.sol";
import {FaucetTokenWithPermit} from "@test/helper/FaucetToken.sol";
import {SimplePriceOracle} from "@test/helper/SimplePriceOracle.sol";

contract ComptrollerFixerUnitTest is Test {
    Comptroller comptroller;
    SimplePriceOracle oracle;
    FaucetTokenWithPermit faucetToken;
    MErc20Immutable mToken;
    InterestRateModel irModel;

    function setUp() public {
        comptroller = new ComptrollerFixer();
        oracle = new SimplePriceOracle();
        faucetToken = new FaucetTokenWithPermit(1e18, "Testing", 18, "TEST");

        mToken = new MErc20Immutable(
            address(faucetToken),
            comptroller,
            irModel,
            1e18,
            "Test mToken",
            "mTEST",
            8,
            payable(address(this))
        );

        distributor = new MultiRewardDistributor();
        bytes memory initdata = abi.encodeWithSignature(
            "initialize(address,address)",
            address(comptroller),
            address(this)
        );
        TransparentUpgradeableProxy proxy = new TransparentUpgradeableProxy(
            address(distributor),
            address(proxyAdmin),
            initdata
        );

        distributor = MultiRewardDistributor(address(proxy));

        comptroller._setRewardDistributor(distributor);
        comptroller._setPriceOracle(oracle);
        comptroller._supportMarket(mToken);
        oracle.setUnderlyingPrice(mToken, 1e18);
        sigUtils = new SigUtils(faucetToken.DOMAIN_SEPARATOR());
    }

    function testFoo() public {
        assertEq(1, 1);
    }
}
