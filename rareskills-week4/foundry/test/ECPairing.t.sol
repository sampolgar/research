// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ECPairing} from "../src/ECPairing.sol";

contract ECPairingTest is Test {
    ECPairing public ecPairing;

    function setUp() public {
        ecPairing = new ECPairing();
    }

    function test_calcX1() public {
        ECPairing.G1Point memory expected_val = ECPairing.G1Point(
            4444740815889402603535294170722302758225367627362056425101568584910268024244,
            10537263096529483164618820017164668921386457028564663708352735080900270541420
        );
        ECPairing.G1Point memory X1 = ecPairing.calc_X1(2, 3, 5);
        bool assertion = expected_val.x == X1.x && expected_val.y == X1.y;
        assertTrue(assertion, "calc_X1 failed");
    }

    function test_verify() public {
        ECPairing.G1Point memory A = ECPairing.G1Point(123, 123);
        ECPairing.G2Point memory B = ECPairing.G2Point(
            [
                10191129150170504690859455063377241352678147020731325090942140630855943625622,
                12345624066896925082600651626583520268054356403303305150512393106955803260718
            ],
            [
                5160758496627257972548609984372007491378544501748355445508516516431319734209,
                8098091320156762167549822640824918297625875460457132159047501217759294966639
            ]
        );
        ECPairing.G1Point memory alpha = ECPairing.G1Point(123, 123);
        ECPairing.G2Point memory beta = ECPairing.G2Point(
            [
                2725019753478801796453339367788033689375851816420509565303521482350756874229,
                7273165102799931111715871471550377909735733521218303035754523677688038059653
            ],
            [
                2512659008974376214222774206987427162027254181373325676825515531566330959255,
                957874124722006818841961785324909313781880061366718538693995380805373202866
            ]
        );
        ECPairing.G1Point memory C = ECPairing.G1Point(
            3010198690406615200373504922352659861758983907867017329644089018310584441462,
            4027184618003122424972590350825261965929648733675738730716654005365300998076
        );
        ECPairing.G2Point memory delta = ECPairing.G2Point(
            [
                20954117799226682825035885491234530437475518021362091509513177301640194298072,
                4540444681147253467785307942530223364530218361853237193970751657229138047649
            ],
            [
                21508930868448350162258892668132814424284302804699005394342512102884055673846,
                11631839690097995216017572651900167465857396346217730511548857041925508482915
            ]
        );

        bool assertion = ecPairing.verify(A, B, alpha, beta, 2, 3, 5, C, delta);
        assertTrue(assertion, "verify failed");
    }
}
