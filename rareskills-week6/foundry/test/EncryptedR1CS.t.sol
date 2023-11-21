// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import { Test, console2 } from "forge-std/Test.sol";
import { EncryptedR1CS } from "../src/EncryptedR1CS.sol";

contract EncryptedR1CSTest is Test {
  EncryptedR1CS public encryptedr1cs;

  function setUp() public {
    encryptedr1cs = new EncryptedR1CS();
  }

  function testPairing2by2Matrix() public view {
    EncryptedR1CS.G1Point[2] memory Ls;
    Ls[0] = EncryptedR1CS.G1Point(3353031288059533942658390886683067124040920775575537747144343083137631628272, 19321533766552368860946552437480515441416830039777911637913418824951667761761);
    Ls[1] = EncryptedR1CS.G1Point(1624070059937464756887933993293429854168590106605707304006200119738501412969, 3269329550605213075043232856820720631601935657990457502777101397807070461336);

    EncryptedR1CS.G2Point[2] memory Rs;
    Rs[0] = EncryptedR1CS.G2Point([7273165102799931111715871471550377909735733521218303035754523677688038059653, 2725019753478801796453339367788033689375851816420509565303521482350756874229], [957874124722006818841961785324909313781880061366718538693995380805373202866, 2512659008974376214222774206987427162027254181373325676825515531566330959255]);
    Rs[1] = EncryptedR1CS.G2Point([7273165102799931111715871471550377909735733521218303035754523677688038059653, 2725019753478801796453339367788033689375851816420509565303521482350756874229], [957874124722006818841961785324909313781880061366718538693995380805373202866, 2512659008974376214222774206987427162027254181373325676825515531566330959255]);

    EncryptedR1CS.G1Point[2] memory Os;
    Os[0] = EncryptedR1CS.G1Point(1624070059937464756887933993293429854168590106605707304006200119738501412969, 3269329550605213075043232856820720631601935657990457502777101397807070461336);
    Os[1] = EncryptedR1CS.G1Point(10744596414106452074759370245733544594153395043370666422502510773307029471145, 21039565435327757486054843320102702720990930294403178719740356721829973864651);

    bool x = encryptedr1cs.r1csPairing(Ls, Rs, Os);
    console2.log("x is: ", x);
  }
}
