from py_ecc.bn128 import G1, G2, pairing, add, multiply
from py_ecc.fields import FQ, FQ2, FQ12


def test_pairing():
    # assert pairing(G1, G2) == FQ12(
    #     [FQ2([FQ(1), FQ(0)]), FQ2([FQ(1), FQ(0)]), FQ2([FQ(1), FQ(0)])])
    assert pairing(G2, G1) == FQ12(
        [
            FQ2([
                FQ(1), 
                FQ(0)
                ]), 
            FQ2([
                FQ(1), 
                FQ(0)
                ]), 
            FQ2([
                FQ(1), 
                FQ(0)
                ])
            ])



test_pairing()


