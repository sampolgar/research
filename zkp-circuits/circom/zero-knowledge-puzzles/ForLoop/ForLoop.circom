pragma circom 2.1.4;

template ForLoop() {
    signal input a[2];
    signal output c;
    signal intermediate[4];

    intermediate[0] <== a[0] + a[1];
    for(var i = 1; i < 4; i++){
        intermediate[i] <== intermediate[i - 1] + a[0] + a[1];
    }
    c <== intermediate[3];
}  

component main = ForLoop();
