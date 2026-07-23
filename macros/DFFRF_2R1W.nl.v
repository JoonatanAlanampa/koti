module DFFRF_2R1W (CLK,
    WE,
    DA,
    DB,
    DW,
    RA,
    RB,
    RW);
 input CLK;
 input WE;
 output [31:0] DA;
 output [31:0] DB;
 input [31:0] DW;
 input [4:0] RA;
 input [4:0] RB;
 input [4:0] RW;

 wire \DEC0.D.EN ;
 wire \DEC0.D.SEL[0] ;
 wire \DEC0.D.SEL[1] ;
 wire \DEC0.D.SEL[2] ;
 wire \DEC0.D.SEL[3] ;
 wire \DEC0.D0.A_buf[0] ;
 wire \DEC0.D0.A_buf[1] ;
 wire \DEC0.D0.A_buf[2] ;
 wire \DEC0.D0.EN_buf ;
 wire \DEC0.D0.SEL[0] ;
 wire \DEC0.D0.SEL[1] ;
 wire \DEC0.D0.SEL[2] ;
 wire \DEC0.D0.SEL[3] ;
 wire \DEC0.D0.SEL[4] ;
 wire \DEC0.D0.SEL[5] ;
 wire \DEC0.D0.SEL[6] ;
 wire \DEC0.D0.SEL[7] ;
 wire \DEC0.D1.A_buf[0] ;
 wire \DEC0.D1.A_buf[1] ;
 wire \DEC0.D1.A_buf[2] ;
 wire \DEC0.D1.EN_buf ;
 wire \DEC0.D1.SEL[0] ;
 wire \DEC0.D1.SEL[1] ;
 wire \DEC0.D1.SEL[2] ;
 wire \DEC0.D1.SEL[3] ;
 wire \DEC0.D1.SEL[4] ;
 wire \DEC0.D1.SEL[5] ;
 wire \DEC0.D1.SEL[6] ;
 wire \DEC0.D1.SEL[7] ;
 wire \DEC0.D2.A_buf[0] ;
 wire \DEC0.D2.A_buf[1] ;
 wire \DEC0.D2.A_buf[2] ;
 wire \DEC0.D2.EN_buf ;
 wire \DEC0.D2.SEL[0] ;
 wire \DEC0.D2.SEL[1] ;
 wire \DEC0.D2.SEL[2] ;
 wire \DEC0.D2.SEL[3] ;
 wire \DEC0.D2.SEL[4] ;
 wire \DEC0.D2.SEL[5] ;
 wire \DEC0.D2.SEL[6] ;
 wire \DEC0.D2.SEL[7] ;
 wire \DEC0.D3.A_buf[0] ;
 wire \DEC0.D3.A_buf[1] ;
 wire \DEC0.D3.A_buf[2] ;
 wire \DEC0.D3.EN_buf ;
 wire \DEC0.D3.SEL[0] ;
 wire \DEC0.D3.SEL[1] ;
 wire \DEC0.D3.SEL[2] ;
 wire \DEC0.D3.SEL[3] ;
 wire \DEC0.D3.SEL[4] ;
 wire \DEC0.D3.SEL[5] ;
 wire \DEC0.D3.SEL[6] ;
 wire \DEC0.D3.SEL[7] ;
 wire \DEC1.D.EN ;
 wire \DEC1.D.SEL[0] ;
 wire \DEC1.D.SEL[1] ;
 wire \DEC1.D.SEL[2] ;
 wire \DEC1.D.SEL[3] ;
 wire \DEC1.D0.A_buf[0] ;
 wire \DEC1.D0.A_buf[1] ;
 wire \DEC1.D0.A_buf[2] ;
 wire \DEC1.D0.EN_buf ;
 wire \DEC1.D0.SEL[0] ;
 wire \DEC1.D0.SEL[1] ;
 wire \DEC1.D0.SEL[2] ;
 wire \DEC1.D0.SEL[3] ;
 wire \DEC1.D0.SEL[4] ;
 wire \DEC1.D0.SEL[5] ;
 wire \DEC1.D0.SEL[6] ;
 wire \DEC1.D0.SEL[7] ;
 wire \DEC1.D1.A_buf[0] ;
 wire \DEC1.D1.A_buf[1] ;
 wire \DEC1.D1.A_buf[2] ;
 wire \DEC1.D1.EN_buf ;
 wire \DEC1.D1.SEL[0] ;
 wire \DEC1.D1.SEL[1] ;
 wire \DEC1.D1.SEL[2] ;
 wire \DEC1.D1.SEL[3] ;
 wire \DEC1.D1.SEL[4] ;
 wire \DEC1.D1.SEL[5] ;
 wire \DEC1.D1.SEL[6] ;
 wire \DEC1.D1.SEL[7] ;
 wire \DEC1.D2.A_buf[0] ;
 wire \DEC1.D2.A_buf[1] ;
 wire \DEC1.D2.A_buf[2] ;
 wire \DEC1.D2.EN_buf ;
 wire \DEC1.D2.SEL[0] ;
 wire \DEC1.D2.SEL[1] ;
 wire \DEC1.D2.SEL[2] ;
 wire \DEC1.D2.SEL[3] ;
 wire \DEC1.D2.SEL[4] ;
 wire \DEC1.D2.SEL[5] ;
 wire \DEC1.D2.SEL[6] ;
 wire \DEC1.D2.SEL[7] ;
 wire \DEC1.D3.A_buf[0] ;
 wire \DEC1.D3.A_buf[1] ;
 wire \DEC1.D3.A_buf[2] ;
 wire \DEC1.D3.EN_buf ;
 wire \DEC1.D3.SEL[0] ;
 wire \DEC1.D3.SEL[1] ;
 wire \DEC1.D3.SEL[2] ;
 wire \DEC1.D3.SEL[3] ;
 wire \DEC1.D3.SEL[4] ;
 wire \DEC1.D3.SEL[5] ;
 wire \DEC1.D3.SEL[6] ;
 wire \DEC1.D3.SEL[7] ;
 wire \DEC2.D.EN ;
 wire \DEC2.D.SEL[0] ;
 wire \DEC2.D.SEL[1] ;
 wire \DEC2.D.SEL[2] ;
 wire \DEC2.D.SEL[3] ;
 wire \DEC2.D0.A_buf[0] ;
 wire \DEC2.D0.A_buf[1] ;
 wire \DEC2.D0.A_buf[2] ;
 wire \DEC2.D0.EN_buf ;
 wire \DEC2.D0.SEL[0] ;
 wire \DEC2.D0.SEL[1] ;
 wire \DEC2.D0.SEL[2] ;
 wire \DEC2.D0.SEL[3] ;
 wire \DEC2.D0.SEL[4] ;
 wire \DEC2.D0.SEL[5] ;
 wire \DEC2.D0.SEL[6] ;
 wire \DEC2.D0.SEL[7] ;
 wire \DEC2.D1.A_buf[0] ;
 wire \DEC2.D1.A_buf[1] ;
 wire \DEC2.D1.A_buf[2] ;
 wire \DEC2.D1.EN_buf ;
 wire \DEC2.D1.SEL[0] ;
 wire \DEC2.D1.SEL[1] ;
 wire \DEC2.D1.SEL[2] ;
 wire \DEC2.D1.SEL[3] ;
 wire \DEC2.D1.SEL[4] ;
 wire \DEC2.D1.SEL[5] ;
 wire \DEC2.D1.SEL[6] ;
 wire \DEC2.D1.SEL[7] ;
 wire \DEC2.D2.A_buf[0] ;
 wire \DEC2.D2.A_buf[1] ;
 wire \DEC2.D2.A_buf[2] ;
 wire \DEC2.D2.EN_buf ;
 wire \DEC2.D2.SEL[0] ;
 wire \DEC2.D2.SEL[1] ;
 wire \DEC2.D2.SEL[2] ;
 wire \DEC2.D2.SEL[3] ;
 wire \DEC2.D2.SEL[4] ;
 wire \DEC2.D2.SEL[5] ;
 wire \DEC2.D2.SEL[6] ;
 wire \DEC2.D2.SEL[7] ;
 wire \DEC2.D3.A_buf[0] ;
 wire \DEC2.D3.A_buf[1] ;
 wire \DEC2.D3.A_buf[2] ;
 wire \DEC2.D3.EN_buf ;
 wire \DEC2.D3.SEL[0] ;
 wire \DEC2.D3.SEL[1] ;
 wire \DEC2.D3.SEL[2] ;
 wire \DEC2.D3.SEL[3] ;
 wire \DEC2.D3.SEL[4] ;
 wire \DEC2.D3.SEL[5] ;
 wire \DEC2.D3.SEL[6] ;
 wire \DEC2.D3.SEL[7] ;
 wire \REGF[10].RFW.D1[0] ;
 wire \REGF[10].RFW.D1[10] ;
 wire \REGF[10].RFW.D1[11] ;
 wire \REGF[10].RFW.D1[12] ;
 wire \REGF[10].RFW.D1[13] ;
 wire \REGF[10].RFW.D1[14] ;
 wire \REGF[10].RFW.D1[15] ;
 wire \REGF[10].RFW.D1[16] ;
 wire \REGF[10].RFW.D1[17] ;
 wire \REGF[10].RFW.D1[18] ;
 wire \REGF[10].RFW.D1[19] ;
 wire \REGF[10].RFW.D1[1] ;
 wire \REGF[10].RFW.D1[20] ;
 wire \REGF[10].RFW.D1[21] ;
 wire \REGF[10].RFW.D1[22] ;
 wire \REGF[10].RFW.D1[23] ;
 wire \REGF[10].RFW.D1[24] ;
 wire \REGF[10].RFW.D1[25] ;
 wire \REGF[10].RFW.D1[26] ;
 wire \REGF[10].RFW.D1[27] ;
 wire \REGF[10].RFW.D1[28] ;
 wire \REGF[10].RFW.D1[29] ;
 wire \REGF[10].RFW.D1[2] ;
 wire \REGF[10].RFW.D1[30] ;
 wire \REGF[10].RFW.D1[31] ;
 wire \REGF[10].RFW.D1[3] ;
 wire \REGF[10].RFW.D1[4] ;
 wire \REGF[10].RFW.D1[5] ;
 wire \REGF[10].RFW.D1[6] ;
 wire \REGF[10].RFW.D1[7] ;
 wire \REGF[10].RFW.D1[8] ;
 wire \REGF[10].RFW.D1[9] ;
 wire \REGF[10].RFW.D2[0] ;
 wire \REGF[10].RFW.D2[10] ;
 wire \REGF[10].RFW.D2[11] ;
 wire \REGF[10].RFW.D2[12] ;
 wire \REGF[10].RFW.D2[13] ;
 wire \REGF[10].RFW.D2[14] ;
 wire \REGF[10].RFW.D2[15] ;
 wire \REGF[10].RFW.D2[16] ;
 wire \REGF[10].RFW.D2[17] ;
 wire \REGF[10].RFW.D2[18] ;
 wire \REGF[10].RFW.D2[19] ;
 wire \REGF[10].RFW.D2[1] ;
 wire \REGF[10].RFW.D2[20] ;
 wire \REGF[10].RFW.D2[21] ;
 wire \REGF[10].RFW.D2[22] ;
 wire \REGF[10].RFW.D2[23] ;
 wire \REGF[10].RFW.D2[24] ;
 wire \REGF[10].RFW.D2[25] ;
 wire \REGF[10].RFW.D2[26] ;
 wire \REGF[10].RFW.D2[27] ;
 wire \REGF[10].RFW.D2[28] ;
 wire \REGF[10].RFW.D2[29] ;
 wire \REGF[10].RFW.D2[2] ;
 wire \REGF[10].RFW.D2[30] ;
 wire \REGF[10].RFW.D2[31] ;
 wire \REGF[10].RFW.D2[3] ;
 wire \REGF[10].RFW.D2[4] ;
 wire \REGF[10].RFW.D2[5] ;
 wire \REGF[10].RFW.D2[6] ;
 wire \REGF[10].RFW.D2[7] ;
 wire \REGF[10].RFW.D2[8] ;
 wire \REGF[10].RFW.D2[9] ;
 wire \REGF[10].RFW.GCLK[0] ;
 wire \REGF[10].RFW.GCLK[1] ;
 wire \REGF[10].RFW.GCLK[2] ;
 wire \REGF[10].RFW.GCLK[3] ;
 wire \REGF[10].RFW.SEL1_B[0] ;
 wire \REGF[10].RFW.SEL1_B[1] ;
 wire \REGF[10].RFW.SEL1_B[2] ;
 wire \REGF[10].RFW.SEL1_B[3] ;
 wire \REGF[10].RFW.SEL2_B[0] ;
 wire \REGF[10].RFW.SEL2_B[1] ;
 wire \REGF[10].RFW.SEL2_B[2] ;
 wire \REGF[10].RFW.SEL2_B[3] ;
 wire \REGF[10].RFW.q_wire[0] ;
 wire \REGF[10].RFW.q_wire[10] ;
 wire \REGF[10].RFW.q_wire[11] ;
 wire \REGF[10].RFW.q_wire[12] ;
 wire \REGF[10].RFW.q_wire[13] ;
 wire \REGF[10].RFW.q_wire[14] ;
 wire \REGF[10].RFW.q_wire[15] ;
 wire \REGF[10].RFW.q_wire[16] ;
 wire \REGF[10].RFW.q_wire[17] ;
 wire \REGF[10].RFW.q_wire[18] ;
 wire \REGF[10].RFW.q_wire[19] ;
 wire \REGF[10].RFW.q_wire[1] ;
 wire \REGF[10].RFW.q_wire[20] ;
 wire \REGF[10].RFW.q_wire[21] ;
 wire \REGF[10].RFW.q_wire[22] ;
 wire \REGF[10].RFW.q_wire[23] ;
 wire \REGF[10].RFW.q_wire[24] ;
 wire \REGF[10].RFW.q_wire[25] ;
 wire \REGF[10].RFW.q_wire[26] ;
 wire \REGF[10].RFW.q_wire[27] ;
 wire \REGF[10].RFW.q_wire[28] ;
 wire \REGF[10].RFW.q_wire[29] ;
 wire \REGF[10].RFW.q_wire[2] ;
 wire \REGF[10].RFW.q_wire[30] ;
 wire \REGF[10].RFW.q_wire[31] ;
 wire \REGF[10].RFW.q_wire[3] ;
 wire \REGF[10].RFW.q_wire[4] ;
 wire \REGF[10].RFW.q_wire[5] ;
 wire \REGF[10].RFW.q_wire[6] ;
 wire \REGF[10].RFW.q_wire[7] ;
 wire \REGF[10].RFW.q_wire[8] ;
 wire \REGF[10].RFW.q_wire[9] ;
 wire \REGF[10].RFW.we_wire ;
 wire \REGF[11].RFW.GCLK[0] ;
 wire \REGF[11].RFW.GCLK[1] ;
 wire \REGF[11].RFW.GCLK[2] ;
 wire \REGF[11].RFW.GCLK[3] ;
 wire \REGF[11].RFW.SEL1_B[0] ;
 wire \REGF[11].RFW.SEL1_B[1] ;
 wire \REGF[11].RFW.SEL1_B[2] ;
 wire \REGF[11].RFW.SEL1_B[3] ;
 wire \REGF[11].RFW.SEL2_B[0] ;
 wire \REGF[11].RFW.SEL2_B[1] ;
 wire \REGF[11].RFW.SEL2_B[2] ;
 wire \REGF[11].RFW.SEL2_B[3] ;
 wire \REGF[11].RFW.q_wire[0] ;
 wire \REGF[11].RFW.q_wire[10] ;
 wire \REGF[11].RFW.q_wire[11] ;
 wire \REGF[11].RFW.q_wire[12] ;
 wire \REGF[11].RFW.q_wire[13] ;
 wire \REGF[11].RFW.q_wire[14] ;
 wire \REGF[11].RFW.q_wire[15] ;
 wire \REGF[11].RFW.q_wire[16] ;
 wire \REGF[11].RFW.q_wire[17] ;
 wire \REGF[11].RFW.q_wire[18] ;
 wire \REGF[11].RFW.q_wire[19] ;
 wire \REGF[11].RFW.q_wire[1] ;
 wire \REGF[11].RFW.q_wire[20] ;
 wire \REGF[11].RFW.q_wire[21] ;
 wire \REGF[11].RFW.q_wire[22] ;
 wire \REGF[11].RFW.q_wire[23] ;
 wire \REGF[11].RFW.q_wire[24] ;
 wire \REGF[11].RFW.q_wire[25] ;
 wire \REGF[11].RFW.q_wire[26] ;
 wire \REGF[11].RFW.q_wire[27] ;
 wire \REGF[11].RFW.q_wire[28] ;
 wire \REGF[11].RFW.q_wire[29] ;
 wire \REGF[11].RFW.q_wire[2] ;
 wire \REGF[11].RFW.q_wire[30] ;
 wire \REGF[11].RFW.q_wire[31] ;
 wire \REGF[11].RFW.q_wire[3] ;
 wire \REGF[11].RFW.q_wire[4] ;
 wire \REGF[11].RFW.q_wire[5] ;
 wire \REGF[11].RFW.q_wire[6] ;
 wire \REGF[11].RFW.q_wire[7] ;
 wire \REGF[11].RFW.q_wire[8] ;
 wire \REGF[11].RFW.q_wire[9] ;
 wire \REGF[11].RFW.we_wire ;
 wire \REGF[12].RFW.GCLK[0] ;
 wire \REGF[12].RFW.GCLK[1] ;
 wire \REGF[12].RFW.GCLK[2] ;
 wire \REGF[12].RFW.GCLK[3] ;
 wire \REGF[12].RFW.SEL1_B[0] ;
 wire \REGF[12].RFW.SEL1_B[1] ;
 wire \REGF[12].RFW.SEL1_B[2] ;
 wire \REGF[12].RFW.SEL1_B[3] ;
 wire \REGF[12].RFW.SEL2_B[0] ;
 wire \REGF[12].RFW.SEL2_B[1] ;
 wire \REGF[12].RFW.SEL2_B[2] ;
 wire \REGF[12].RFW.SEL2_B[3] ;
 wire \REGF[12].RFW.q_wire[0] ;
 wire \REGF[12].RFW.q_wire[10] ;
 wire \REGF[12].RFW.q_wire[11] ;
 wire \REGF[12].RFW.q_wire[12] ;
 wire \REGF[12].RFW.q_wire[13] ;
 wire \REGF[12].RFW.q_wire[14] ;
 wire \REGF[12].RFW.q_wire[15] ;
 wire \REGF[12].RFW.q_wire[16] ;
 wire \REGF[12].RFW.q_wire[17] ;
 wire \REGF[12].RFW.q_wire[18] ;
 wire \REGF[12].RFW.q_wire[19] ;
 wire \REGF[12].RFW.q_wire[1] ;
 wire \REGF[12].RFW.q_wire[20] ;
 wire \REGF[12].RFW.q_wire[21] ;
 wire \REGF[12].RFW.q_wire[22] ;
 wire \REGF[12].RFW.q_wire[23] ;
 wire \REGF[12].RFW.q_wire[24] ;
 wire \REGF[12].RFW.q_wire[25] ;
 wire \REGF[12].RFW.q_wire[26] ;
 wire \REGF[12].RFW.q_wire[27] ;
 wire \REGF[12].RFW.q_wire[28] ;
 wire \REGF[12].RFW.q_wire[29] ;
 wire \REGF[12].RFW.q_wire[2] ;
 wire \REGF[12].RFW.q_wire[30] ;
 wire \REGF[12].RFW.q_wire[31] ;
 wire \REGF[12].RFW.q_wire[3] ;
 wire \REGF[12].RFW.q_wire[4] ;
 wire \REGF[12].RFW.q_wire[5] ;
 wire \REGF[12].RFW.q_wire[6] ;
 wire \REGF[12].RFW.q_wire[7] ;
 wire \REGF[12].RFW.q_wire[8] ;
 wire \REGF[12].RFW.q_wire[9] ;
 wire \REGF[12].RFW.we_wire ;
 wire \REGF[13].RFW.GCLK[0] ;
 wire \REGF[13].RFW.GCLK[1] ;
 wire \REGF[13].RFW.GCLK[2] ;
 wire \REGF[13].RFW.GCLK[3] ;
 wire \REGF[13].RFW.SEL1_B[0] ;
 wire \REGF[13].RFW.SEL1_B[1] ;
 wire \REGF[13].RFW.SEL1_B[2] ;
 wire \REGF[13].RFW.SEL1_B[3] ;
 wire \REGF[13].RFW.SEL2_B[0] ;
 wire \REGF[13].RFW.SEL2_B[1] ;
 wire \REGF[13].RFW.SEL2_B[2] ;
 wire \REGF[13].RFW.SEL2_B[3] ;
 wire \REGF[13].RFW.q_wire[0] ;
 wire \REGF[13].RFW.q_wire[10] ;
 wire \REGF[13].RFW.q_wire[11] ;
 wire \REGF[13].RFW.q_wire[12] ;
 wire \REGF[13].RFW.q_wire[13] ;
 wire \REGF[13].RFW.q_wire[14] ;
 wire \REGF[13].RFW.q_wire[15] ;
 wire \REGF[13].RFW.q_wire[16] ;
 wire \REGF[13].RFW.q_wire[17] ;
 wire \REGF[13].RFW.q_wire[18] ;
 wire \REGF[13].RFW.q_wire[19] ;
 wire \REGF[13].RFW.q_wire[1] ;
 wire \REGF[13].RFW.q_wire[20] ;
 wire \REGF[13].RFW.q_wire[21] ;
 wire \REGF[13].RFW.q_wire[22] ;
 wire \REGF[13].RFW.q_wire[23] ;
 wire \REGF[13].RFW.q_wire[24] ;
 wire \REGF[13].RFW.q_wire[25] ;
 wire \REGF[13].RFW.q_wire[26] ;
 wire \REGF[13].RFW.q_wire[27] ;
 wire \REGF[13].RFW.q_wire[28] ;
 wire \REGF[13].RFW.q_wire[29] ;
 wire \REGF[13].RFW.q_wire[2] ;
 wire \REGF[13].RFW.q_wire[30] ;
 wire \REGF[13].RFW.q_wire[31] ;
 wire \REGF[13].RFW.q_wire[3] ;
 wire \REGF[13].RFW.q_wire[4] ;
 wire \REGF[13].RFW.q_wire[5] ;
 wire \REGF[13].RFW.q_wire[6] ;
 wire \REGF[13].RFW.q_wire[7] ;
 wire \REGF[13].RFW.q_wire[8] ;
 wire \REGF[13].RFW.q_wire[9] ;
 wire \REGF[13].RFW.we_wire ;
 wire \REGF[14].RFW.GCLK[0] ;
 wire \REGF[14].RFW.GCLK[1] ;
 wire \REGF[14].RFW.GCLK[2] ;
 wire \REGF[14].RFW.GCLK[3] ;
 wire \REGF[14].RFW.SEL1_B[0] ;
 wire \REGF[14].RFW.SEL1_B[1] ;
 wire \REGF[14].RFW.SEL1_B[2] ;
 wire \REGF[14].RFW.SEL1_B[3] ;
 wire \REGF[14].RFW.SEL2_B[0] ;
 wire \REGF[14].RFW.SEL2_B[1] ;
 wire \REGF[14].RFW.SEL2_B[2] ;
 wire \REGF[14].RFW.SEL2_B[3] ;
 wire \REGF[14].RFW.q_wire[0] ;
 wire \REGF[14].RFW.q_wire[10] ;
 wire \REGF[14].RFW.q_wire[11] ;
 wire \REGF[14].RFW.q_wire[12] ;
 wire \REGF[14].RFW.q_wire[13] ;
 wire \REGF[14].RFW.q_wire[14] ;
 wire \REGF[14].RFW.q_wire[15] ;
 wire \REGF[14].RFW.q_wire[16] ;
 wire \REGF[14].RFW.q_wire[17] ;
 wire \REGF[14].RFW.q_wire[18] ;
 wire \REGF[14].RFW.q_wire[19] ;
 wire \REGF[14].RFW.q_wire[1] ;
 wire \REGF[14].RFW.q_wire[20] ;
 wire \REGF[14].RFW.q_wire[21] ;
 wire \REGF[14].RFW.q_wire[22] ;
 wire \REGF[14].RFW.q_wire[23] ;
 wire \REGF[14].RFW.q_wire[24] ;
 wire \REGF[14].RFW.q_wire[25] ;
 wire \REGF[14].RFW.q_wire[26] ;
 wire \REGF[14].RFW.q_wire[27] ;
 wire \REGF[14].RFW.q_wire[28] ;
 wire \REGF[14].RFW.q_wire[29] ;
 wire \REGF[14].RFW.q_wire[2] ;
 wire \REGF[14].RFW.q_wire[30] ;
 wire \REGF[14].RFW.q_wire[31] ;
 wire \REGF[14].RFW.q_wire[3] ;
 wire \REGF[14].RFW.q_wire[4] ;
 wire \REGF[14].RFW.q_wire[5] ;
 wire \REGF[14].RFW.q_wire[6] ;
 wire \REGF[14].RFW.q_wire[7] ;
 wire \REGF[14].RFW.q_wire[8] ;
 wire \REGF[14].RFW.q_wire[9] ;
 wire \REGF[14].RFW.we_wire ;
 wire \REGF[15].RFW.GCLK[0] ;
 wire \REGF[15].RFW.GCLK[1] ;
 wire \REGF[15].RFW.GCLK[2] ;
 wire \REGF[15].RFW.GCLK[3] ;
 wire \REGF[15].RFW.SEL1_B[0] ;
 wire \REGF[15].RFW.SEL1_B[1] ;
 wire \REGF[15].RFW.SEL1_B[2] ;
 wire \REGF[15].RFW.SEL1_B[3] ;
 wire \REGF[15].RFW.SEL2_B[0] ;
 wire \REGF[15].RFW.SEL2_B[1] ;
 wire \REGF[15].RFW.SEL2_B[2] ;
 wire \REGF[15].RFW.SEL2_B[3] ;
 wire \REGF[15].RFW.q_wire[0] ;
 wire \REGF[15].RFW.q_wire[10] ;
 wire \REGF[15].RFW.q_wire[11] ;
 wire \REGF[15].RFW.q_wire[12] ;
 wire \REGF[15].RFW.q_wire[13] ;
 wire \REGF[15].RFW.q_wire[14] ;
 wire \REGF[15].RFW.q_wire[15] ;
 wire \REGF[15].RFW.q_wire[16] ;
 wire \REGF[15].RFW.q_wire[17] ;
 wire \REGF[15].RFW.q_wire[18] ;
 wire \REGF[15].RFW.q_wire[19] ;
 wire \REGF[15].RFW.q_wire[1] ;
 wire \REGF[15].RFW.q_wire[20] ;
 wire \REGF[15].RFW.q_wire[21] ;
 wire \REGF[15].RFW.q_wire[22] ;
 wire \REGF[15].RFW.q_wire[23] ;
 wire \REGF[15].RFW.q_wire[24] ;
 wire \REGF[15].RFW.q_wire[25] ;
 wire \REGF[15].RFW.q_wire[26] ;
 wire \REGF[15].RFW.q_wire[27] ;
 wire \REGF[15].RFW.q_wire[28] ;
 wire \REGF[15].RFW.q_wire[29] ;
 wire \REGF[15].RFW.q_wire[2] ;
 wire \REGF[15].RFW.q_wire[30] ;
 wire \REGF[15].RFW.q_wire[31] ;
 wire \REGF[15].RFW.q_wire[3] ;
 wire \REGF[15].RFW.q_wire[4] ;
 wire \REGF[15].RFW.q_wire[5] ;
 wire \REGF[15].RFW.q_wire[6] ;
 wire \REGF[15].RFW.q_wire[7] ;
 wire \REGF[15].RFW.q_wire[8] ;
 wire \REGF[15].RFW.q_wire[9] ;
 wire \REGF[15].RFW.we_wire ;
 wire \REGF[16].RFW.GCLK[0] ;
 wire \REGF[16].RFW.GCLK[1] ;
 wire \REGF[16].RFW.GCLK[2] ;
 wire \REGF[16].RFW.GCLK[3] ;
 wire \REGF[16].RFW.SEL1_B[0] ;
 wire \REGF[16].RFW.SEL1_B[1] ;
 wire \REGF[16].RFW.SEL1_B[2] ;
 wire \REGF[16].RFW.SEL1_B[3] ;
 wire \REGF[16].RFW.SEL2_B[0] ;
 wire \REGF[16].RFW.SEL2_B[1] ;
 wire \REGF[16].RFW.SEL2_B[2] ;
 wire \REGF[16].RFW.SEL2_B[3] ;
 wire \REGF[16].RFW.q_wire[0] ;
 wire \REGF[16].RFW.q_wire[10] ;
 wire \REGF[16].RFW.q_wire[11] ;
 wire \REGF[16].RFW.q_wire[12] ;
 wire \REGF[16].RFW.q_wire[13] ;
 wire \REGF[16].RFW.q_wire[14] ;
 wire \REGF[16].RFW.q_wire[15] ;
 wire \REGF[16].RFW.q_wire[16] ;
 wire \REGF[16].RFW.q_wire[17] ;
 wire \REGF[16].RFW.q_wire[18] ;
 wire \REGF[16].RFW.q_wire[19] ;
 wire \REGF[16].RFW.q_wire[1] ;
 wire \REGF[16].RFW.q_wire[20] ;
 wire \REGF[16].RFW.q_wire[21] ;
 wire \REGF[16].RFW.q_wire[22] ;
 wire \REGF[16].RFW.q_wire[23] ;
 wire \REGF[16].RFW.q_wire[24] ;
 wire \REGF[16].RFW.q_wire[25] ;
 wire \REGF[16].RFW.q_wire[26] ;
 wire \REGF[16].RFW.q_wire[27] ;
 wire \REGF[16].RFW.q_wire[28] ;
 wire \REGF[16].RFW.q_wire[29] ;
 wire \REGF[16].RFW.q_wire[2] ;
 wire \REGF[16].RFW.q_wire[30] ;
 wire \REGF[16].RFW.q_wire[31] ;
 wire \REGF[16].RFW.q_wire[3] ;
 wire \REGF[16].RFW.q_wire[4] ;
 wire \REGF[16].RFW.q_wire[5] ;
 wire \REGF[16].RFW.q_wire[6] ;
 wire \REGF[16].RFW.q_wire[7] ;
 wire \REGF[16].RFW.q_wire[8] ;
 wire \REGF[16].RFW.q_wire[9] ;
 wire \REGF[16].RFW.we_wire ;
 wire \REGF[17].RFW.GCLK[0] ;
 wire \REGF[17].RFW.GCLK[1] ;
 wire \REGF[17].RFW.GCLK[2] ;
 wire \REGF[17].RFW.GCLK[3] ;
 wire \REGF[17].RFW.SEL1_B[0] ;
 wire \REGF[17].RFW.SEL1_B[1] ;
 wire \REGF[17].RFW.SEL1_B[2] ;
 wire \REGF[17].RFW.SEL1_B[3] ;
 wire \REGF[17].RFW.SEL2_B[0] ;
 wire \REGF[17].RFW.SEL2_B[1] ;
 wire \REGF[17].RFW.SEL2_B[2] ;
 wire \REGF[17].RFW.SEL2_B[3] ;
 wire \REGF[17].RFW.q_wire[0] ;
 wire \REGF[17].RFW.q_wire[10] ;
 wire \REGF[17].RFW.q_wire[11] ;
 wire \REGF[17].RFW.q_wire[12] ;
 wire \REGF[17].RFW.q_wire[13] ;
 wire \REGF[17].RFW.q_wire[14] ;
 wire \REGF[17].RFW.q_wire[15] ;
 wire \REGF[17].RFW.q_wire[16] ;
 wire \REGF[17].RFW.q_wire[17] ;
 wire \REGF[17].RFW.q_wire[18] ;
 wire \REGF[17].RFW.q_wire[19] ;
 wire \REGF[17].RFW.q_wire[1] ;
 wire \REGF[17].RFW.q_wire[20] ;
 wire \REGF[17].RFW.q_wire[21] ;
 wire \REGF[17].RFW.q_wire[22] ;
 wire \REGF[17].RFW.q_wire[23] ;
 wire \REGF[17].RFW.q_wire[24] ;
 wire \REGF[17].RFW.q_wire[25] ;
 wire \REGF[17].RFW.q_wire[26] ;
 wire \REGF[17].RFW.q_wire[27] ;
 wire \REGF[17].RFW.q_wire[28] ;
 wire \REGF[17].RFW.q_wire[29] ;
 wire \REGF[17].RFW.q_wire[2] ;
 wire \REGF[17].RFW.q_wire[30] ;
 wire \REGF[17].RFW.q_wire[31] ;
 wire \REGF[17].RFW.q_wire[3] ;
 wire \REGF[17].RFW.q_wire[4] ;
 wire \REGF[17].RFW.q_wire[5] ;
 wire \REGF[17].RFW.q_wire[6] ;
 wire \REGF[17].RFW.q_wire[7] ;
 wire \REGF[17].RFW.q_wire[8] ;
 wire \REGF[17].RFW.q_wire[9] ;
 wire \REGF[17].RFW.we_wire ;
 wire \REGF[18].RFW.GCLK[0] ;
 wire \REGF[18].RFW.GCLK[1] ;
 wire \REGF[18].RFW.GCLK[2] ;
 wire \REGF[18].RFW.GCLK[3] ;
 wire \REGF[18].RFW.SEL1_B[0] ;
 wire \REGF[18].RFW.SEL1_B[1] ;
 wire \REGF[18].RFW.SEL1_B[2] ;
 wire \REGF[18].RFW.SEL1_B[3] ;
 wire \REGF[18].RFW.SEL2_B[0] ;
 wire \REGF[18].RFW.SEL2_B[1] ;
 wire \REGF[18].RFW.SEL2_B[2] ;
 wire \REGF[18].RFW.SEL2_B[3] ;
 wire \REGF[18].RFW.q_wire[0] ;
 wire \REGF[18].RFW.q_wire[10] ;
 wire \REGF[18].RFW.q_wire[11] ;
 wire \REGF[18].RFW.q_wire[12] ;
 wire \REGF[18].RFW.q_wire[13] ;
 wire \REGF[18].RFW.q_wire[14] ;
 wire \REGF[18].RFW.q_wire[15] ;
 wire \REGF[18].RFW.q_wire[16] ;
 wire \REGF[18].RFW.q_wire[17] ;
 wire \REGF[18].RFW.q_wire[18] ;
 wire \REGF[18].RFW.q_wire[19] ;
 wire \REGF[18].RFW.q_wire[1] ;
 wire \REGF[18].RFW.q_wire[20] ;
 wire \REGF[18].RFW.q_wire[21] ;
 wire \REGF[18].RFW.q_wire[22] ;
 wire \REGF[18].RFW.q_wire[23] ;
 wire \REGF[18].RFW.q_wire[24] ;
 wire \REGF[18].RFW.q_wire[25] ;
 wire \REGF[18].RFW.q_wire[26] ;
 wire \REGF[18].RFW.q_wire[27] ;
 wire \REGF[18].RFW.q_wire[28] ;
 wire \REGF[18].RFW.q_wire[29] ;
 wire \REGF[18].RFW.q_wire[2] ;
 wire \REGF[18].RFW.q_wire[30] ;
 wire \REGF[18].RFW.q_wire[31] ;
 wire \REGF[18].RFW.q_wire[3] ;
 wire \REGF[18].RFW.q_wire[4] ;
 wire \REGF[18].RFW.q_wire[5] ;
 wire \REGF[18].RFW.q_wire[6] ;
 wire \REGF[18].RFW.q_wire[7] ;
 wire \REGF[18].RFW.q_wire[8] ;
 wire \REGF[18].RFW.q_wire[9] ;
 wire \REGF[18].RFW.we_wire ;
 wire \REGF[19].RFW.GCLK[0] ;
 wire \REGF[19].RFW.GCLK[1] ;
 wire \REGF[19].RFW.GCLK[2] ;
 wire \REGF[19].RFW.GCLK[3] ;
 wire \REGF[19].RFW.SEL1_B[0] ;
 wire \REGF[19].RFW.SEL1_B[1] ;
 wire \REGF[19].RFW.SEL1_B[2] ;
 wire \REGF[19].RFW.SEL1_B[3] ;
 wire \REGF[19].RFW.SEL2_B[0] ;
 wire \REGF[19].RFW.SEL2_B[1] ;
 wire \REGF[19].RFW.SEL2_B[2] ;
 wire \REGF[19].RFW.SEL2_B[3] ;
 wire \REGF[19].RFW.q_wire[0] ;
 wire \REGF[19].RFW.q_wire[10] ;
 wire \REGF[19].RFW.q_wire[11] ;
 wire \REGF[19].RFW.q_wire[12] ;
 wire \REGF[19].RFW.q_wire[13] ;
 wire \REGF[19].RFW.q_wire[14] ;
 wire \REGF[19].RFW.q_wire[15] ;
 wire \REGF[19].RFW.q_wire[16] ;
 wire \REGF[19].RFW.q_wire[17] ;
 wire \REGF[19].RFW.q_wire[18] ;
 wire \REGF[19].RFW.q_wire[19] ;
 wire \REGF[19].RFW.q_wire[1] ;
 wire \REGF[19].RFW.q_wire[20] ;
 wire \REGF[19].RFW.q_wire[21] ;
 wire \REGF[19].RFW.q_wire[22] ;
 wire \REGF[19].RFW.q_wire[23] ;
 wire \REGF[19].RFW.q_wire[24] ;
 wire \REGF[19].RFW.q_wire[25] ;
 wire \REGF[19].RFW.q_wire[26] ;
 wire \REGF[19].RFW.q_wire[27] ;
 wire \REGF[19].RFW.q_wire[28] ;
 wire \REGF[19].RFW.q_wire[29] ;
 wire \REGF[19].RFW.q_wire[2] ;
 wire \REGF[19].RFW.q_wire[30] ;
 wire \REGF[19].RFW.q_wire[31] ;
 wire \REGF[19].RFW.q_wire[3] ;
 wire \REGF[19].RFW.q_wire[4] ;
 wire \REGF[19].RFW.q_wire[5] ;
 wire \REGF[19].RFW.q_wire[6] ;
 wire \REGF[19].RFW.q_wire[7] ;
 wire \REGF[19].RFW.q_wire[8] ;
 wire \REGF[19].RFW.q_wire[9] ;
 wire \REGF[19].RFW.we_wire ;
 wire \REGF[1].RFW.GCLK[0] ;
 wire \REGF[1].RFW.GCLK[1] ;
 wire \REGF[1].RFW.GCLK[2] ;
 wire \REGF[1].RFW.GCLK[3] ;
 wire \REGF[1].RFW.SEL1_B[0] ;
 wire \REGF[1].RFW.SEL1_B[1] ;
 wire \REGF[1].RFW.SEL1_B[2] ;
 wire \REGF[1].RFW.SEL1_B[3] ;
 wire \REGF[1].RFW.SEL2_B[0] ;
 wire \REGF[1].RFW.SEL2_B[1] ;
 wire \REGF[1].RFW.SEL2_B[2] ;
 wire \REGF[1].RFW.SEL2_B[3] ;
 wire \REGF[1].RFW.q_wire[0] ;
 wire \REGF[1].RFW.q_wire[10] ;
 wire \REGF[1].RFW.q_wire[11] ;
 wire \REGF[1].RFW.q_wire[12] ;
 wire \REGF[1].RFW.q_wire[13] ;
 wire \REGF[1].RFW.q_wire[14] ;
 wire \REGF[1].RFW.q_wire[15] ;
 wire \REGF[1].RFW.q_wire[16] ;
 wire \REGF[1].RFW.q_wire[17] ;
 wire \REGF[1].RFW.q_wire[18] ;
 wire \REGF[1].RFW.q_wire[19] ;
 wire \REGF[1].RFW.q_wire[1] ;
 wire \REGF[1].RFW.q_wire[20] ;
 wire \REGF[1].RFW.q_wire[21] ;
 wire \REGF[1].RFW.q_wire[22] ;
 wire \REGF[1].RFW.q_wire[23] ;
 wire \REGF[1].RFW.q_wire[24] ;
 wire \REGF[1].RFW.q_wire[25] ;
 wire \REGF[1].RFW.q_wire[26] ;
 wire \REGF[1].RFW.q_wire[27] ;
 wire \REGF[1].RFW.q_wire[28] ;
 wire \REGF[1].RFW.q_wire[29] ;
 wire \REGF[1].RFW.q_wire[2] ;
 wire \REGF[1].RFW.q_wire[30] ;
 wire \REGF[1].RFW.q_wire[31] ;
 wire \REGF[1].RFW.q_wire[3] ;
 wire \REGF[1].RFW.q_wire[4] ;
 wire \REGF[1].RFW.q_wire[5] ;
 wire \REGF[1].RFW.q_wire[6] ;
 wire \REGF[1].RFW.q_wire[7] ;
 wire \REGF[1].RFW.q_wire[8] ;
 wire \REGF[1].RFW.q_wire[9] ;
 wire \REGF[1].RFW.we_wire ;
 wire \REGF[20].RFW.GCLK[0] ;
 wire \REGF[20].RFW.GCLK[1] ;
 wire \REGF[20].RFW.GCLK[2] ;
 wire \REGF[20].RFW.GCLK[3] ;
 wire \REGF[20].RFW.SEL1_B[0] ;
 wire \REGF[20].RFW.SEL1_B[1] ;
 wire \REGF[20].RFW.SEL1_B[2] ;
 wire \REGF[20].RFW.SEL1_B[3] ;
 wire \REGF[20].RFW.SEL2_B[0] ;
 wire \REGF[20].RFW.SEL2_B[1] ;
 wire \REGF[20].RFW.SEL2_B[2] ;
 wire \REGF[20].RFW.SEL2_B[3] ;
 wire \REGF[20].RFW.q_wire[0] ;
 wire \REGF[20].RFW.q_wire[10] ;
 wire \REGF[20].RFW.q_wire[11] ;
 wire \REGF[20].RFW.q_wire[12] ;
 wire \REGF[20].RFW.q_wire[13] ;
 wire \REGF[20].RFW.q_wire[14] ;
 wire \REGF[20].RFW.q_wire[15] ;
 wire \REGF[20].RFW.q_wire[16] ;
 wire \REGF[20].RFW.q_wire[17] ;
 wire \REGF[20].RFW.q_wire[18] ;
 wire \REGF[20].RFW.q_wire[19] ;
 wire \REGF[20].RFW.q_wire[1] ;
 wire \REGF[20].RFW.q_wire[20] ;
 wire \REGF[20].RFW.q_wire[21] ;
 wire \REGF[20].RFW.q_wire[22] ;
 wire \REGF[20].RFW.q_wire[23] ;
 wire \REGF[20].RFW.q_wire[24] ;
 wire \REGF[20].RFW.q_wire[25] ;
 wire \REGF[20].RFW.q_wire[26] ;
 wire \REGF[20].RFW.q_wire[27] ;
 wire \REGF[20].RFW.q_wire[28] ;
 wire \REGF[20].RFW.q_wire[29] ;
 wire \REGF[20].RFW.q_wire[2] ;
 wire \REGF[20].RFW.q_wire[30] ;
 wire \REGF[20].RFW.q_wire[31] ;
 wire \REGF[20].RFW.q_wire[3] ;
 wire \REGF[20].RFW.q_wire[4] ;
 wire \REGF[20].RFW.q_wire[5] ;
 wire \REGF[20].RFW.q_wire[6] ;
 wire \REGF[20].RFW.q_wire[7] ;
 wire \REGF[20].RFW.q_wire[8] ;
 wire \REGF[20].RFW.q_wire[9] ;
 wire \REGF[20].RFW.we_wire ;
 wire \REGF[21].RFW.GCLK[0] ;
 wire \REGF[21].RFW.GCLK[1] ;
 wire \REGF[21].RFW.GCLK[2] ;
 wire \REGF[21].RFW.GCLK[3] ;
 wire \REGF[21].RFW.SEL1_B[0] ;
 wire \REGF[21].RFW.SEL1_B[1] ;
 wire \REGF[21].RFW.SEL1_B[2] ;
 wire \REGF[21].RFW.SEL1_B[3] ;
 wire \REGF[21].RFW.SEL2_B[0] ;
 wire \REGF[21].RFW.SEL2_B[1] ;
 wire \REGF[21].RFW.SEL2_B[2] ;
 wire \REGF[21].RFW.SEL2_B[3] ;
 wire \REGF[21].RFW.q_wire[0] ;
 wire \REGF[21].RFW.q_wire[10] ;
 wire \REGF[21].RFW.q_wire[11] ;
 wire \REGF[21].RFW.q_wire[12] ;
 wire \REGF[21].RFW.q_wire[13] ;
 wire \REGF[21].RFW.q_wire[14] ;
 wire \REGF[21].RFW.q_wire[15] ;
 wire \REGF[21].RFW.q_wire[16] ;
 wire \REGF[21].RFW.q_wire[17] ;
 wire \REGF[21].RFW.q_wire[18] ;
 wire \REGF[21].RFW.q_wire[19] ;
 wire \REGF[21].RFW.q_wire[1] ;
 wire \REGF[21].RFW.q_wire[20] ;
 wire \REGF[21].RFW.q_wire[21] ;
 wire \REGF[21].RFW.q_wire[22] ;
 wire \REGF[21].RFW.q_wire[23] ;
 wire \REGF[21].RFW.q_wire[24] ;
 wire \REGF[21].RFW.q_wire[25] ;
 wire \REGF[21].RFW.q_wire[26] ;
 wire \REGF[21].RFW.q_wire[27] ;
 wire \REGF[21].RFW.q_wire[28] ;
 wire \REGF[21].RFW.q_wire[29] ;
 wire \REGF[21].RFW.q_wire[2] ;
 wire \REGF[21].RFW.q_wire[30] ;
 wire \REGF[21].RFW.q_wire[31] ;
 wire \REGF[21].RFW.q_wire[3] ;
 wire \REGF[21].RFW.q_wire[4] ;
 wire \REGF[21].RFW.q_wire[5] ;
 wire \REGF[21].RFW.q_wire[6] ;
 wire \REGF[21].RFW.q_wire[7] ;
 wire \REGF[21].RFW.q_wire[8] ;
 wire \REGF[21].RFW.q_wire[9] ;
 wire \REGF[21].RFW.we_wire ;
 wire \REGF[22].RFW.GCLK[0] ;
 wire \REGF[22].RFW.GCLK[1] ;
 wire \REGF[22].RFW.GCLK[2] ;
 wire \REGF[22].RFW.GCLK[3] ;
 wire \REGF[22].RFW.SEL1_B[0] ;
 wire \REGF[22].RFW.SEL1_B[1] ;
 wire \REGF[22].RFW.SEL1_B[2] ;
 wire \REGF[22].RFW.SEL1_B[3] ;
 wire \REGF[22].RFW.SEL2_B[0] ;
 wire \REGF[22].RFW.SEL2_B[1] ;
 wire \REGF[22].RFW.SEL2_B[2] ;
 wire \REGF[22].RFW.SEL2_B[3] ;
 wire \REGF[22].RFW.q_wire[0] ;
 wire \REGF[22].RFW.q_wire[10] ;
 wire \REGF[22].RFW.q_wire[11] ;
 wire \REGF[22].RFW.q_wire[12] ;
 wire \REGF[22].RFW.q_wire[13] ;
 wire \REGF[22].RFW.q_wire[14] ;
 wire \REGF[22].RFW.q_wire[15] ;
 wire \REGF[22].RFW.q_wire[16] ;
 wire \REGF[22].RFW.q_wire[17] ;
 wire \REGF[22].RFW.q_wire[18] ;
 wire \REGF[22].RFW.q_wire[19] ;
 wire \REGF[22].RFW.q_wire[1] ;
 wire \REGF[22].RFW.q_wire[20] ;
 wire \REGF[22].RFW.q_wire[21] ;
 wire \REGF[22].RFW.q_wire[22] ;
 wire \REGF[22].RFW.q_wire[23] ;
 wire \REGF[22].RFW.q_wire[24] ;
 wire \REGF[22].RFW.q_wire[25] ;
 wire \REGF[22].RFW.q_wire[26] ;
 wire \REGF[22].RFW.q_wire[27] ;
 wire \REGF[22].RFW.q_wire[28] ;
 wire \REGF[22].RFW.q_wire[29] ;
 wire \REGF[22].RFW.q_wire[2] ;
 wire \REGF[22].RFW.q_wire[30] ;
 wire \REGF[22].RFW.q_wire[31] ;
 wire \REGF[22].RFW.q_wire[3] ;
 wire \REGF[22].RFW.q_wire[4] ;
 wire \REGF[22].RFW.q_wire[5] ;
 wire \REGF[22].RFW.q_wire[6] ;
 wire \REGF[22].RFW.q_wire[7] ;
 wire \REGF[22].RFW.q_wire[8] ;
 wire \REGF[22].RFW.q_wire[9] ;
 wire \REGF[22].RFW.we_wire ;
 wire \REGF[23].RFW.GCLK[0] ;
 wire \REGF[23].RFW.GCLK[1] ;
 wire \REGF[23].RFW.GCLK[2] ;
 wire \REGF[23].RFW.GCLK[3] ;
 wire \REGF[23].RFW.SEL1_B[0] ;
 wire \REGF[23].RFW.SEL1_B[1] ;
 wire \REGF[23].RFW.SEL1_B[2] ;
 wire \REGF[23].RFW.SEL1_B[3] ;
 wire \REGF[23].RFW.SEL2_B[0] ;
 wire \REGF[23].RFW.SEL2_B[1] ;
 wire \REGF[23].RFW.SEL2_B[2] ;
 wire \REGF[23].RFW.SEL2_B[3] ;
 wire \REGF[23].RFW.q_wire[0] ;
 wire \REGF[23].RFW.q_wire[10] ;
 wire \REGF[23].RFW.q_wire[11] ;
 wire \REGF[23].RFW.q_wire[12] ;
 wire \REGF[23].RFW.q_wire[13] ;
 wire \REGF[23].RFW.q_wire[14] ;
 wire \REGF[23].RFW.q_wire[15] ;
 wire \REGF[23].RFW.q_wire[16] ;
 wire \REGF[23].RFW.q_wire[17] ;
 wire \REGF[23].RFW.q_wire[18] ;
 wire \REGF[23].RFW.q_wire[19] ;
 wire \REGF[23].RFW.q_wire[1] ;
 wire \REGF[23].RFW.q_wire[20] ;
 wire \REGF[23].RFW.q_wire[21] ;
 wire \REGF[23].RFW.q_wire[22] ;
 wire \REGF[23].RFW.q_wire[23] ;
 wire \REGF[23].RFW.q_wire[24] ;
 wire \REGF[23].RFW.q_wire[25] ;
 wire \REGF[23].RFW.q_wire[26] ;
 wire \REGF[23].RFW.q_wire[27] ;
 wire \REGF[23].RFW.q_wire[28] ;
 wire \REGF[23].RFW.q_wire[29] ;
 wire \REGF[23].RFW.q_wire[2] ;
 wire \REGF[23].RFW.q_wire[30] ;
 wire \REGF[23].RFW.q_wire[31] ;
 wire \REGF[23].RFW.q_wire[3] ;
 wire \REGF[23].RFW.q_wire[4] ;
 wire \REGF[23].RFW.q_wire[5] ;
 wire \REGF[23].RFW.q_wire[6] ;
 wire \REGF[23].RFW.q_wire[7] ;
 wire \REGF[23].RFW.q_wire[8] ;
 wire \REGF[23].RFW.q_wire[9] ;
 wire \REGF[23].RFW.we_wire ;
 wire \REGF[24].RFW.GCLK[0] ;
 wire \REGF[24].RFW.GCLK[1] ;
 wire \REGF[24].RFW.GCLK[2] ;
 wire \REGF[24].RFW.GCLK[3] ;
 wire \REGF[24].RFW.SEL1_B[0] ;
 wire \REGF[24].RFW.SEL1_B[1] ;
 wire \REGF[24].RFW.SEL1_B[2] ;
 wire \REGF[24].RFW.SEL1_B[3] ;
 wire \REGF[24].RFW.SEL2_B[0] ;
 wire \REGF[24].RFW.SEL2_B[1] ;
 wire \REGF[24].RFW.SEL2_B[2] ;
 wire \REGF[24].RFW.SEL2_B[3] ;
 wire \REGF[24].RFW.q_wire[0] ;
 wire \REGF[24].RFW.q_wire[10] ;
 wire \REGF[24].RFW.q_wire[11] ;
 wire \REGF[24].RFW.q_wire[12] ;
 wire \REGF[24].RFW.q_wire[13] ;
 wire \REGF[24].RFW.q_wire[14] ;
 wire \REGF[24].RFW.q_wire[15] ;
 wire \REGF[24].RFW.q_wire[16] ;
 wire \REGF[24].RFW.q_wire[17] ;
 wire \REGF[24].RFW.q_wire[18] ;
 wire \REGF[24].RFW.q_wire[19] ;
 wire \REGF[24].RFW.q_wire[1] ;
 wire \REGF[24].RFW.q_wire[20] ;
 wire \REGF[24].RFW.q_wire[21] ;
 wire \REGF[24].RFW.q_wire[22] ;
 wire \REGF[24].RFW.q_wire[23] ;
 wire \REGF[24].RFW.q_wire[24] ;
 wire \REGF[24].RFW.q_wire[25] ;
 wire \REGF[24].RFW.q_wire[26] ;
 wire \REGF[24].RFW.q_wire[27] ;
 wire \REGF[24].RFW.q_wire[28] ;
 wire \REGF[24].RFW.q_wire[29] ;
 wire \REGF[24].RFW.q_wire[2] ;
 wire \REGF[24].RFW.q_wire[30] ;
 wire \REGF[24].RFW.q_wire[31] ;
 wire \REGF[24].RFW.q_wire[3] ;
 wire \REGF[24].RFW.q_wire[4] ;
 wire \REGF[24].RFW.q_wire[5] ;
 wire \REGF[24].RFW.q_wire[6] ;
 wire \REGF[24].RFW.q_wire[7] ;
 wire \REGF[24].RFW.q_wire[8] ;
 wire \REGF[24].RFW.q_wire[9] ;
 wire \REGF[24].RFW.we_wire ;
 wire \REGF[25].RFW.GCLK[0] ;
 wire \REGF[25].RFW.GCLK[1] ;
 wire \REGF[25].RFW.GCLK[2] ;
 wire \REGF[25].RFW.GCLK[3] ;
 wire \REGF[25].RFW.SEL1_B[0] ;
 wire \REGF[25].RFW.SEL1_B[1] ;
 wire \REGF[25].RFW.SEL1_B[2] ;
 wire \REGF[25].RFW.SEL1_B[3] ;
 wire \REGF[25].RFW.SEL2_B[0] ;
 wire \REGF[25].RFW.SEL2_B[1] ;
 wire \REGF[25].RFW.SEL2_B[2] ;
 wire \REGF[25].RFW.SEL2_B[3] ;
 wire \REGF[25].RFW.q_wire[0] ;
 wire \REGF[25].RFW.q_wire[10] ;
 wire \REGF[25].RFW.q_wire[11] ;
 wire \REGF[25].RFW.q_wire[12] ;
 wire \REGF[25].RFW.q_wire[13] ;
 wire \REGF[25].RFW.q_wire[14] ;
 wire \REGF[25].RFW.q_wire[15] ;
 wire \REGF[25].RFW.q_wire[16] ;
 wire \REGF[25].RFW.q_wire[17] ;
 wire \REGF[25].RFW.q_wire[18] ;
 wire \REGF[25].RFW.q_wire[19] ;
 wire \REGF[25].RFW.q_wire[1] ;
 wire \REGF[25].RFW.q_wire[20] ;
 wire \REGF[25].RFW.q_wire[21] ;
 wire \REGF[25].RFW.q_wire[22] ;
 wire \REGF[25].RFW.q_wire[23] ;
 wire \REGF[25].RFW.q_wire[24] ;
 wire \REGF[25].RFW.q_wire[25] ;
 wire \REGF[25].RFW.q_wire[26] ;
 wire \REGF[25].RFW.q_wire[27] ;
 wire \REGF[25].RFW.q_wire[28] ;
 wire \REGF[25].RFW.q_wire[29] ;
 wire \REGF[25].RFW.q_wire[2] ;
 wire \REGF[25].RFW.q_wire[30] ;
 wire \REGF[25].RFW.q_wire[31] ;
 wire \REGF[25].RFW.q_wire[3] ;
 wire \REGF[25].RFW.q_wire[4] ;
 wire \REGF[25].RFW.q_wire[5] ;
 wire \REGF[25].RFW.q_wire[6] ;
 wire \REGF[25].RFW.q_wire[7] ;
 wire \REGF[25].RFW.q_wire[8] ;
 wire \REGF[25].RFW.q_wire[9] ;
 wire \REGF[25].RFW.we_wire ;
 wire \REGF[26].RFW.GCLK[0] ;
 wire \REGF[26].RFW.GCLK[1] ;
 wire \REGF[26].RFW.GCLK[2] ;
 wire \REGF[26].RFW.GCLK[3] ;
 wire \REGF[26].RFW.SEL1_B[0] ;
 wire \REGF[26].RFW.SEL1_B[1] ;
 wire \REGF[26].RFW.SEL1_B[2] ;
 wire \REGF[26].RFW.SEL1_B[3] ;
 wire \REGF[26].RFW.SEL2_B[0] ;
 wire \REGF[26].RFW.SEL2_B[1] ;
 wire \REGF[26].RFW.SEL2_B[2] ;
 wire \REGF[26].RFW.SEL2_B[3] ;
 wire \REGF[26].RFW.q_wire[0] ;
 wire \REGF[26].RFW.q_wire[10] ;
 wire \REGF[26].RFW.q_wire[11] ;
 wire \REGF[26].RFW.q_wire[12] ;
 wire \REGF[26].RFW.q_wire[13] ;
 wire \REGF[26].RFW.q_wire[14] ;
 wire \REGF[26].RFW.q_wire[15] ;
 wire \REGF[26].RFW.q_wire[16] ;
 wire \REGF[26].RFW.q_wire[17] ;
 wire \REGF[26].RFW.q_wire[18] ;
 wire \REGF[26].RFW.q_wire[19] ;
 wire \REGF[26].RFW.q_wire[1] ;
 wire \REGF[26].RFW.q_wire[20] ;
 wire \REGF[26].RFW.q_wire[21] ;
 wire \REGF[26].RFW.q_wire[22] ;
 wire \REGF[26].RFW.q_wire[23] ;
 wire \REGF[26].RFW.q_wire[24] ;
 wire \REGF[26].RFW.q_wire[25] ;
 wire \REGF[26].RFW.q_wire[26] ;
 wire \REGF[26].RFW.q_wire[27] ;
 wire \REGF[26].RFW.q_wire[28] ;
 wire \REGF[26].RFW.q_wire[29] ;
 wire \REGF[26].RFW.q_wire[2] ;
 wire \REGF[26].RFW.q_wire[30] ;
 wire \REGF[26].RFW.q_wire[31] ;
 wire \REGF[26].RFW.q_wire[3] ;
 wire \REGF[26].RFW.q_wire[4] ;
 wire \REGF[26].RFW.q_wire[5] ;
 wire \REGF[26].RFW.q_wire[6] ;
 wire \REGF[26].RFW.q_wire[7] ;
 wire \REGF[26].RFW.q_wire[8] ;
 wire \REGF[26].RFW.q_wire[9] ;
 wire \REGF[26].RFW.we_wire ;
 wire \REGF[27].RFW.GCLK[0] ;
 wire \REGF[27].RFW.GCLK[1] ;
 wire \REGF[27].RFW.GCLK[2] ;
 wire \REGF[27].RFW.GCLK[3] ;
 wire \REGF[27].RFW.SEL1_B[0] ;
 wire \REGF[27].RFW.SEL1_B[1] ;
 wire \REGF[27].RFW.SEL1_B[2] ;
 wire \REGF[27].RFW.SEL1_B[3] ;
 wire \REGF[27].RFW.SEL2_B[0] ;
 wire \REGF[27].RFW.SEL2_B[1] ;
 wire \REGF[27].RFW.SEL2_B[2] ;
 wire \REGF[27].RFW.SEL2_B[3] ;
 wire \REGF[27].RFW.q_wire[0] ;
 wire \REGF[27].RFW.q_wire[10] ;
 wire \REGF[27].RFW.q_wire[11] ;
 wire \REGF[27].RFW.q_wire[12] ;
 wire \REGF[27].RFW.q_wire[13] ;
 wire \REGF[27].RFW.q_wire[14] ;
 wire \REGF[27].RFW.q_wire[15] ;
 wire \REGF[27].RFW.q_wire[16] ;
 wire \REGF[27].RFW.q_wire[17] ;
 wire \REGF[27].RFW.q_wire[18] ;
 wire \REGF[27].RFW.q_wire[19] ;
 wire \REGF[27].RFW.q_wire[1] ;
 wire \REGF[27].RFW.q_wire[20] ;
 wire \REGF[27].RFW.q_wire[21] ;
 wire \REGF[27].RFW.q_wire[22] ;
 wire \REGF[27].RFW.q_wire[23] ;
 wire \REGF[27].RFW.q_wire[24] ;
 wire \REGF[27].RFW.q_wire[25] ;
 wire \REGF[27].RFW.q_wire[26] ;
 wire \REGF[27].RFW.q_wire[27] ;
 wire \REGF[27].RFW.q_wire[28] ;
 wire \REGF[27].RFW.q_wire[29] ;
 wire \REGF[27].RFW.q_wire[2] ;
 wire \REGF[27].RFW.q_wire[30] ;
 wire \REGF[27].RFW.q_wire[31] ;
 wire \REGF[27].RFW.q_wire[3] ;
 wire \REGF[27].RFW.q_wire[4] ;
 wire \REGF[27].RFW.q_wire[5] ;
 wire \REGF[27].RFW.q_wire[6] ;
 wire \REGF[27].RFW.q_wire[7] ;
 wire \REGF[27].RFW.q_wire[8] ;
 wire \REGF[27].RFW.q_wire[9] ;
 wire \REGF[27].RFW.we_wire ;
 wire \REGF[28].RFW.GCLK[0] ;
 wire \REGF[28].RFW.GCLK[1] ;
 wire \REGF[28].RFW.GCLK[2] ;
 wire \REGF[28].RFW.GCLK[3] ;
 wire \REGF[28].RFW.SEL1_B[0] ;
 wire \REGF[28].RFW.SEL1_B[1] ;
 wire \REGF[28].RFW.SEL1_B[2] ;
 wire \REGF[28].RFW.SEL1_B[3] ;
 wire \REGF[28].RFW.SEL2_B[0] ;
 wire \REGF[28].RFW.SEL2_B[1] ;
 wire \REGF[28].RFW.SEL2_B[2] ;
 wire \REGF[28].RFW.SEL2_B[3] ;
 wire \REGF[28].RFW.q_wire[0] ;
 wire \REGF[28].RFW.q_wire[10] ;
 wire \REGF[28].RFW.q_wire[11] ;
 wire \REGF[28].RFW.q_wire[12] ;
 wire \REGF[28].RFW.q_wire[13] ;
 wire \REGF[28].RFW.q_wire[14] ;
 wire \REGF[28].RFW.q_wire[15] ;
 wire \REGF[28].RFW.q_wire[16] ;
 wire \REGF[28].RFW.q_wire[17] ;
 wire \REGF[28].RFW.q_wire[18] ;
 wire \REGF[28].RFW.q_wire[19] ;
 wire \REGF[28].RFW.q_wire[1] ;
 wire \REGF[28].RFW.q_wire[20] ;
 wire \REGF[28].RFW.q_wire[21] ;
 wire \REGF[28].RFW.q_wire[22] ;
 wire \REGF[28].RFW.q_wire[23] ;
 wire \REGF[28].RFW.q_wire[24] ;
 wire \REGF[28].RFW.q_wire[25] ;
 wire \REGF[28].RFW.q_wire[26] ;
 wire \REGF[28].RFW.q_wire[27] ;
 wire \REGF[28].RFW.q_wire[28] ;
 wire \REGF[28].RFW.q_wire[29] ;
 wire \REGF[28].RFW.q_wire[2] ;
 wire \REGF[28].RFW.q_wire[30] ;
 wire \REGF[28].RFW.q_wire[31] ;
 wire \REGF[28].RFW.q_wire[3] ;
 wire \REGF[28].RFW.q_wire[4] ;
 wire \REGF[28].RFW.q_wire[5] ;
 wire \REGF[28].RFW.q_wire[6] ;
 wire \REGF[28].RFW.q_wire[7] ;
 wire \REGF[28].RFW.q_wire[8] ;
 wire \REGF[28].RFW.q_wire[9] ;
 wire \REGF[28].RFW.we_wire ;
 wire \REGF[29].RFW.GCLK[0] ;
 wire \REGF[29].RFW.GCLK[1] ;
 wire \REGF[29].RFW.GCLK[2] ;
 wire \REGF[29].RFW.GCLK[3] ;
 wire \REGF[29].RFW.SEL1_B[0] ;
 wire \REGF[29].RFW.SEL1_B[1] ;
 wire \REGF[29].RFW.SEL1_B[2] ;
 wire \REGF[29].RFW.SEL1_B[3] ;
 wire \REGF[29].RFW.SEL2_B[0] ;
 wire \REGF[29].RFW.SEL2_B[1] ;
 wire \REGF[29].RFW.SEL2_B[2] ;
 wire \REGF[29].RFW.SEL2_B[3] ;
 wire \REGF[29].RFW.q_wire[0] ;
 wire \REGF[29].RFW.q_wire[10] ;
 wire \REGF[29].RFW.q_wire[11] ;
 wire \REGF[29].RFW.q_wire[12] ;
 wire \REGF[29].RFW.q_wire[13] ;
 wire \REGF[29].RFW.q_wire[14] ;
 wire \REGF[29].RFW.q_wire[15] ;
 wire \REGF[29].RFW.q_wire[16] ;
 wire \REGF[29].RFW.q_wire[17] ;
 wire \REGF[29].RFW.q_wire[18] ;
 wire \REGF[29].RFW.q_wire[19] ;
 wire \REGF[29].RFW.q_wire[1] ;
 wire \REGF[29].RFW.q_wire[20] ;
 wire \REGF[29].RFW.q_wire[21] ;
 wire \REGF[29].RFW.q_wire[22] ;
 wire \REGF[29].RFW.q_wire[23] ;
 wire \REGF[29].RFW.q_wire[24] ;
 wire \REGF[29].RFW.q_wire[25] ;
 wire \REGF[29].RFW.q_wire[26] ;
 wire \REGF[29].RFW.q_wire[27] ;
 wire \REGF[29].RFW.q_wire[28] ;
 wire \REGF[29].RFW.q_wire[29] ;
 wire \REGF[29].RFW.q_wire[2] ;
 wire \REGF[29].RFW.q_wire[30] ;
 wire \REGF[29].RFW.q_wire[31] ;
 wire \REGF[29].RFW.q_wire[3] ;
 wire \REGF[29].RFW.q_wire[4] ;
 wire \REGF[29].RFW.q_wire[5] ;
 wire \REGF[29].RFW.q_wire[6] ;
 wire \REGF[29].RFW.q_wire[7] ;
 wire \REGF[29].RFW.q_wire[8] ;
 wire \REGF[29].RFW.q_wire[9] ;
 wire \REGF[29].RFW.we_wire ;
 wire \REGF[2].RFW.GCLK[0] ;
 wire \REGF[2].RFW.GCLK[1] ;
 wire \REGF[2].RFW.GCLK[2] ;
 wire \REGF[2].RFW.GCLK[3] ;
 wire \REGF[2].RFW.SEL1_B[0] ;
 wire \REGF[2].RFW.SEL1_B[1] ;
 wire \REGF[2].RFW.SEL1_B[2] ;
 wire \REGF[2].RFW.SEL1_B[3] ;
 wire \REGF[2].RFW.SEL2_B[0] ;
 wire \REGF[2].RFW.SEL2_B[1] ;
 wire \REGF[2].RFW.SEL2_B[2] ;
 wire \REGF[2].RFW.SEL2_B[3] ;
 wire \REGF[2].RFW.q_wire[0] ;
 wire \REGF[2].RFW.q_wire[10] ;
 wire \REGF[2].RFW.q_wire[11] ;
 wire \REGF[2].RFW.q_wire[12] ;
 wire \REGF[2].RFW.q_wire[13] ;
 wire \REGF[2].RFW.q_wire[14] ;
 wire \REGF[2].RFW.q_wire[15] ;
 wire \REGF[2].RFW.q_wire[16] ;
 wire \REGF[2].RFW.q_wire[17] ;
 wire \REGF[2].RFW.q_wire[18] ;
 wire \REGF[2].RFW.q_wire[19] ;
 wire \REGF[2].RFW.q_wire[1] ;
 wire \REGF[2].RFW.q_wire[20] ;
 wire \REGF[2].RFW.q_wire[21] ;
 wire \REGF[2].RFW.q_wire[22] ;
 wire \REGF[2].RFW.q_wire[23] ;
 wire \REGF[2].RFW.q_wire[24] ;
 wire \REGF[2].RFW.q_wire[25] ;
 wire \REGF[2].RFW.q_wire[26] ;
 wire \REGF[2].RFW.q_wire[27] ;
 wire \REGF[2].RFW.q_wire[28] ;
 wire \REGF[2].RFW.q_wire[29] ;
 wire \REGF[2].RFW.q_wire[2] ;
 wire \REGF[2].RFW.q_wire[30] ;
 wire \REGF[2].RFW.q_wire[31] ;
 wire \REGF[2].RFW.q_wire[3] ;
 wire \REGF[2].RFW.q_wire[4] ;
 wire \REGF[2].RFW.q_wire[5] ;
 wire \REGF[2].RFW.q_wire[6] ;
 wire \REGF[2].RFW.q_wire[7] ;
 wire \REGF[2].RFW.q_wire[8] ;
 wire \REGF[2].RFW.q_wire[9] ;
 wire \REGF[2].RFW.we_wire ;
 wire \REGF[30].RFW.GCLK[0] ;
 wire \REGF[30].RFW.GCLK[1] ;
 wire \REGF[30].RFW.GCLK[2] ;
 wire \REGF[30].RFW.GCLK[3] ;
 wire \REGF[30].RFW.SEL1_B[0] ;
 wire \REGF[30].RFW.SEL1_B[1] ;
 wire \REGF[30].RFW.SEL1_B[2] ;
 wire \REGF[30].RFW.SEL1_B[3] ;
 wire \REGF[30].RFW.SEL2_B[0] ;
 wire \REGF[30].RFW.SEL2_B[1] ;
 wire \REGF[30].RFW.SEL2_B[2] ;
 wire \REGF[30].RFW.SEL2_B[3] ;
 wire \REGF[30].RFW.q_wire[0] ;
 wire \REGF[30].RFW.q_wire[10] ;
 wire \REGF[30].RFW.q_wire[11] ;
 wire \REGF[30].RFW.q_wire[12] ;
 wire \REGF[30].RFW.q_wire[13] ;
 wire \REGF[30].RFW.q_wire[14] ;
 wire \REGF[30].RFW.q_wire[15] ;
 wire \REGF[30].RFW.q_wire[16] ;
 wire \REGF[30].RFW.q_wire[17] ;
 wire \REGF[30].RFW.q_wire[18] ;
 wire \REGF[30].RFW.q_wire[19] ;
 wire \REGF[30].RFW.q_wire[1] ;
 wire \REGF[30].RFW.q_wire[20] ;
 wire \REGF[30].RFW.q_wire[21] ;
 wire \REGF[30].RFW.q_wire[22] ;
 wire \REGF[30].RFW.q_wire[23] ;
 wire \REGF[30].RFW.q_wire[24] ;
 wire \REGF[30].RFW.q_wire[25] ;
 wire \REGF[30].RFW.q_wire[26] ;
 wire \REGF[30].RFW.q_wire[27] ;
 wire \REGF[30].RFW.q_wire[28] ;
 wire \REGF[30].RFW.q_wire[29] ;
 wire \REGF[30].RFW.q_wire[2] ;
 wire \REGF[30].RFW.q_wire[30] ;
 wire \REGF[30].RFW.q_wire[31] ;
 wire \REGF[30].RFW.q_wire[3] ;
 wire \REGF[30].RFW.q_wire[4] ;
 wire \REGF[30].RFW.q_wire[5] ;
 wire \REGF[30].RFW.q_wire[6] ;
 wire \REGF[30].RFW.q_wire[7] ;
 wire \REGF[30].RFW.q_wire[8] ;
 wire \REGF[30].RFW.q_wire[9] ;
 wire \REGF[30].RFW.we_wire ;
 wire \REGF[31].RFW.GCLK[0] ;
 wire \REGF[31].RFW.GCLK[1] ;
 wire \REGF[31].RFW.GCLK[2] ;
 wire \REGF[31].RFW.GCLK[3] ;
 wire \REGF[31].RFW.SEL1_B[0] ;
 wire \REGF[31].RFW.SEL1_B[1] ;
 wire \REGF[31].RFW.SEL1_B[2] ;
 wire \REGF[31].RFW.SEL1_B[3] ;
 wire \REGF[31].RFW.SEL2_B[0] ;
 wire \REGF[31].RFW.SEL2_B[1] ;
 wire \REGF[31].RFW.SEL2_B[2] ;
 wire \REGF[31].RFW.SEL2_B[3] ;
 wire \REGF[31].RFW.q_wire[0] ;
 wire \REGF[31].RFW.q_wire[10] ;
 wire \REGF[31].RFW.q_wire[11] ;
 wire \REGF[31].RFW.q_wire[12] ;
 wire \REGF[31].RFW.q_wire[13] ;
 wire \REGF[31].RFW.q_wire[14] ;
 wire \REGF[31].RFW.q_wire[15] ;
 wire \REGF[31].RFW.q_wire[16] ;
 wire \REGF[31].RFW.q_wire[17] ;
 wire \REGF[31].RFW.q_wire[18] ;
 wire \REGF[31].RFW.q_wire[19] ;
 wire \REGF[31].RFW.q_wire[1] ;
 wire \REGF[31].RFW.q_wire[20] ;
 wire \REGF[31].RFW.q_wire[21] ;
 wire \REGF[31].RFW.q_wire[22] ;
 wire \REGF[31].RFW.q_wire[23] ;
 wire \REGF[31].RFW.q_wire[24] ;
 wire \REGF[31].RFW.q_wire[25] ;
 wire \REGF[31].RFW.q_wire[26] ;
 wire \REGF[31].RFW.q_wire[27] ;
 wire \REGF[31].RFW.q_wire[28] ;
 wire \REGF[31].RFW.q_wire[29] ;
 wire \REGF[31].RFW.q_wire[2] ;
 wire \REGF[31].RFW.q_wire[30] ;
 wire \REGF[31].RFW.q_wire[31] ;
 wire \REGF[31].RFW.q_wire[3] ;
 wire \REGF[31].RFW.q_wire[4] ;
 wire \REGF[31].RFW.q_wire[5] ;
 wire \REGF[31].RFW.q_wire[6] ;
 wire \REGF[31].RFW.q_wire[7] ;
 wire \REGF[31].RFW.q_wire[8] ;
 wire \REGF[31].RFW.q_wire[9] ;
 wire \REGF[31].RFW.we_wire ;
 wire \REGF[3].RFW.GCLK[0] ;
 wire \REGF[3].RFW.GCLK[1] ;
 wire \REGF[3].RFW.GCLK[2] ;
 wire \REGF[3].RFW.GCLK[3] ;
 wire \REGF[3].RFW.SEL1_B[0] ;
 wire \REGF[3].RFW.SEL1_B[1] ;
 wire \REGF[3].RFW.SEL1_B[2] ;
 wire \REGF[3].RFW.SEL1_B[3] ;
 wire \REGF[3].RFW.SEL2_B[0] ;
 wire \REGF[3].RFW.SEL2_B[1] ;
 wire \REGF[3].RFW.SEL2_B[2] ;
 wire \REGF[3].RFW.SEL2_B[3] ;
 wire \REGF[3].RFW.q_wire[0] ;
 wire \REGF[3].RFW.q_wire[10] ;
 wire \REGF[3].RFW.q_wire[11] ;
 wire \REGF[3].RFW.q_wire[12] ;
 wire \REGF[3].RFW.q_wire[13] ;
 wire \REGF[3].RFW.q_wire[14] ;
 wire \REGF[3].RFW.q_wire[15] ;
 wire \REGF[3].RFW.q_wire[16] ;
 wire \REGF[3].RFW.q_wire[17] ;
 wire \REGF[3].RFW.q_wire[18] ;
 wire \REGF[3].RFW.q_wire[19] ;
 wire \REGF[3].RFW.q_wire[1] ;
 wire \REGF[3].RFW.q_wire[20] ;
 wire \REGF[3].RFW.q_wire[21] ;
 wire \REGF[3].RFW.q_wire[22] ;
 wire \REGF[3].RFW.q_wire[23] ;
 wire \REGF[3].RFW.q_wire[24] ;
 wire \REGF[3].RFW.q_wire[25] ;
 wire \REGF[3].RFW.q_wire[26] ;
 wire \REGF[3].RFW.q_wire[27] ;
 wire \REGF[3].RFW.q_wire[28] ;
 wire \REGF[3].RFW.q_wire[29] ;
 wire \REGF[3].RFW.q_wire[2] ;
 wire \REGF[3].RFW.q_wire[30] ;
 wire \REGF[3].RFW.q_wire[31] ;
 wire \REGF[3].RFW.q_wire[3] ;
 wire \REGF[3].RFW.q_wire[4] ;
 wire \REGF[3].RFW.q_wire[5] ;
 wire \REGF[3].RFW.q_wire[6] ;
 wire \REGF[3].RFW.q_wire[7] ;
 wire \REGF[3].RFW.q_wire[8] ;
 wire \REGF[3].RFW.q_wire[9] ;
 wire \REGF[3].RFW.we_wire ;
 wire \REGF[4].RFW.GCLK[0] ;
 wire \REGF[4].RFW.GCLK[1] ;
 wire \REGF[4].RFW.GCLK[2] ;
 wire \REGF[4].RFW.GCLK[3] ;
 wire \REGF[4].RFW.SEL1_B[0] ;
 wire \REGF[4].RFW.SEL1_B[1] ;
 wire \REGF[4].RFW.SEL1_B[2] ;
 wire \REGF[4].RFW.SEL1_B[3] ;
 wire \REGF[4].RFW.SEL2_B[0] ;
 wire \REGF[4].RFW.SEL2_B[1] ;
 wire \REGF[4].RFW.SEL2_B[2] ;
 wire \REGF[4].RFW.SEL2_B[3] ;
 wire \REGF[4].RFW.q_wire[0] ;
 wire \REGF[4].RFW.q_wire[10] ;
 wire \REGF[4].RFW.q_wire[11] ;
 wire \REGF[4].RFW.q_wire[12] ;
 wire \REGF[4].RFW.q_wire[13] ;
 wire \REGF[4].RFW.q_wire[14] ;
 wire \REGF[4].RFW.q_wire[15] ;
 wire \REGF[4].RFW.q_wire[16] ;
 wire \REGF[4].RFW.q_wire[17] ;
 wire \REGF[4].RFW.q_wire[18] ;
 wire \REGF[4].RFW.q_wire[19] ;
 wire \REGF[4].RFW.q_wire[1] ;
 wire \REGF[4].RFW.q_wire[20] ;
 wire \REGF[4].RFW.q_wire[21] ;
 wire \REGF[4].RFW.q_wire[22] ;
 wire \REGF[4].RFW.q_wire[23] ;
 wire \REGF[4].RFW.q_wire[24] ;
 wire \REGF[4].RFW.q_wire[25] ;
 wire \REGF[4].RFW.q_wire[26] ;
 wire \REGF[4].RFW.q_wire[27] ;
 wire \REGF[4].RFW.q_wire[28] ;
 wire \REGF[4].RFW.q_wire[29] ;
 wire \REGF[4].RFW.q_wire[2] ;
 wire \REGF[4].RFW.q_wire[30] ;
 wire \REGF[4].RFW.q_wire[31] ;
 wire \REGF[4].RFW.q_wire[3] ;
 wire \REGF[4].RFW.q_wire[4] ;
 wire \REGF[4].RFW.q_wire[5] ;
 wire \REGF[4].RFW.q_wire[6] ;
 wire \REGF[4].RFW.q_wire[7] ;
 wire \REGF[4].RFW.q_wire[8] ;
 wire \REGF[4].RFW.q_wire[9] ;
 wire \REGF[4].RFW.we_wire ;
 wire \REGF[5].RFW.GCLK[0] ;
 wire \REGF[5].RFW.GCLK[1] ;
 wire \REGF[5].RFW.GCLK[2] ;
 wire \REGF[5].RFW.GCLK[3] ;
 wire \REGF[5].RFW.SEL1_B[0] ;
 wire \REGF[5].RFW.SEL1_B[1] ;
 wire \REGF[5].RFW.SEL1_B[2] ;
 wire \REGF[5].RFW.SEL1_B[3] ;
 wire \REGF[5].RFW.SEL2_B[0] ;
 wire \REGF[5].RFW.SEL2_B[1] ;
 wire \REGF[5].RFW.SEL2_B[2] ;
 wire \REGF[5].RFW.SEL2_B[3] ;
 wire \REGF[5].RFW.q_wire[0] ;
 wire \REGF[5].RFW.q_wire[10] ;
 wire \REGF[5].RFW.q_wire[11] ;
 wire \REGF[5].RFW.q_wire[12] ;
 wire \REGF[5].RFW.q_wire[13] ;
 wire \REGF[5].RFW.q_wire[14] ;
 wire \REGF[5].RFW.q_wire[15] ;
 wire \REGF[5].RFW.q_wire[16] ;
 wire \REGF[5].RFW.q_wire[17] ;
 wire \REGF[5].RFW.q_wire[18] ;
 wire \REGF[5].RFW.q_wire[19] ;
 wire \REGF[5].RFW.q_wire[1] ;
 wire \REGF[5].RFW.q_wire[20] ;
 wire \REGF[5].RFW.q_wire[21] ;
 wire \REGF[5].RFW.q_wire[22] ;
 wire \REGF[5].RFW.q_wire[23] ;
 wire \REGF[5].RFW.q_wire[24] ;
 wire \REGF[5].RFW.q_wire[25] ;
 wire \REGF[5].RFW.q_wire[26] ;
 wire \REGF[5].RFW.q_wire[27] ;
 wire \REGF[5].RFW.q_wire[28] ;
 wire \REGF[5].RFW.q_wire[29] ;
 wire \REGF[5].RFW.q_wire[2] ;
 wire \REGF[5].RFW.q_wire[30] ;
 wire \REGF[5].RFW.q_wire[31] ;
 wire \REGF[5].RFW.q_wire[3] ;
 wire \REGF[5].RFW.q_wire[4] ;
 wire \REGF[5].RFW.q_wire[5] ;
 wire \REGF[5].RFW.q_wire[6] ;
 wire \REGF[5].RFW.q_wire[7] ;
 wire \REGF[5].RFW.q_wire[8] ;
 wire \REGF[5].RFW.q_wire[9] ;
 wire \REGF[5].RFW.we_wire ;
 wire \REGF[6].RFW.GCLK[0] ;
 wire \REGF[6].RFW.GCLK[1] ;
 wire \REGF[6].RFW.GCLK[2] ;
 wire \REGF[6].RFW.GCLK[3] ;
 wire \REGF[6].RFW.SEL1_B[0] ;
 wire \REGF[6].RFW.SEL1_B[1] ;
 wire \REGF[6].RFW.SEL1_B[2] ;
 wire \REGF[6].RFW.SEL1_B[3] ;
 wire \REGF[6].RFW.SEL2_B[0] ;
 wire \REGF[6].RFW.SEL2_B[1] ;
 wire \REGF[6].RFW.SEL2_B[2] ;
 wire \REGF[6].RFW.SEL2_B[3] ;
 wire \REGF[6].RFW.q_wire[0] ;
 wire \REGF[6].RFW.q_wire[10] ;
 wire \REGF[6].RFW.q_wire[11] ;
 wire \REGF[6].RFW.q_wire[12] ;
 wire \REGF[6].RFW.q_wire[13] ;
 wire \REGF[6].RFW.q_wire[14] ;
 wire \REGF[6].RFW.q_wire[15] ;
 wire \REGF[6].RFW.q_wire[16] ;
 wire \REGF[6].RFW.q_wire[17] ;
 wire \REGF[6].RFW.q_wire[18] ;
 wire \REGF[6].RFW.q_wire[19] ;
 wire \REGF[6].RFW.q_wire[1] ;
 wire \REGF[6].RFW.q_wire[20] ;
 wire \REGF[6].RFW.q_wire[21] ;
 wire \REGF[6].RFW.q_wire[22] ;
 wire \REGF[6].RFW.q_wire[23] ;
 wire \REGF[6].RFW.q_wire[24] ;
 wire \REGF[6].RFW.q_wire[25] ;
 wire \REGF[6].RFW.q_wire[26] ;
 wire \REGF[6].RFW.q_wire[27] ;
 wire \REGF[6].RFW.q_wire[28] ;
 wire \REGF[6].RFW.q_wire[29] ;
 wire \REGF[6].RFW.q_wire[2] ;
 wire \REGF[6].RFW.q_wire[30] ;
 wire \REGF[6].RFW.q_wire[31] ;
 wire \REGF[6].RFW.q_wire[3] ;
 wire \REGF[6].RFW.q_wire[4] ;
 wire \REGF[6].RFW.q_wire[5] ;
 wire \REGF[6].RFW.q_wire[6] ;
 wire \REGF[6].RFW.q_wire[7] ;
 wire \REGF[6].RFW.q_wire[8] ;
 wire \REGF[6].RFW.q_wire[9] ;
 wire \REGF[6].RFW.we_wire ;
 wire \REGF[7].RFW.GCLK[0] ;
 wire \REGF[7].RFW.GCLK[1] ;
 wire \REGF[7].RFW.GCLK[2] ;
 wire \REGF[7].RFW.GCLK[3] ;
 wire \REGF[7].RFW.SEL1_B[0] ;
 wire \REGF[7].RFW.SEL1_B[1] ;
 wire \REGF[7].RFW.SEL1_B[2] ;
 wire \REGF[7].RFW.SEL1_B[3] ;
 wire \REGF[7].RFW.SEL2_B[0] ;
 wire \REGF[7].RFW.SEL2_B[1] ;
 wire \REGF[7].RFW.SEL2_B[2] ;
 wire \REGF[7].RFW.SEL2_B[3] ;
 wire \REGF[7].RFW.q_wire[0] ;
 wire \REGF[7].RFW.q_wire[10] ;
 wire \REGF[7].RFW.q_wire[11] ;
 wire \REGF[7].RFW.q_wire[12] ;
 wire \REGF[7].RFW.q_wire[13] ;
 wire \REGF[7].RFW.q_wire[14] ;
 wire \REGF[7].RFW.q_wire[15] ;
 wire \REGF[7].RFW.q_wire[16] ;
 wire \REGF[7].RFW.q_wire[17] ;
 wire \REGF[7].RFW.q_wire[18] ;
 wire \REGF[7].RFW.q_wire[19] ;
 wire \REGF[7].RFW.q_wire[1] ;
 wire \REGF[7].RFW.q_wire[20] ;
 wire \REGF[7].RFW.q_wire[21] ;
 wire \REGF[7].RFW.q_wire[22] ;
 wire \REGF[7].RFW.q_wire[23] ;
 wire \REGF[7].RFW.q_wire[24] ;
 wire \REGF[7].RFW.q_wire[25] ;
 wire \REGF[7].RFW.q_wire[26] ;
 wire \REGF[7].RFW.q_wire[27] ;
 wire \REGF[7].RFW.q_wire[28] ;
 wire \REGF[7].RFW.q_wire[29] ;
 wire \REGF[7].RFW.q_wire[2] ;
 wire \REGF[7].RFW.q_wire[30] ;
 wire \REGF[7].RFW.q_wire[31] ;
 wire \REGF[7].RFW.q_wire[3] ;
 wire \REGF[7].RFW.q_wire[4] ;
 wire \REGF[7].RFW.q_wire[5] ;
 wire \REGF[7].RFW.q_wire[6] ;
 wire \REGF[7].RFW.q_wire[7] ;
 wire \REGF[7].RFW.q_wire[8] ;
 wire \REGF[7].RFW.q_wire[9] ;
 wire \REGF[7].RFW.we_wire ;
 wire \REGF[8].RFW.GCLK[0] ;
 wire \REGF[8].RFW.GCLK[1] ;
 wire \REGF[8].RFW.GCLK[2] ;
 wire \REGF[8].RFW.GCLK[3] ;
 wire \REGF[8].RFW.SEL1_B[0] ;
 wire \REGF[8].RFW.SEL1_B[1] ;
 wire \REGF[8].RFW.SEL1_B[2] ;
 wire \REGF[8].RFW.SEL1_B[3] ;
 wire \REGF[8].RFW.SEL2_B[0] ;
 wire \REGF[8].RFW.SEL2_B[1] ;
 wire \REGF[8].RFW.SEL2_B[2] ;
 wire \REGF[8].RFW.SEL2_B[3] ;
 wire \REGF[8].RFW.q_wire[0] ;
 wire \REGF[8].RFW.q_wire[10] ;
 wire \REGF[8].RFW.q_wire[11] ;
 wire \REGF[8].RFW.q_wire[12] ;
 wire \REGF[8].RFW.q_wire[13] ;
 wire \REGF[8].RFW.q_wire[14] ;
 wire \REGF[8].RFW.q_wire[15] ;
 wire \REGF[8].RFW.q_wire[16] ;
 wire \REGF[8].RFW.q_wire[17] ;
 wire \REGF[8].RFW.q_wire[18] ;
 wire \REGF[8].RFW.q_wire[19] ;
 wire \REGF[8].RFW.q_wire[1] ;
 wire \REGF[8].RFW.q_wire[20] ;
 wire \REGF[8].RFW.q_wire[21] ;
 wire \REGF[8].RFW.q_wire[22] ;
 wire \REGF[8].RFW.q_wire[23] ;
 wire \REGF[8].RFW.q_wire[24] ;
 wire \REGF[8].RFW.q_wire[25] ;
 wire \REGF[8].RFW.q_wire[26] ;
 wire \REGF[8].RFW.q_wire[27] ;
 wire \REGF[8].RFW.q_wire[28] ;
 wire \REGF[8].RFW.q_wire[29] ;
 wire \REGF[8].RFW.q_wire[2] ;
 wire \REGF[8].RFW.q_wire[30] ;
 wire \REGF[8].RFW.q_wire[31] ;
 wire \REGF[8].RFW.q_wire[3] ;
 wire \REGF[8].RFW.q_wire[4] ;
 wire \REGF[8].RFW.q_wire[5] ;
 wire \REGF[8].RFW.q_wire[6] ;
 wire \REGF[8].RFW.q_wire[7] ;
 wire \REGF[8].RFW.q_wire[8] ;
 wire \REGF[8].RFW.q_wire[9] ;
 wire \REGF[8].RFW.we_wire ;
 wire \REGF[9].RFW.GCLK[0] ;
 wire \REGF[9].RFW.GCLK[1] ;
 wire \REGF[9].RFW.GCLK[2] ;
 wire \REGF[9].RFW.GCLK[3] ;
 wire \REGF[9].RFW.SEL1_B[0] ;
 wire \REGF[9].RFW.SEL1_B[1] ;
 wire \REGF[9].RFW.SEL1_B[2] ;
 wire \REGF[9].RFW.SEL1_B[3] ;
 wire \REGF[9].RFW.SEL2_B[0] ;
 wire \REGF[9].RFW.SEL2_B[1] ;
 wire \REGF[9].RFW.SEL2_B[2] ;
 wire \REGF[9].RFW.SEL2_B[3] ;
 wire \REGF[9].RFW.q_wire[0] ;
 wire \REGF[9].RFW.q_wire[10] ;
 wire \REGF[9].RFW.q_wire[11] ;
 wire \REGF[9].RFW.q_wire[12] ;
 wire \REGF[9].RFW.q_wire[13] ;
 wire \REGF[9].RFW.q_wire[14] ;
 wire \REGF[9].RFW.q_wire[15] ;
 wire \REGF[9].RFW.q_wire[16] ;
 wire \REGF[9].RFW.q_wire[17] ;
 wire \REGF[9].RFW.q_wire[18] ;
 wire \REGF[9].RFW.q_wire[19] ;
 wire \REGF[9].RFW.q_wire[1] ;
 wire \REGF[9].RFW.q_wire[20] ;
 wire \REGF[9].RFW.q_wire[21] ;
 wire \REGF[9].RFW.q_wire[22] ;
 wire \REGF[9].RFW.q_wire[23] ;
 wire \REGF[9].RFW.q_wire[24] ;
 wire \REGF[9].RFW.q_wire[25] ;
 wire \REGF[9].RFW.q_wire[26] ;
 wire \REGF[9].RFW.q_wire[27] ;
 wire \REGF[9].RFW.q_wire[28] ;
 wire \REGF[9].RFW.q_wire[29] ;
 wire \REGF[9].RFW.q_wire[2] ;
 wire \REGF[9].RFW.q_wire[30] ;
 wire \REGF[9].RFW.q_wire[31] ;
 wire \REGF[9].RFW.q_wire[3] ;
 wire \REGF[9].RFW.q_wire[4] ;
 wire \REGF[9].RFW.q_wire[5] ;
 wire \REGF[9].RFW.q_wire[6] ;
 wire \REGF[9].RFW.q_wire[7] ;
 wire \REGF[9].RFW.q_wire[8] ;
 wire \REGF[9].RFW.q_wire[9] ;
 wire \REGF[9].RFW.we_wire ;
 wire \genblk1.RFW0.SEL1_B[0] ;
 wire \genblk1.RFW0.SEL1_B[1] ;
 wire \genblk1.RFW0.SEL1_B[2] ;
 wire \genblk1.RFW0.SEL1_B[3] ;
 wire \genblk1.RFW0.SEL2_B[0] ;
 wire \genblk1.RFW0.SEL2_B[1] ;
 wire \genblk1.RFW0.SEL2_B[2] ;
 wire \genblk1.RFW0.SEL2_B[3] ;
 wire \genblk1.RFW0.lo[0] ;
 wire \genblk1.RFW0.lo[1] ;
 wire \genblk1.RFW0.lo[2] ;
 wire \genblk1.RFW0.lo[3] ;
 wire \genblk1.RFW0.lo[4] ;
 wire \genblk1.RFW0.lo[5] ;
 wire \genblk1.RFW0.lo[6] ;
 wire \genblk1.RFW0.lo[7] ;

 sky130_fd_sc_hd__nor3b_2 \DEC0.D.AND0  (.A(RA[3]),
    .B(RA[4]),
    .C_N(\DEC0.D.EN ),
    .Y(\DEC0.D.SEL[0] ));
 sky130_fd_sc_hd__and3b_2 \DEC0.D.AND1  (.A_N(RA[4]),
    .B(RA[3]),
    .C(\DEC0.D.EN ),
    .X(\DEC0.D.SEL[1] ));
 sky130_fd_sc_hd__and3b_2 \DEC0.D.AND2  (.A_N(RA[3]),
    .B(RA[4]),
    .C(\DEC0.D.EN ),
    .X(\DEC0.D.SEL[2] ));
 sky130_fd_sc_hd__and3_2 \DEC0.D.AND3  (.A(RA[4]),
    .B(RA[3]),
    .C(\DEC0.D.EN ),
    .X(\DEC0.D.SEL[3] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D0.ABUF[0]  (.A(RA[0]),
    .X(\DEC0.D0.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D0.ABUF[1]  (.A(RA[1]),
    .X(\DEC0.D0.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D0.ABUF[2]  (.A(RA[2]),
    .X(\DEC0.D0.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC0.D0.AND0  (.A(\DEC0.D0.A_buf[0] ),
    .B(\DEC0.D0.A_buf[1] ),
    .C(\DEC0.D0.A_buf[2] ),
    .D_N(\DEC0.D0.EN_buf ),
    .Y(\DEC0.D0.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D0.AND1  (.A_N(\DEC0.D0.A_buf[2] ),
    .B_N(\DEC0.D0.A_buf[1] ),
    .C(\DEC0.D0.A_buf[0] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D0.AND2  (.A_N(\DEC0.D0.A_buf[2] ),
    .B_N(\DEC0.D0.A_buf[0] ),
    .C(\DEC0.D0.A_buf[1] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D0.AND3  (.A_N(\DEC0.D0.A_buf[2] ),
    .B(\DEC0.D0.A_buf[1] ),
    .C(\DEC0.D0.A_buf[0] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D0.AND4  (.A_N(\DEC0.D0.A_buf[0] ),
    .B_N(\DEC0.D0.A_buf[1] ),
    .C(\DEC0.D0.A_buf[2] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D0.AND5  (.A_N(\DEC0.D0.A_buf[1] ),
    .B(\DEC0.D0.A_buf[0] ),
    .C(\DEC0.D0.A_buf[2] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D0.AND6  (.A_N(\DEC0.D0.A_buf[0] ),
    .B(\DEC0.D0.A_buf[1] ),
    .C(\DEC0.D0.A_buf[2] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC0.D0.AND7  (.A(\DEC0.D0.A_buf[0] ),
    .B(\DEC0.D0.A_buf[1] ),
    .C(\DEC0.D0.A_buf[2] ),
    .D(\DEC0.D0.EN_buf ),
    .X(\DEC0.D0.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D0.ENBUF  (.A(\DEC0.D.SEL[0] ),
    .X(\DEC0.D0.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D1.ABUF[0]  (.A(RA[0]),
    .X(\DEC0.D1.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D1.ABUF[1]  (.A(RA[1]),
    .X(\DEC0.D1.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D1.ABUF[2]  (.A(RA[2]),
    .X(\DEC0.D1.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC0.D1.AND0  (.A(\DEC0.D1.A_buf[0] ),
    .B(\DEC0.D1.A_buf[1] ),
    .C(\DEC0.D1.A_buf[2] ),
    .D_N(\DEC0.D1.EN_buf ),
    .Y(\DEC0.D1.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D1.AND1  (.A_N(\DEC0.D1.A_buf[2] ),
    .B_N(\DEC0.D1.A_buf[1] ),
    .C(\DEC0.D1.A_buf[0] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D1.AND2  (.A_N(\DEC0.D1.A_buf[2] ),
    .B_N(\DEC0.D1.A_buf[0] ),
    .C(\DEC0.D1.A_buf[1] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D1.AND3  (.A_N(\DEC0.D1.A_buf[2] ),
    .B(\DEC0.D1.A_buf[1] ),
    .C(\DEC0.D1.A_buf[0] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D1.AND4  (.A_N(\DEC0.D1.A_buf[0] ),
    .B_N(\DEC0.D1.A_buf[1] ),
    .C(\DEC0.D1.A_buf[2] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D1.AND5  (.A_N(\DEC0.D1.A_buf[1] ),
    .B(\DEC0.D1.A_buf[0] ),
    .C(\DEC0.D1.A_buf[2] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D1.AND6  (.A_N(\DEC0.D1.A_buf[0] ),
    .B(\DEC0.D1.A_buf[1] ),
    .C(\DEC0.D1.A_buf[2] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC0.D1.AND7  (.A(\DEC0.D1.A_buf[0] ),
    .B(\DEC0.D1.A_buf[1] ),
    .C(\DEC0.D1.A_buf[2] ),
    .D(\DEC0.D1.EN_buf ),
    .X(\DEC0.D1.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D1.ENBUF  (.A(\DEC0.D.SEL[1] ),
    .X(\DEC0.D1.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D2.ABUF[0]  (.A(RA[0]),
    .X(\DEC0.D2.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D2.ABUF[1]  (.A(RA[1]),
    .X(\DEC0.D2.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D2.ABUF[2]  (.A(RA[2]),
    .X(\DEC0.D2.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC0.D2.AND0  (.A(\DEC0.D2.A_buf[0] ),
    .B(\DEC0.D2.A_buf[1] ),
    .C(\DEC0.D2.A_buf[2] ),
    .D_N(\DEC0.D2.EN_buf ),
    .Y(\DEC0.D2.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D2.AND1  (.A_N(\DEC0.D2.A_buf[2] ),
    .B_N(\DEC0.D2.A_buf[1] ),
    .C(\DEC0.D2.A_buf[0] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D2.AND2  (.A_N(\DEC0.D2.A_buf[2] ),
    .B_N(\DEC0.D2.A_buf[0] ),
    .C(\DEC0.D2.A_buf[1] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D2.AND3  (.A_N(\DEC0.D2.A_buf[2] ),
    .B(\DEC0.D2.A_buf[1] ),
    .C(\DEC0.D2.A_buf[0] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D2.AND4  (.A_N(\DEC0.D2.A_buf[0] ),
    .B_N(\DEC0.D2.A_buf[1] ),
    .C(\DEC0.D2.A_buf[2] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D2.AND5  (.A_N(\DEC0.D2.A_buf[1] ),
    .B(\DEC0.D2.A_buf[0] ),
    .C(\DEC0.D2.A_buf[2] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D2.AND6  (.A_N(\DEC0.D2.A_buf[0] ),
    .B(\DEC0.D2.A_buf[1] ),
    .C(\DEC0.D2.A_buf[2] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC0.D2.AND7  (.A(\DEC0.D2.A_buf[0] ),
    .B(\DEC0.D2.A_buf[1] ),
    .C(\DEC0.D2.A_buf[2] ),
    .D(\DEC0.D2.EN_buf ),
    .X(\DEC0.D2.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D2.ENBUF  (.A(\DEC0.D.SEL[2] ),
    .X(\DEC0.D2.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D3.ABUF[0]  (.A(RA[0]),
    .X(\DEC0.D3.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D3.ABUF[1]  (.A(RA[1]),
    .X(\DEC0.D3.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D3.ABUF[2]  (.A(RA[2]),
    .X(\DEC0.D3.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC0.D3.AND0  (.A(\DEC0.D3.A_buf[0] ),
    .B(\DEC0.D3.A_buf[1] ),
    .C(\DEC0.D3.A_buf[2] ),
    .D_N(\DEC0.D3.EN_buf ),
    .Y(\DEC0.D3.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D3.AND1  (.A_N(\DEC0.D3.A_buf[2] ),
    .B_N(\DEC0.D3.A_buf[1] ),
    .C(\DEC0.D3.A_buf[0] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D3.AND2  (.A_N(\DEC0.D3.A_buf[2] ),
    .B_N(\DEC0.D3.A_buf[0] ),
    .C(\DEC0.D3.A_buf[1] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D3.AND3  (.A_N(\DEC0.D3.A_buf[2] ),
    .B(\DEC0.D3.A_buf[1] ),
    .C(\DEC0.D3.A_buf[0] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC0.D3.AND4  (.A_N(\DEC0.D3.A_buf[0] ),
    .B_N(\DEC0.D3.A_buf[1] ),
    .C(\DEC0.D3.A_buf[2] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D3.AND5  (.A_N(\DEC0.D3.A_buf[1] ),
    .B(\DEC0.D3.A_buf[0] ),
    .C(\DEC0.D3.A_buf[2] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC0.D3.AND6  (.A_N(\DEC0.D3.A_buf[0] ),
    .B(\DEC0.D3.A_buf[1] ),
    .C(\DEC0.D3.A_buf[2] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC0.D3.AND7  (.A(\DEC0.D3.A_buf[0] ),
    .B(\DEC0.D3.A_buf[1] ),
    .C(\DEC0.D3.A_buf[2] ),
    .D(\DEC0.D3.EN_buf ),
    .X(\DEC0.D3.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC0.D3.ENBUF  (.A(\DEC0.D.SEL[3] ),
    .X(\DEC0.D3.EN_buf ));
 sky130_fd_sc_hd__conb_1 \DEC0.TIE  (.HI(\DEC0.D.EN ));
 sky130_fd_sc_hd__nor3b_2 \DEC1.D.AND0  (.A(RB[3]),
    .B(RB[4]),
    .C_N(\DEC1.D.EN ),
    .Y(\DEC1.D.SEL[0] ));
 sky130_fd_sc_hd__and3b_2 \DEC1.D.AND1  (.A_N(RB[4]),
    .B(RB[3]),
    .C(\DEC1.D.EN ),
    .X(\DEC1.D.SEL[1] ));
 sky130_fd_sc_hd__and3b_2 \DEC1.D.AND2  (.A_N(RB[3]),
    .B(RB[4]),
    .C(\DEC1.D.EN ),
    .X(\DEC1.D.SEL[2] ));
 sky130_fd_sc_hd__and3_2 \DEC1.D.AND3  (.A(RB[4]),
    .B(RB[3]),
    .C(\DEC1.D.EN ),
    .X(\DEC1.D.SEL[3] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D0.ABUF[0]  (.A(RB[0]),
    .X(\DEC1.D0.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D0.ABUF[1]  (.A(RB[1]),
    .X(\DEC1.D0.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D0.ABUF[2]  (.A(RB[2]),
    .X(\DEC1.D0.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC1.D0.AND0  (.A(\DEC1.D0.A_buf[0] ),
    .B(\DEC1.D0.A_buf[1] ),
    .C(\DEC1.D0.A_buf[2] ),
    .D_N(\DEC1.D0.EN_buf ),
    .Y(\DEC1.D0.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D0.AND1  (.A_N(\DEC1.D0.A_buf[2] ),
    .B_N(\DEC1.D0.A_buf[1] ),
    .C(\DEC1.D0.A_buf[0] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D0.AND2  (.A_N(\DEC1.D0.A_buf[2] ),
    .B_N(\DEC1.D0.A_buf[0] ),
    .C(\DEC1.D0.A_buf[1] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D0.AND3  (.A_N(\DEC1.D0.A_buf[2] ),
    .B(\DEC1.D0.A_buf[1] ),
    .C(\DEC1.D0.A_buf[0] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D0.AND4  (.A_N(\DEC1.D0.A_buf[0] ),
    .B_N(\DEC1.D0.A_buf[1] ),
    .C(\DEC1.D0.A_buf[2] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D0.AND5  (.A_N(\DEC1.D0.A_buf[1] ),
    .B(\DEC1.D0.A_buf[0] ),
    .C(\DEC1.D0.A_buf[2] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D0.AND6  (.A_N(\DEC1.D0.A_buf[0] ),
    .B(\DEC1.D0.A_buf[1] ),
    .C(\DEC1.D0.A_buf[2] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC1.D0.AND7  (.A(\DEC1.D0.A_buf[0] ),
    .B(\DEC1.D0.A_buf[1] ),
    .C(\DEC1.D0.A_buf[2] ),
    .D(\DEC1.D0.EN_buf ),
    .X(\DEC1.D0.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D0.ENBUF  (.A(\DEC1.D.SEL[0] ),
    .X(\DEC1.D0.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D1.ABUF[0]  (.A(RB[0]),
    .X(\DEC1.D1.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D1.ABUF[1]  (.A(RB[1]),
    .X(\DEC1.D1.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D1.ABUF[2]  (.A(RB[2]),
    .X(\DEC1.D1.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC1.D1.AND0  (.A(\DEC1.D1.A_buf[0] ),
    .B(\DEC1.D1.A_buf[1] ),
    .C(\DEC1.D1.A_buf[2] ),
    .D_N(\DEC1.D1.EN_buf ),
    .Y(\DEC1.D1.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D1.AND1  (.A_N(\DEC1.D1.A_buf[2] ),
    .B_N(\DEC1.D1.A_buf[1] ),
    .C(\DEC1.D1.A_buf[0] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D1.AND2  (.A_N(\DEC1.D1.A_buf[2] ),
    .B_N(\DEC1.D1.A_buf[0] ),
    .C(\DEC1.D1.A_buf[1] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D1.AND3  (.A_N(\DEC1.D1.A_buf[2] ),
    .B(\DEC1.D1.A_buf[1] ),
    .C(\DEC1.D1.A_buf[0] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D1.AND4  (.A_N(\DEC1.D1.A_buf[0] ),
    .B_N(\DEC1.D1.A_buf[1] ),
    .C(\DEC1.D1.A_buf[2] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D1.AND5  (.A_N(\DEC1.D1.A_buf[1] ),
    .B(\DEC1.D1.A_buf[0] ),
    .C(\DEC1.D1.A_buf[2] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D1.AND6  (.A_N(\DEC1.D1.A_buf[0] ),
    .B(\DEC1.D1.A_buf[1] ),
    .C(\DEC1.D1.A_buf[2] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC1.D1.AND7  (.A(\DEC1.D1.A_buf[0] ),
    .B(\DEC1.D1.A_buf[1] ),
    .C(\DEC1.D1.A_buf[2] ),
    .D(\DEC1.D1.EN_buf ),
    .X(\DEC1.D1.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D1.ENBUF  (.A(\DEC1.D.SEL[1] ),
    .X(\DEC1.D1.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D2.ABUF[0]  (.A(RB[0]),
    .X(\DEC1.D2.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D2.ABUF[1]  (.A(RB[1]),
    .X(\DEC1.D2.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D2.ABUF[2]  (.A(RB[2]),
    .X(\DEC1.D2.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC1.D2.AND0  (.A(\DEC1.D2.A_buf[0] ),
    .B(\DEC1.D2.A_buf[1] ),
    .C(\DEC1.D2.A_buf[2] ),
    .D_N(\DEC1.D2.EN_buf ),
    .Y(\DEC1.D2.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D2.AND1  (.A_N(\DEC1.D2.A_buf[2] ),
    .B_N(\DEC1.D2.A_buf[1] ),
    .C(\DEC1.D2.A_buf[0] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D2.AND2  (.A_N(\DEC1.D2.A_buf[2] ),
    .B_N(\DEC1.D2.A_buf[0] ),
    .C(\DEC1.D2.A_buf[1] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D2.AND3  (.A_N(\DEC1.D2.A_buf[2] ),
    .B(\DEC1.D2.A_buf[1] ),
    .C(\DEC1.D2.A_buf[0] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D2.AND4  (.A_N(\DEC1.D2.A_buf[0] ),
    .B_N(\DEC1.D2.A_buf[1] ),
    .C(\DEC1.D2.A_buf[2] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D2.AND5  (.A_N(\DEC1.D2.A_buf[1] ),
    .B(\DEC1.D2.A_buf[0] ),
    .C(\DEC1.D2.A_buf[2] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D2.AND6  (.A_N(\DEC1.D2.A_buf[0] ),
    .B(\DEC1.D2.A_buf[1] ),
    .C(\DEC1.D2.A_buf[2] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC1.D2.AND7  (.A(\DEC1.D2.A_buf[0] ),
    .B(\DEC1.D2.A_buf[1] ),
    .C(\DEC1.D2.A_buf[2] ),
    .D(\DEC1.D2.EN_buf ),
    .X(\DEC1.D2.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D2.ENBUF  (.A(\DEC1.D.SEL[2] ),
    .X(\DEC1.D2.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D3.ABUF[0]  (.A(RB[0]),
    .X(\DEC1.D3.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D3.ABUF[1]  (.A(RB[1]),
    .X(\DEC1.D3.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D3.ABUF[2]  (.A(RB[2]),
    .X(\DEC1.D3.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC1.D3.AND0  (.A(\DEC1.D3.A_buf[0] ),
    .B(\DEC1.D3.A_buf[1] ),
    .C(\DEC1.D3.A_buf[2] ),
    .D_N(\DEC1.D3.EN_buf ),
    .Y(\DEC1.D3.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D3.AND1  (.A_N(\DEC1.D3.A_buf[2] ),
    .B_N(\DEC1.D3.A_buf[1] ),
    .C(\DEC1.D3.A_buf[0] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D3.AND2  (.A_N(\DEC1.D3.A_buf[2] ),
    .B_N(\DEC1.D3.A_buf[0] ),
    .C(\DEC1.D3.A_buf[1] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D3.AND3  (.A_N(\DEC1.D3.A_buf[2] ),
    .B(\DEC1.D3.A_buf[1] ),
    .C(\DEC1.D3.A_buf[0] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC1.D3.AND4  (.A_N(\DEC1.D3.A_buf[0] ),
    .B_N(\DEC1.D3.A_buf[1] ),
    .C(\DEC1.D3.A_buf[2] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D3.AND5  (.A_N(\DEC1.D3.A_buf[1] ),
    .B(\DEC1.D3.A_buf[0] ),
    .C(\DEC1.D3.A_buf[2] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC1.D3.AND6  (.A_N(\DEC1.D3.A_buf[0] ),
    .B(\DEC1.D3.A_buf[1] ),
    .C(\DEC1.D3.A_buf[2] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC1.D3.AND7  (.A(\DEC1.D3.A_buf[0] ),
    .B(\DEC1.D3.A_buf[1] ),
    .C(\DEC1.D3.A_buf[2] ),
    .D(\DEC1.D3.EN_buf ),
    .X(\DEC1.D3.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC1.D3.ENBUF  (.A(\DEC1.D.SEL[3] ),
    .X(\DEC1.D3.EN_buf ));
 sky130_fd_sc_hd__conb_1 \DEC1.TIE  (.HI(\DEC1.D.EN ));
 sky130_fd_sc_hd__nor3b_2 \DEC2.D.AND0  (.A(RW[3]),
    .B(RW[4]),
    .C_N(\DEC2.D.EN ),
    .Y(\DEC2.D.SEL[0] ));
 sky130_fd_sc_hd__and3b_2 \DEC2.D.AND1  (.A_N(RW[4]),
    .B(RW[3]),
    .C(\DEC2.D.EN ),
    .X(\DEC2.D.SEL[1] ));
 sky130_fd_sc_hd__and3b_2 \DEC2.D.AND2  (.A_N(RW[3]),
    .B(RW[4]),
    .C(\DEC2.D.EN ),
    .X(\DEC2.D.SEL[2] ));
 sky130_fd_sc_hd__and3_2 \DEC2.D.AND3  (.A(RW[4]),
    .B(RW[3]),
    .C(\DEC2.D.EN ),
    .X(\DEC2.D.SEL[3] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D0.ABUF[0]  (.A(RW[0]),
    .X(\DEC2.D0.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D0.ABUF[1]  (.A(RW[1]),
    .X(\DEC2.D0.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D0.ABUF[2]  (.A(RW[2]),
    .X(\DEC2.D0.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC2.D0.AND0  (.A(\DEC2.D0.A_buf[0] ),
    .B(\DEC2.D0.A_buf[1] ),
    .C(\DEC2.D0.A_buf[2] ),
    .D_N(\DEC2.D0.EN_buf ),
    .Y(\DEC2.D0.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D0.AND1  (.A_N(\DEC2.D0.A_buf[2] ),
    .B_N(\DEC2.D0.A_buf[1] ),
    .C(\DEC2.D0.A_buf[0] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D0.AND2  (.A_N(\DEC2.D0.A_buf[2] ),
    .B_N(\DEC2.D0.A_buf[0] ),
    .C(\DEC2.D0.A_buf[1] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D0.AND3  (.A_N(\DEC2.D0.A_buf[2] ),
    .B(\DEC2.D0.A_buf[1] ),
    .C(\DEC2.D0.A_buf[0] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D0.AND4  (.A_N(\DEC2.D0.A_buf[0] ),
    .B_N(\DEC2.D0.A_buf[1] ),
    .C(\DEC2.D0.A_buf[2] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D0.AND5  (.A_N(\DEC2.D0.A_buf[1] ),
    .B(\DEC2.D0.A_buf[0] ),
    .C(\DEC2.D0.A_buf[2] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D0.AND6  (.A_N(\DEC2.D0.A_buf[0] ),
    .B(\DEC2.D0.A_buf[1] ),
    .C(\DEC2.D0.A_buf[2] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC2.D0.AND7  (.A(\DEC2.D0.A_buf[0] ),
    .B(\DEC2.D0.A_buf[1] ),
    .C(\DEC2.D0.A_buf[2] ),
    .D(\DEC2.D0.EN_buf ),
    .X(\DEC2.D0.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D0.ENBUF  (.A(\DEC2.D.SEL[0] ),
    .X(\DEC2.D0.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D1.ABUF[0]  (.A(RW[0]),
    .X(\DEC2.D1.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D1.ABUF[1]  (.A(RW[1]),
    .X(\DEC2.D1.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D1.ABUF[2]  (.A(RW[2]),
    .X(\DEC2.D1.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC2.D1.AND0  (.A(\DEC2.D1.A_buf[0] ),
    .B(\DEC2.D1.A_buf[1] ),
    .C(\DEC2.D1.A_buf[2] ),
    .D_N(\DEC2.D1.EN_buf ),
    .Y(\DEC2.D1.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D1.AND1  (.A_N(\DEC2.D1.A_buf[2] ),
    .B_N(\DEC2.D1.A_buf[1] ),
    .C(\DEC2.D1.A_buf[0] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D1.AND2  (.A_N(\DEC2.D1.A_buf[2] ),
    .B_N(\DEC2.D1.A_buf[0] ),
    .C(\DEC2.D1.A_buf[1] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D1.AND3  (.A_N(\DEC2.D1.A_buf[2] ),
    .B(\DEC2.D1.A_buf[1] ),
    .C(\DEC2.D1.A_buf[0] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D1.AND4  (.A_N(\DEC2.D1.A_buf[0] ),
    .B_N(\DEC2.D1.A_buf[1] ),
    .C(\DEC2.D1.A_buf[2] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D1.AND5  (.A_N(\DEC2.D1.A_buf[1] ),
    .B(\DEC2.D1.A_buf[0] ),
    .C(\DEC2.D1.A_buf[2] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D1.AND6  (.A_N(\DEC2.D1.A_buf[0] ),
    .B(\DEC2.D1.A_buf[1] ),
    .C(\DEC2.D1.A_buf[2] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC2.D1.AND7  (.A(\DEC2.D1.A_buf[0] ),
    .B(\DEC2.D1.A_buf[1] ),
    .C(\DEC2.D1.A_buf[2] ),
    .D(\DEC2.D1.EN_buf ),
    .X(\DEC2.D1.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D1.ENBUF  (.A(\DEC2.D.SEL[1] ),
    .X(\DEC2.D1.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D2.ABUF[0]  (.A(RW[0]),
    .X(\DEC2.D2.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D2.ABUF[1]  (.A(RW[1]),
    .X(\DEC2.D2.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D2.ABUF[2]  (.A(RW[2]),
    .X(\DEC2.D2.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC2.D2.AND0  (.A(\DEC2.D2.A_buf[0] ),
    .B(\DEC2.D2.A_buf[1] ),
    .C(\DEC2.D2.A_buf[2] ),
    .D_N(\DEC2.D2.EN_buf ),
    .Y(\DEC2.D2.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D2.AND1  (.A_N(\DEC2.D2.A_buf[2] ),
    .B_N(\DEC2.D2.A_buf[1] ),
    .C(\DEC2.D2.A_buf[0] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D2.AND2  (.A_N(\DEC2.D2.A_buf[2] ),
    .B_N(\DEC2.D2.A_buf[0] ),
    .C(\DEC2.D2.A_buf[1] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D2.AND3  (.A_N(\DEC2.D2.A_buf[2] ),
    .B(\DEC2.D2.A_buf[1] ),
    .C(\DEC2.D2.A_buf[0] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D2.AND4  (.A_N(\DEC2.D2.A_buf[0] ),
    .B_N(\DEC2.D2.A_buf[1] ),
    .C(\DEC2.D2.A_buf[2] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D2.AND5  (.A_N(\DEC2.D2.A_buf[1] ),
    .B(\DEC2.D2.A_buf[0] ),
    .C(\DEC2.D2.A_buf[2] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D2.AND6  (.A_N(\DEC2.D2.A_buf[0] ),
    .B(\DEC2.D2.A_buf[1] ),
    .C(\DEC2.D2.A_buf[2] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC2.D2.AND7  (.A(\DEC2.D2.A_buf[0] ),
    .B(\DEC2.D2.A_buf[1] ),
    .C(\DEC2.D2.A_buf[2] ),
    .D(\DEC2.D2.EN_buf ),
    .X(\DEC2.D2.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D2.ENBUF  (.A(\DEC2.D.SEL[2] ),
    .X(\DEC2.D2.EN_buf ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D3.ABUF[0]  (.A(RW[0]),
    .X(\DEC2.D3.A_buf[0] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D3.ABUF[1]  (.A(RW[1]),
    .X(\DEC2.D3.A_buf[1] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D3.ABUF[2]  (.A(RW[2]),
    .X(\DEC2.D3.A_buf[2] ));
 sky130_fd_sc_hd__nor4b_2 \DEC2.D3.AND0  (.A(\DEC2.D3.A_buf[0] ),
    .B(\DEC2.D3.A_buf[1] ),
    .C(\DEC2.D3.A_buf[2] ),
    .D_N(\DEC2.D3.EN_buf ),
    .Y(\DEC2.D3.SEL[0] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D3.AND1  (.A_N(\DEC2.D3.A_buf[2] ),
    .B_N(\DEC2.D3.A_buf[1] ),
    .C(\DEC2.D3.A_buf[0] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[1] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D3.AND2  (.A_N(\DEC2.D3.A_buf[2] ),
    .B_N(\DEC2.D3.A_buf[0] ),
    .C(\DEC2.D3.A_buf[1] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[2] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D3.AND3  (.A_N(\DEC2.D3.A_buf[2] ),
    .B(\DEC2.D3.A_buf[1] ),
    .C(\DEC2.D3.A_buf[0] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[3] ));
 sky130_fd_sc_hd__and4bb_2 \DEC2.D3.AND4  (.A_N(\DEC2.D3.A_buf[0] ),
    .B_N(\DEC2.D3.A_buf[1] ),
    .C(\DEC2.D3.A_buf[2] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[4] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D3.AND5  (.A_N(\DEC2.D3.A_buf[1] ),
    .B(\DEC2.D3.A_buf[0] ),
    .C(\DEC2.D3.A_buf[2] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[5] ));
 sky130_fd_sc_hd__and4b_2 \DEC2.D3.AND6  (.A_N(\DEC2.D3.A_buf[0] ),
    .B(\DEC2.D3.A_buf[1] ),
    .C(\DEC2.D3.A_buf[2] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[6] ));
 sky130_fd_sc_hd__and4_2 \DEC2.D3.AND7  (.A(\DEC2.D3.A_buf[0] ),
    .B(\DEC2.D3.A_buf[1] ),
    .C(\DEC2.D3.A_buf[2] ),
    .D(\DEC2.D3.EN_buf ),
    .X(\DEC2.D3.SEL[7] ));
 sky130_fd_sc_hd__clkbuf_2 \DEC2.D3.ENBUF  (.A(\DEC2.D.SEL[3] ),
    .X(\DEC2.D3.EN_buf ));
 sky130_fd_sc_hd__conb_1 \DEC2.TIE  (.HI(\DEC2.D.EN ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[0].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[10].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[0].OBUF1  (.A(\REGF[10].RFW.q_wire[0] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[0].OBUF2  (.A(\REGF[10].RFW.q_wire[0] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[10].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[10].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[10].OBUF1  (.A(\REGF[10].RFW.q_wire[10] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[10].OBUF2  (.A(\REGF[10].RFW.q_wire[10] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[11].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[10].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[11].OBUF1  (.A(\REGF[10].RFW.q_wire[11] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[11].OBUF2  (.A(\REGF[10].RFW.q_wire[11] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[12].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[10].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[12].OBUF1  (.A(\REGF[10].RFW.q_wire[12] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[12].OBUF2  (.A(\REGF[10].RFW.q_wire[12] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[13].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[10].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[13].OBUF1  (.A(\REGF[10].RFW.q_wire[13] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[13].OBUF2  (.A(\REGF[10].RFW.q_wire[13] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[14].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[10].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[14].OBUF1  (.A(\REGF[10].RFW.q_wire[14] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[14].OBUF2  (.A(\REGF[10].RFW.q_wire[14] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[15].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[10].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[15].OBUF1  (.A(\REGF[10].RFW.q_wire[15] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[15].OBUF2  (.A(\REGF[10].RFW.q_wire[15] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[16].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[10].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[16].OBUF1  (.A(\REGF[10].RFW.q_wire[16] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[16].OBUF2  (.A(\REGF[10].RFW.q_wire[16] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[17].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[10].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[17].OBUF1  (.A(\REGF[10].RFW.q_wire[17] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[17].OBUF2  (.A(\REGF[10].RFW.q_wire[17] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[18].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[10].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[18].OBUF1  (.A(\REGF[10].RFW.q_wire[18] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[18].OBUF2  (.A(\REGF[10].RFW.q_wire[18] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[19].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[10].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[19].OBUF1  (.A(\REGF[10].RFW.q_wire[19] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[19].OBUF2  (.A(\REGF[10].RFW.q_wire[19] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[1].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[10].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[1].OBUF1  (.A(\REGF[10].RFW.q_wire[1] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[1].OBUF2  (.A(\REGF[10].RFW.q_wire[1] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[20].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[10].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[20].OBUF1  (.A(\REGF[10].RFW.q_wire[20] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[20].OBUF2  (.A(\REGF[10].RFW.q_wire[20] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[21].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[10].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[21].OBUF1  (.A(\REGF[10].RFW.q_wire[21] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[21].OBUF2  (.A(\REGF[10].RFW.q_wire[21] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[22].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[10].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[22].OBUF1  (.A(\REGF[10].RFW.q_wire[22] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[22].OBUF2  (.A(\REGF[10].RFW.q_wire[22] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[23].FF  (.CLK(\REGF[10].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[10].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[23].OBUF1  (.A(\REGF[10].RFW.q_wire[23] ),
    .TE_B(\REGF[10].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[23].OBUF2  (.A(\REGF[10].RFW.q_wire[23] ),
    .TE_B(\REGF[10].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[24].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[10].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[24].OBUF1  (.A(\REGF[10].RFW.q_wire[24] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[24].OBUF2  (.A(\REGF[10].RFW.q_wire[24] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[25].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[10].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[25].OBUF1  (.A(\REGF[10].RFW.q_wire[25] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[25].OBUF2  (.A(\REGF[10].RFW.q_wire[25] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[26].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[10].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[26].OBUF1  (.A(\REGF[10].RFW.q_wire[26] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[26].OBUF2  (.A(\REGF[10].RFW.q_wire[26] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[27].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[10].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[27].OBUF1  (.A(\REGF[10].RFW.q_wire[27] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[27].OBUF2  (.A(\REGF[10].RFW.q_wire[27] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[28].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[10].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[28].OBUF1  (.A(\REGF[10].RFW.q_wire[28] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[28].OBUF2  (.A(\REGF[10].RFW.q_wire[28] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[29].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[10].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[29].OBUF1  (.A(\REGF[10].RFW.q_wire[29] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[29].OBUF2  (.A(\REGF[10].RFW.q_wire[29] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[2].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[10].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[2].OBUF1  (.A(\REGF[10].RFW.q_wire[2] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[2].OBUF2  (.A(\REGF[10].RFW.q_wire[2] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[30].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[10].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[30].OBUF1  (.A(\REGF[10].RFW.q_wire[30] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[30].OBUF2  (.A(\REGF[10].RFW.q_wire[30] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[31].FF  (.CLK(\REGF[10].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[10].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[31].OBUF1  (.A(\REGF[10].RFW.q_wire[31] ),
    .TE_B(\REGF[10].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[31].OBUF2  (.A(\REGF[10].RFW.q_wire[31] ),
    .TE_B(\REGF[10].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[3].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[10].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[3].OBUF1  (.A(\REGF[10].RFW.q_wire[3] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[3].OBUF2  (.A(\REGF[10].RFW.q_wire[3] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[4].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[10].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[4].OBUF1  (.A(\REGF[10].RFW.q_wire[4] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[4].OBUF2  (.A(\REGF[10].RFW.q_wire[4] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[5].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[10].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[5].OBUF1  (.A(\REGF[10].RFW.q_wire[5] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[5].OBUF2  (.A(\REGF[10].RFW.q_wire[5] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[6].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[10].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[6].OBUF1  (.A(\REGF[10].RFW.q_wire[6] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[6].OBUF2  (.A(\REGF[10].RFW.q_wire[6] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[7].FF  (.CLK(\REGF[10].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[10].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[7].OBUF1  (.A(\REGF[10].RFW.q_wire[7] ),
    .TE_B(\REGF[10].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[7].OBUF2  (.A(\REGF[10].RFW.q_wire[7] ),
    .TE_B(\REGF[10].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[8].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[10].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[8].OBUF1  (.A(\REGF[10].RFW.q_wire[8] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[8].OBUF2  (.A(\REGF[10].RFW.q_wire[8] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[10].RFW.BIT[9].FF  (.CLK(\REGF[10].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[10].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[9].OBUF1  (.A(\REGF[10].RFW.q_wire[9] ),
    .TE_B(\REGF[10].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[10].RFW.BIT[9].OBUF2  (.A(\REGF[10].RFW.q_wire[9] ),
    .TE_B(\REGF[10].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[10].RFW.CGAND  (.A(\DEC2.D1.SEL[2] ),
    .B(WE),
    .X(\REGF[10].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[10].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[10].RFW.we_wire ),
    .GCLK(\REGF[10].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[10].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[10].RFW.we_wire ),
    .GCLK(\REGF[10].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[10].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[10].RFW.we_wire ),
    .GCLK(\REGF[10].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[10].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[10].RFW.we_wire ),
    .GCLK(\REGF[10].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV1[0]  (.A(\DEC0.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV1[1]  (.A(\DEC0.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV1[2]  (.A(\DEC0.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV1[3]  (.A(\DEC0.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV2[0]  (.A(\DEC1.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV2[1]  (.A(\DEC1.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV2[2]  (.A(\DEC1.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[10].RFW.INV2[3]  (.A(\DEC1.D1.SEL[2] ),
    .Y(\REGF[10].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[0].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[11].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[0].OBUF1  (.A(\REGF[11].RFW.q_wire[0] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[0].OBUF2  (.A(\REGF[11].RFW.q_wire[0] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[10].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[11].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[10].OBUF1  (.A(\REGF[11].RFW.q_wire[10] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[10].OBUF2  (.A(\REGF[11].RFW.q_wire[10] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[11].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[11].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[11].OBUF1  (.A(\REGF[11].RFW.q_wire[11] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[11].OBUF2  (.A(\REGF[11].RFW.q_wire[11] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[12].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[11].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[12].OBUF1  (.A(\REGF[11].RFW.q_wire[12] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[12].OBUF2  (.A(\REGF[11].RFW.q_wire[12] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[13].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[11].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[13].OBUF1  (.A(\REGF[11].RFW.q_wire[13] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[13].OBUF2  (.A(\REGF[11].RFW.q_wire[13] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[14].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[11].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[14].OBUF1  (.A(\REGF[11].RFW.q_wire[14] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[14].OBUF2  (.A(\REGF[11].RFW.q_wire[14] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[15].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[11].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[15].OBUF1  (.A(\REGF[11].RFW.q_wire[15] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[15].OBUF2  (.A(\REGF[11].RFW.q_wire[15] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[16].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[11].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[16].OBUF1  (.A(\REGF[11].RFW.q_wire[16] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[16].OBUF2  (.A(\REGF[11].RFW.q_wire[16] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[17].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[11].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[17].OBUF1  (.A(\REGF[11].RFW.q_wire[17] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[17].OBUF2  (.A(\REGF[11].RFW.q_wire[17] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[18].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[11].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[18].OBUF1  (.A(\REGF[11].RFW.q_wire[18] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[18].OBUF2  (.A(\REGF[11].RFW.q_wire[18] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[19].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[11].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[19].OBUF1  (.A(\REGF[11].RFW.q_wire[19] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[19].OBUF2  (.A(\REGF[11].RFW.q_wire[19] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[1].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[11].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[1].OBUF1  (.A(\REGF[11].RFW.q_wire[1] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[1].OBUF2  (.A(\REGF[11].RFW.q_wire[1] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[20].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[11].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[20].OBUF1  (.A(\REGF[11].RFW.q_wire[20] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[20].OBUF2  (.A(\REGF[11].RFW.q_wire[20] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[21].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[11].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[21].OBUF1  (.A(\REGF[11].RFW.q_wire[21] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[21].OBUF2  (.A(\REGF[11].RFW.q_wire[21] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[22].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[11].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[22].OBUF1  (.A(\REGF[11].RFW.q_wire[22] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[22].OBUF2  (.A(\REGF[11].RFW.q_wire[22] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[23].FF  (.CLK(\REGF[11].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[11].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[23].OBUF1  (.A(\REGF[11].RFW.q_wire[23] ),
    .TE_B(\REGF[11].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[23].OBUF2  (.A(\REGF[11].RFW.q_wire[23] ),
    .TE_B(\REGF[11].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[24].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[11].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[24].OBUF1  (.A(\REGF[11].RFW.q_wire[24] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[24].OBUF2  (.A(\REGF[11].RFW.q_wire[24] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[25].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[11].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[25].OBUF1  (.A(\REGF[11].RFW.q_wire[25] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[25].OBUF2  (.A(\REGF[11].RFW.q_wire[25] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[26].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[11].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[26].OBUF1  (.A(\REGF[11].RFW.q_wire[26] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[26].OBUF2  (.A(\REGF[11].RFW.q_wire[26] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[27].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[11].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[27].OBUF1  (.A(\REGF[11].RFW.q_wire[27] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[27].OBUF2  (.A(\REGF[11].RFW.q_wire[27] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[28].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[11].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[28].OBUF1  (.A(\REGF[11].RFW.q_wire[28] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[28].OBUF2  (.A(\REGF[11].RFW.q_wire[28] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[29].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[11].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[29].OBUF1  (.A(\REGF[11].RFW.q_wire[29] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[29].OBUF2  (.A(\REGF[11].RFW.q_wire[29] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[2].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[11].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[2].OBUF1  (.A(\REGF[11].RFW.q_wire[2] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[2].OBUF2  (.A(\REGF[11].RFW.q_wire[2] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[30].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[11].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[30].OBUF1  (.A(\REGF[11].RFW.q_wire[30] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[30].OBUF2  (.A(\REGF[11].RFW.q_wire[30] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[31].FF  (.CLK(\REGF[11].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[11].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[31].OBUF1  (.A(\REGF[11].RFW.q_wire[31] ),
    .TE_B(\REGF[11].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[31].OBUF2  (.A(\REGF[11].RFW.q_wire[31] ),
    .TE_B(\REGF[11].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[3].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[11].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[3].OBUF1  (.A(\REGF[11].RFW.q_wire[3] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[3].OBUF2  (.A(\REGF[11].RFW.q_wire[3] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[4].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[11].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[4].OBUF1  (.A(\REGF[11].RFW.q_wire[4] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[4].OBUF2  (.A(\REGF[11].RFW.q_wire[4] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[5].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[11].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[5].OBUF1  (.A(\REGF[11].RFW.q_wire[5] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[5].OBUF2  (.A(\REGF[11].RFW.q_wire[5] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[6].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[11].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[6].OBUF1  (.A(\REGF[11].RFW.q_wire[6] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[6].OBUF2  (.A(\REGF[11].RFW.q_wire[6] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[7].FF  (.CLK(\REGF[11].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[11].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[7].OBUF1  (.A(\REGF[11].RFW.q_wire[7] ),
    .TE_B(\REGF[11].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[7].OBUF2  (.A(\REGF[11].RFW.q_wire[7] ),
    .TE_B(\REGF[11].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[8].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[11].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[8].OBUF1  (.A(\REGF[11].RFW.q_wire[8] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[8].OBUF2  (.A(\REGF[11].RFW.q_wire[8] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[11].RFW.BIT[9].FF  (.CLK(\REGF[11].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[11].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[9].OBUF1  (.A(\REGF[11].RFW.q_wire[9] ),
    .TE_B(\REGF[11].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[11].RFW.BIT[9].OBUF2  (.A(\REGF[11].RFW.q_wire[9] ),
    .TE_B(\REGF[11].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[11].RFW.CGAND  (.A(\DEC2.D1.SEL[3] ),
    .B(WE),
    .X(\REGF[11].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[11].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[11].RFW.we_wire ),
    .GCLK(\REGF[11].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[11].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[11].RFW.we_wire ),
    .GCLK(\REGF[11].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[11].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[11].RFW.we_wire ),
    .GCLK(\REGF[11].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[11].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[11].RFW.we_wire ),
    .GCLK(\REGF[11].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV1[0]  (.A(\DEC0.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV1[1]  (.A(\DEC0.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV1[2]  (.A(\DEC0.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV1[3]  (.A(\DEC0.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV2[0]  (.A(\DEC1.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV2[1]  (.A(\DEC1.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV2[2]  (.A(\DEC1.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[11].RFW.INV2[3]  (.A(\DEC1.D1.SEL[3] ),
    .Y(\REGF[11].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[0].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[12].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[0].OBUF1  (.A(\REGF[12].RFW.q_wire[0] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[0].OBUF2  (.A(\REGF[12].RFW.q_wire[0] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[10].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[12].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[10].OBUF1  (.A(\REGF[12].RFW.q_wire[10] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[10].OBUF2  (.A(\REGF[12].RFW.q_wire[10] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[11].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[12].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[11].OBUF1  (.A(\REGF[12].RFW.q_wire[11] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[11].OBUF2  (.A(\REGF[12].RFW.q_wire[11] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[12].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[12].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[12].OBUF1  (.A(\REGF[12].RFW.q_wire[12] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[12].OBUF2  (.A(\REGF[12].RFW.q_wire[12] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[13].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[12].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[13].OBUF1  (.A(\REGF[12].RFW.q_wire[13] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[13].OBUF2  (.A(\REGF[12].RFW.q_wire[13] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[14].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[12].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[14].OBUF1  (.A(\REGF[12].RFW.q_wire[14] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[14].OBUF2  (.A(\REGF[12].RFW.q_wire[14] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[15].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[12].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[15].OBUF1  (.A(\REGF[12].RFW.q_wire[15] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[15].OBUF2  (.A(\REGF[12].RFW.q_wire[15] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[16].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[12].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[16].OBUF1  (.A(\REGF[12].RFW.q_wire[16] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[16].OBUF2  (.A(\REGF[12].RFW.q_wire[16] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[17].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[12].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[17].OBUF1  (.A(\REGF[12].RFW.q_wire[17] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[17].OBUF2  (.A(\REGF[12].RFW.q_wire[17] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[18].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[12].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[18].OBUF1  (.A(\REGF[12].RFW.q_wire[18] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[18].OBUF2  (.A(\REGF[12].RFW.q_wire[18] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[19].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[12].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[19].OBUF1  (.A(\REGF[12].RFW.q_wire[19] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[19].OBUF2  (.A(\REGF[12].RFW.q_wire[19] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[1].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[12].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[1].OBUF1  (.A(\REGF[12].RFW.q_wire[1] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[1].OBUF2  (.A(\REGF[12].RFW.q_wire[1] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[20].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[12].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[20].OBUF1  (.A(\REGF[12].RFW.q_wire[20] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[20].OBUF2  (.A(\REGF[12].RFW.q_wire[20] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[21].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[12].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[21].OBUF1  (.A(\REGF[12].RFW.q_wire[21] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[21].OBUF2  (.A(\REGF[12].RFW.q_wire[21] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[22].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[12].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[22].OBUF1  (.A(\REGF[12].RFW.q_wire[22] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[22].OBUF2  (.A(\REGF[12].RFW.q_wire[22] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[23].FF  (.CLK(\REGF[12].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[12].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[23].OBUF1  (.A(\REGF[12].RFW.q_wire[23] ),
    .TE_B(\REGF[12].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[23].OBUF2  (.A(\REGF[12].RFW.q_wire[23] ),
    .TE_B(\REGF[12].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[24].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[12].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[24].OBUF1  (.A(\REGF[12].RFW.q_wire[24] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[24].OBUF2  (.A(\REGF[12].RFW.q_wire[24] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[25].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[12].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[25].OBUF1  (.A(\REGF[12].RFW.q_wire[25] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[25].OBUF2  (.A(\REGF[12].RFW.q_wire[25] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[26].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[12].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[26].OBUF1  (.A(\REGF[12].RFW.q_wire[26] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[26].OBUF2  (.A(\REGF[12].RFW.q_wire[26] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[27].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[12].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[27].OBUF1  (.A(\REGF[12].RFW.q_wire[27] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[27].OBUF2  (.A(\REGF[12].RFW.q_wire[27] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[28].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[12].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[28].OBUF1  (.A(\REGF[12].RFW.q_wire[28] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[28].OBUF2  (.A(\REGF[12].RFW.q_wire[28] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[29].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[12].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[29].OBUF1  (.A(\REGF[12].RFW.q_wire[29] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[29].OBUF2  (.A(\REGF[12].RFW.q_wire[29] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[2].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[12].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[2].OBUF1  (.A(\REGF[12].RFW.q_wire[2] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[2].OBUF2  (.A(\REGF[12].RFW.q_wire[2] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[30].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[12].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[30].OBUF1  (.A(\REGF[12].RFW.q_wire[30] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[30].OBUF2  (.A(\REGF[12].RFW.q_wire[30] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[31].FF  (.CLK(\REGF[12].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[12].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[31].OBUF1  (.A(\REGF[12].RFW.q_wire[31] ),
    .TE_B(\REGF[12].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[31].OBUF2  (.A(\REGF[12].RFW.q_wire[31] ),
    .TE_B(\REGF[12].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[3].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[12].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[3].OBUF1  (.A(\REGF[12].RFW.q_wire[3] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[3].OBUF2  (.A(\REGF[12].RFW.q_wire[3] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[4].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[12].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[4].OBUF1  (.A(\REGF[12].RFW.q_wire[4] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[4].OBUF2  (.A(\REGF[12].RFW.q_wire[4] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[5].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[12].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[5].OBUF1  (.A(\REGF[12].RFW.q_wire[5] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[5].OBUF2  (.A(\REGF[12].RFW.q_wire[5] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[6].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[12].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[6].OBUF1  (.A(\REGF[12].RFW.q_wire[6] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[6].OBUF2  (.A(\REGF[12].RFW.q_wire[6] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[7].FF  (.CLK(\REGF[12].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[12].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[7].OBUF1  (.A(\REGF[12].RFW.q_wire[7] ),
    .TE_B(\REGF[12].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[7].OBUF2  (.A(\REGF[12].RFW.q_wire[7] ),
    .TE_B(\REGF[12].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[8].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[12].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[8].OBUF1  (.A(\REGF[12].RFW.q_wire[8] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[8].OBUF2  (.A(\REGF[12].RFW.q_wire[8] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[12].RFW.BIT[9].FF  (.CLK(\REGF[12].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[12].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[9].OBUF1  (.A(\REGF[12].RFW.q_wire[9] ),
    .TE_B(\REGF[12].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[12].RFW.BIT[9].OBUF2  (.A(\REGF[12].RFW.q_wire[9] ),
    .TE_B(\REGF[12].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[12].RFW.CGAND  (.A(\DEC2.D1.SEL[4] ),
    .B(WE),
    .X(\REGF[12].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[12].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[12].RFW.we_wire ),
    .GCLK(\REGF[12].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[12].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[12].RFW.we_wire ),
    .GCLK(\REGF[12].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[12].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[12].RFW.we_wire ),
    .GCLK(\REGF[12].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[12].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[12].RFW.we_wire ),
    .GCLK(\REGF[12].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV1[0]  (.A(\DEC0.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV1[1]  (.A(\DEC0.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV1[2]  (.A(\DEC0.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV1[3]  (.A(\DEC0.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV2[0]  (.A(\DEC1.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV2[1]  (.A(\DEC1.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV2[2]  (.A(\DEC1.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[12].RFW.INV2[3]  (.A(\DEC1.D1.SEL[4] ),
    .Y(\REGF[12].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[0].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[13].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[0].OBUF1  (.A(\REGF[13].RFW.q_wire[0] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[0].OBUF2  (.A(\REGF[13].RFW.q_wire[0] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[10].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[13].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[10].OBUF1  (.A(\REGF[13].RFW.q_wire[10] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[10].OBUF2  (.A(\REGF[13].RFW.q_wire[10] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[11].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[13].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[11].OBUF1  (.A(\REGF[13].RFW.q_wire[11] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[11].OBUF2  (.A(\REGF[13].RFW.q_wire[11] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[12].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[13].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[12].OBUF1  (.A(\REGF[13].RFW.q_wire[12] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[12].OBUF2  (.A(\REGF[13].RFW.q_wire[12] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[13].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[13].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[13].OBUF1  (.A(\REGF[13].RFW.q_wire[13] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[13].OBUF2  (.A(\REGF[13].RFW.q_wire[13] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[14].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[13].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[14].OBUF1  (.A(\REGF[13].RFW.q_wire[14] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[14].OBUF2  (.A(\REGF[13].RFW.q_wire[14] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[15].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[13].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[15].OBUF1  (.A(\REGF[13].RFW.q_wire[15] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[15].OBUF2  (.A(\REGF[13].RFW.q_wire[15] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[16].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[13].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[16].OBUF1  (.A(\REGF[13].RFW.q_wire[16] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[16].OBUF2  (.A(\REGF[13].RFW.q_wire[16] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[17].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[13].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[17].OBUF1  (.A(\REGF[13].RFW.q_wire[17] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[17].OBUF2  (.A(\REGF[13].RFW.q_wire[17] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[18].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[13].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[18].OBUF1  (.A(\REGF[13].RFW.q_wire[18] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[18].OBUF2  (.A(\REGF[13].RFW.q_wire[18] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[19].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[13].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[19].OBUF1  (.A(\REGF[13].RFW.q_wire[19] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[19].OBUF2  (.A(\REGF[13].RFW.q_wire[19] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[1].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[13].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[1].OBUF1  (.A(\REGF[13].RFW.q_wire[1] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[1].OBUF2  (.A(\REGF[13].RFW.q_wire[1] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[20].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[13].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[20].OBUF1  (.A(\REGF[13].RFW.q_wire[20] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[20].OBUF2  (.A(\REGF[13].RFW.q_wire[20] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[21].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[13].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[21].OBUF1  (.A(\REGF[13].RFW.q_wire[21] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[21].OBUF2  (.A(\REGF[13].RFW.q_wire[21] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[22].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[13].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[22].OBUF1  (.A(\REGF[13].RFW.q_wire[22] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[22].OBUF2  (.A(\REGF[13].RFW.q_wire[22] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[23].FF  (.CLK(\REGF[13].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[13].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[23].OBUF1  (.A(\REGF[13].RFW.q_wire[23] ),
    .TE_B(\REGF[13].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[23].OBUF2  (.A(\REGF[13].RFW.q_wire[23] ),
    .TE_B(\REGF[13].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[24].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[13].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[24].OBUF1  (.A(\REGF[13].RFW.q_wire[24] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[24].OBUF2  (.A(\REGF[13].RFW.q_wire[24] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[25].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[13].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[25].OBUF1  (.A(\REGF[13].RFW.q_wire[25] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[25].OBUF2  (.A(\REGF[13].RFW.q_wire[25] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[26].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[13].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[26].OBUF1  (.A(\REGF[13].RFW.q_wire[26] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[26].OBUF2  (.A(\REGF[13].RFW.q_wire[26] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[27].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[13].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[27].OBUF1  (.A(\REGF[13].RFW.q_wire[27] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[27].OBUF2  (.A(\REGF[13].RFW.q_wire[27] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[28].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[13].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[28].OBUF1  (.A(\REGF[13].RFW.q_wire[28] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[28].OBUF2  (.A(\REGF[13].RFW.q_wire[28] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[29].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[13].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[29].OBUF1  (.A(\REGF[13].RFW.q_wire[29] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[29].OBUF2  (.A(\REGF[13].RFW.q_wire[29] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[2].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[13].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[2].OBUF1  (.A(\REGF[13].RFW.q_wire[2] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[2].OBUF2  (.A(\REGF[13].RFW.q_wire[2] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[30].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[13].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[30].OBUF1  (.A(\REGF[13].RFW.q_wire[30] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[30].OBUF2  (.A(\REGF[13].RFW.q_wire[30] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[31].FF  (.CLK(\REGF[13].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[13].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[31].OBUF1  (.A(\REGF[13].RFW.q_wire[31] ),
    .TE_B(\REGF[13].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[31].OBUF2  (.A(\REGF[13].RFW.q_wire[31] ),
    .TE_B(\REGF[13].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[3].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[13].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[3].OBUF1  (.A(\REGF[13].RFW.q_wire[3] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[3].OBUF2  (.A(\REGF[13].RFW.q_wire[3] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[4].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[13].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[4].OBUF1  (.A(\REGF[13].RFW.q_wire[4] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[4].OBUF2  (.A(\REGF[13].RFW.q_wire[4] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[5].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[13].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[5].OBUF1  (.A(\REGF[13].RFW.q_wire[5] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[5].OBUF2  (.A(\REGF[13].RFW.q_wire[5] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[6].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[13].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[6].OBUF1  (.A(\REGF[13].RFW.q_wire[6] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[6].OBUF2  (.A(\REGF[13].RFW.q_wire[6] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[7].FF  (.CLK(\REGF[13].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[13].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[7].OBUF1  (.A(\REGF[13].RFW.q_wire[7] ),
    .TE_B(\REGF[13].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[7].OBUF2  (.A(\REGF[13].RFW.q_wire[7] ),
    .TE_B(\REGF[13].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[8].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[13].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[8].OBUF1  (.A(\REGF[13].RFW.q_wire[8] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[8].OBUF2  (.A(\REGF[13].RFW.q_wire[8] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[13].RFW.BIT[9].FF  (.CLK(\REGF[13].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[13].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[9].OBUF1  (.A(\REGF[13].RFW.q_wire[9] ),
    .TE_B(\REGF[13].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[13].RFW.BIT[9].OBUF2  (.A(\REGF[13].RFW.q_wire[9] ),
    .TE_B(\REGF[13].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[13].RFW.CGAND  (.A(\DEC2.D1.SEL[5] ),
    .B(WE),
    .X(\REGF[13].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[13].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[13].RFW.we_wire ),
    .GCLK(\REGF[13].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[13].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[13].RFW.we_wire ),
    .GCLK(\REGF[13].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[13].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[13].RFW.we_wire ),
    .GCLK(\REGF[13].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[13].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[13].RFW.we_wire ),
    .GCLK(\REGF[13].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV1[0]  (.A(\DEC0.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV1[1]  (.A(\DEC0.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV1[2]  (.A(\DEC0.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV1[3]  (.A(\DEC0.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV2[0]  (.A(\DEC1.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV2[1]  (.A(\DEC1.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV2[2]  (.A(\DEC1.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[13].RFW.INV2[3]  (.A(\DEC1.D1.SEL[5] ),
    .Y(\REGF[13].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[0].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[14].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[0].OBUF1  (.A(\REGF[14].RFW.q_wire[0] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[0].OBUF2  (.A(\REGF[14].RFW.q_wire[0] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[10].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[14].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[10].OBUF1  (.A(\REGF[14].RFW.q_wire[10] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[10].OBUF2  (.A(\REGF[14].RFW.q_wire[10] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[11].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[14].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[11].OBUF1  (.A(\REGF[14].RFW.q_wire[11] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[11].OBUF2  (.A(\REGF[14].RFW.q_wire[11] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[12].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[14].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[12].OBUF1  (.A(\REGF[14].RFW.q_wire[12] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[12].OBUF2  (.A(\REGF[14].RFW.q_wire[12] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[13].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[14].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[13].OBUF1  (.A(\REGF[14].RFW.q_wire[13] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[13].OBUF2  (.A(\REGF[14].RFW.q_wire[13] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[14].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[14].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[14].OBUF1  (.A(\REGF[14].RFW.q_wire[14] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[14].OBUF2  (.A(\REGF[14].RFW.q_wire[14] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[15].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[14].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[15].OBUF1  (.A(\REGF[14].RFW.q_wire[15] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[15].OBUF2  (.A(\REGF[14].RFW.q_wire[15] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[16].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[14].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[16].OBUF1  (.A(\REGF[14].RFW.q_wire[16] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[16].OBUF2  (.A(\REGF[14].RFW.q_wire[16] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[17].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[14].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[17].OBUF1  (.A(\REGF[14].RFW.q_wire[17] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[17].OBUF2  (.A(\REGF[14].RFW.q_wire[17] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[18].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[14].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[18].OBUF1  (.A(\REGF[14].RFW.q_wire[18] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[18].OBUF2  (.A(\REGF[14].RFW.q_wire[18] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[19].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[14].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[19].OBUF1  (.A(\REGF[14].RFW.q_wire[19] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[19].OBUF2  (.A(\REGF[14].RFW.q_wire[19] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[1].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[14].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[1].OBUF1  (.A(\REGF[14].RFW.q_wire[1] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[1].OBUF2  (.A(\REGF[14].RFW.q_wire[1] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[20].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[14].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[20].OBUF1  (.A(\REGF[14].RFW.q_wire[20] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[20].OBUF2  (.A(\REGF[14].RFW.q_wire[20] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[21].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[14].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[21].OBUF1  (.A(\REGF[14].RFW.q_wire[21] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[21].OBUF2  (.A(\REGF[14].RFW.q_wire[21] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[22].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[14].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[22].OBUF1  (.A(\REGF[14].RFW.q_wire[22] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[22].OBUF2  (.A(\REGF[14].RFW.q_wire[22] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[23].FF  (.CLK(\REGF[14].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[14].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[23].OBUF1  (.A(\REGF[14].RFW.q_wire[23] ),
    .TE_B(\REGF[14].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[23].OBUF2  (.A(\REGF[14].RFW.q_wire[23] ),
    .TE_B(\REGF[14].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[24].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[14].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[24].OBUF1  (.A(\REGF[14].RFW.q_wire[24] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[24].OBUF2  (.A(\REGF[14].RFW.q_wire[24] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[25].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[14].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[25].OBUF1  (.A(\REGF[14].RFW.q_wire[25] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[25].OBUF2  (.A(\REGF[14].RFW.q_wire[25] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[26].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[14].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[26].OBUF1  (.A(\REGF[14].RFW.q_wire[26] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[26].OBUF2  (.A(\REGF[14].RFW.q_wire[26] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[27].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[14].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[27].OBUF1  (.A(\REGF[14].RFW.q_wire[27] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[27].OBUF2  (.A(\REGF[14].RFW.q_wire[27] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[28].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[14].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[28].OBUF1  (.A(\REGF[14].RFW.q_wire[28] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[28].OBUF2  (.A(\REGF[14].RFW.q_wire[28] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[29].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[14].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[29].OBUF1  (.A(\REGF[14].RFW.q_wire[29] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[29].OBUF2  (.A(\REGF[14].RFW.q_wire[29] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[2].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[14].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[2].OBUF1  (.A(\REGF[14].RFW.q_wire[2] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[2].OBUF2  (.A(\REGF[14].RFW.q_wire[2] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[30].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[14].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[30].OBUF1  (.A(\REGF[14].RFW.q_wire[30] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[30].OBUF2  (.A(\REGF[14].RFW.q_wire[30] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[31].FF  (.CLK(\REGF[14].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[14].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[31].OBUF1  (.A(\REGF[14].RFW.q_wire[31] ),
    .TE_B(\REGF[14].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[31].OBUF2  (.A(\REGF[14].RFW.q_wire[31] ),
    .TE_B(\REGF[14].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[3].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[14].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[3].OBUF1  (.A(\REGF[14].RFW.q_wire[3] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[3].OBUF2  (.A(\REGF[14].RFW.q_wire[3] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[4].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[14].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[4].OBUF1  (.A(\REGF[14].RFW.q_wire[4] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[4].OBUF2  (.A(\REGF[14].RFW.q_wire[4] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[5].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[14].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[5].OBUF1  (.A(\REGF[14].RFW.q_wire[5] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[5].OBUF2  (.A(\REGF[14].RFW.q_wire[5] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[6].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[14].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[6].OBUF1  (.A(\REGF[14].RFW.q_wire[6] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[6].OBUF2  (.A(\REGF[14].RFW.q_wire[6] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[7].FF  (.CLK(\REGF[14].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[14].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[7].OBUF1  (.A(\REGF[14].RFW.q_wire[7] ),
    .TE_B(\REGF[14].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[7].OBUF2  (.A(\REGF[14].RFW.q_wire[7] ),
    .TE_B(\REGF[14].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[8].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[14].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[8].OBUF1  (.A(\REGF[14].RFW.q_wire[8] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[8].OBUF2  (.A(\REGF[14].RFW.q_wire[8] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[14].RFW.BIT[9].FF  (.CLK(\REGF[14].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[14].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[9].OBUF1  (.A(\REGF[14].RFW.q_wire[9] ),
    .TE_B(\REGF[14].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[14].RFW.BIT[9].OBUF2  (.A(\REGF[14].RFW.q_wire[9] ),
    .TE_B(\REGF[14].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[14].RFW.CGAND  (.A(\DEC2.D1.SEL[6] ),
    .B(WE),
    .X(\REGF[14].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[14].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[14].RFW.we_wire ),
    .GCLK(\REGF[14].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[14].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[14].RFW.we_wire ),
    .GCLK(\REGF[14].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[14].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[14].RFW.we_wire ),
    .GCLK(\REGF[14].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[14].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[14].RFW.we_wire ),
    .GCLK(\REGF[14].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV1[0]  (.A(\DEC0.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV1[1]  (.A(\DEC0.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV1[2]  (.A(\DEC0.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV1[3]  (.A(\DEC0.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV2[0]  (.A(\DEC1.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV2[1]  (.A(\DEC1.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV2[2]  (.A(\DEC1.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[14].RFW.INV2[3]  (.A(\DEC1.D1.SEL[6] ),
    .Y(\REGF[14].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[0].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[15].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[0].OBUF1  (.A(\REGF[15].RFW.q_wire[0] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[0].OBUF2  (.A(\REGF[15].RFW.q_wire[0] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[10].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[15].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[10].OBUF1  (.A(\REGF[15].RFW.q_wire[10] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[10].OBUF2  (.A(\REGF[15].RFW.q_wire[10] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[11].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[15].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[11].OBUF1  (.A(\REGF[15].RFW.q_wire[11] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[11].OBUF2  (.A(\REGF[15].RFW.q_wire[11] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[12].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[15].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[12].OBUF1  (.A(\REGF[15].RFW.q_wire[12] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[12].OBUF2  (.A(\REGF[15].RFW.q_wire[12] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[13].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[15].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[13].OBUF1  (.A(\REGF[15].RFW.q_wire[13] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[13].OBUF2  (.A(\REGF[15].RFW.q_wire[13] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[14].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[15].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[14].OBUF1  (.A(\REGF[15].RFW.q_wire[14] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[14].OBUF2  (.A(\REGF[15].RFW.q_wire[14] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[15].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[15].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[15].OBUF1  (.A(\REGF[15].RFW.q_wire[15] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[15].OBUF2  (.A(\REGF[15].RFW.q_wire[15] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[16].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[15].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[16].OBUF1  (.A(\REGF[15].RFW.q_wire[16] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[16].OBUF2  (.A(\REGF[15].RFW.q_wire[16] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[17].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[15].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[17].OBUF1  (.A(\REGF[15].RFW.q_wire[17] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[17].OBUF2  (.A(\REGF[15].RFW.q_wire[17] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[18].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[15].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[18].OBUF1  (.A(\REGF[15].RFW.q_wire[18] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[18].OBUF2  (.A(\REGF[15].RFW.q_wire[18] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[19].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[15].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[19].OBUF1  (.A(\REGF[15].RFW.q_wire[19] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[19].OBUF2  (.A(\REGF[15].RFW.q_wire[19] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[1].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[15].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[1].OBUF1  (.A(\REGF[15].RFW.q_wire[1] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[1].OBUF2  (.A(\REGF[15].RFW.q_wire[1] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[20].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[15].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[20].OBUF1  (.A(\REGF[15].RFW.q_wire[20] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[20].OBUF2  (.A(\REGF[15].RFW.q_wire[20] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[21].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[15].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[21].OBUF1  (.A(\REGF[15].RFW.q_wire[21] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[21].OBUF2  (.A(\REGF[15].RFW.q_wire[21] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[22].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[15].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[22].OBUF1  (.A(\REGF[15].RFW.q_wire[22] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[22].OBUF2  (.A(\REGF[15].RFW.q_wire[22] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[23].FF  (.CLK(\REGF[15].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[15].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[23].OBUF1  (.A(\REGF[15].RFW.q_wire[23] ),
    .TE_B(\REGF[15].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[23].OBUF2  (.A(\REGF[15].RFW.q_wire[23] ),
    .TE_B(\REGF[15].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[24].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[15].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[24].OBUF1  (.A(\REGF[15].RFW.q_wire[24] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[24].OBUF2  (.A(\REGF[15].RFW.q_wire[24] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[25].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[15].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[25].OBUF1  (.A(\REGF[15].RFW.q_wire[25] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[25].OBUF2  (.A(\REGF[15].RFW.q_wire[25] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[26].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[15].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[26].OBUF1  (.A(\REGF[15].RFW.q_wire[26] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[26].OBUF2  (.A(\REGF[15].RFW.q_wire[26] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[27].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[15].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[27].OBUF1  (.A(\REGF[15].RFW.q_wire[27] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[27].OBUF2  (.A(\REGF[15].RFW.q_wire[27] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[28].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[15].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[28].OBUF1  (.A(\REGF[15].RFW.q_wire[28] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[28].OBUF2  (.A(\REGF[15].RFW.q_wire[28] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[29].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[15].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[29].OBUF1  (.A(\REGF[15].RFW.q_wire[29] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[29].OBUF2  (.A(\REGF[15].RFW.q_wire[29] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[2].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[15].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[2].OBUF1  (.A(\REGF[15].RFW.q_wire[2] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[2].OBUF2  (.A(\REGF[15].RFW.q_wire[2] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[30].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[15].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[30].OBUF1  (.A(\REGF[15].RFW.q_wire[30] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[30].OBUF2  (.A(\REGF[15].RFW.q_wire[30] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[31].FF  (.CLK(\REGF[15].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[15].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[31].OBUF1  (.A(\REGF[15].RFW.q_wire[31] ),
    .TE_B(\REGF[15].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[31].OBUF2  (.A(\REGF[15].RFW.q_wire[31] ),
    .TE_B(\REGF[15].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[3].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[15].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[3].OBUF1  (.A(\REGF[15].RFW.q_wire[3] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[3].OBUF2  (.A(\REGF[15].RFW.q_wire[3] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[4].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[15].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[4].OBUF1  (.A(\REGF[15].RFW.q_wire[4] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[4].OBUF2  (.A(\REGF[15].RFW.q_wire[4] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[5].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[15].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[5].OBUF1  (.A(\REGF[15].RFW.q_wire[5] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[5].OBUF2  (.A(\REGF[15].RFW.q_wire[5] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[6].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[15].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[6].OBUF1  (.A(\REGF[15].RFW.q_wire[6] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[6].OBUF2  (.A(\REGF[15].RFW.q_wire[6] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[7].FF  (.CLK(\REGF[15].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[15].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[7].OBUF1  (.A(\REGF[15].RFW.q_wire[7] ),
    .TE_B(\REGF[15].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[7].OBUF2  (.A(\REGF[15].RFW.q_wire[7] ),
    .TE_B(\REGF[15].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[8].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[15].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[8].OBUF1  (.A(\REGF[15].RFW.q_wire[8] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[8].OBUF2  (.A(\REGF[15].RFW.q_wire[8] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[15].RFW.BIT[9].FF  (.CLK(\REGF[15].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[15].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[9].OBUF1  (.A(\REGF[15].RFW.q_wire[9] ),
    .TE_B(\REGF[15].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[15].RFW.BIT[9].OBUF2  (.A(\REGF[15].RFW.q_wire[9] ),
    .TE_B(\REGF[15].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[15].RFW.CGAND  (.A(\DEC2.D1.SEL[7] ),
    .B(WE),
    .X(\REGF[15].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[15].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[15].RFW.we_wire ),
    .GCLK(\REGF[15].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[15].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[15].RFW.we_wire ),
    .GCLK(\REGF[15].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[15].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[15].RFW.we_wire ),
    .GCLK(\REGF[15].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[15].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[15].RFW.we_wire ),
    .GCLK(\REGF[15].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV1[0]  (.A(\DEC0.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV1[1]  (.A(\DEC0.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV1[2]  (.A(\DEC0.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV1[3]  (.A(\DEC0.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV2[0]  (.A(\DEC1.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV2[1]  (.A(\DEC1.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV2[2]  (.A(\DEC1.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[15].RFW.INV2[3]  (.A(\DEC1.D1.SEL[7] ),
    .Y(\REGF[15].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[0].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[16].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[0].OBUF1  (.A(\REGF[16].RFW.q_wire[0] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[0].OBUF2  (.A(\REGF[16].RFW.q_wire[0] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[10].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[16].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[10].OBUF1  (.A(\REGF[16].RFW.q_wire[10] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[10].OBUF2  (.A(\REGF[16].RFW.q_wire[10] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[11].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[16].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[11].OBUF1  (.A(\REGF[16].RFW.q_wire[11] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[11].OBUF2  (.A(\REGF[16].RFW.q_wire[11] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[12].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[16].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[12].OBUF1  (.A(\REGF[16].RFW.q_wire[12] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[12].OBUF2  (.A(\REGF[16].RFW.q_wire[12] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[13].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[16].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[13].OBUF1  (.A(\REGF[16].RFW.q_wire[13] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[13].OBUF2  (.A(\REGF[16].RFW.q_wire[13] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[14].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[16].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[14].OBUF1  (.A(\REGF[16].RFW.q_wire[14] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[14].OBUF2  (.A(\REGF[16].RFW.q_wire[14] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[15].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[16].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[15].OBUF1  (.A(\REGF[16].RFW.q_wire[15] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[15].OBUF2  (.A(\REGF[16].RFW.q_wire[15] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[16].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[16].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[16].OBUF1  (.A(\REGF[16].RFW.q_wire[16] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[16].OBUF2  (.A(\REGF[16].RFW.q_wire[16] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[17].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[16].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[17].OBUF1  (.A(\REGF[16].RFW.q_wire[17] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[17].OBUF2  (.A(\REGF[16].RFW.q_wire[17] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[18].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[16].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[18].OBUF1  (.A(\REGF[16].RFW.q_wire[18] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[18].OBUF2  (.A(\REGF[16].RFW.q_wire[18] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[19].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[16].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[19].OBUF1  (.A(\REGF[16].RFW.q_wire[19] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[19].OBUF2  (.A(\REGF[16].RFW.q_wire[19] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[1].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[16].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[1].OBUF1  (.A(\REGF[16].RFW.q_wire[1] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[1].OBUF2  (.A(\REGF[16].RFW.q_wire[1] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[20].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[16].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[20].OBUF1  (.A(\REGF[16].RFW.q_wire[20] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[20].OBUF2  (.A(\REGF[16].RFW.q_wire[20] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[21].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[16].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[21].OBUF1  (.A(\REGF[16].RFW.q_wire[21] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[21].OBUF2  (.A(\REGF[16].RFW.q_wire[21] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[22].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[16].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[22].OBUF1  (.A(\REGF[16].RFW.q_wire[22] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[22].OBUF2  (.A(\REGF[16].RFW.q_wire[22] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[23].FF  (.CLK(\REGF[16].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[16].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[23].OBUF1  (.A(\REGF[16].RFW.q_wire[23] ),
    .TE_B(\REGF[16].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[23].OBUF2  (.A(\REGF[16].RFW.q_wire[23] ),
    .TE_B(\REGF[16].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[24].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[16].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[24].OBUF1  (.A(\REGF[16].RFW.q_wire[24] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[24].OBUF2  (.A(\REGF[16].RFW.q_wire[24] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[25].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[16].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[25].OBUF1  (.A(\REGF[16].RFW.q_wire[25] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[25].OBUF2  (.A(\REGF[16].RFW.q_wire[25] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[26].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[16].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[26].OBUF1  (.A(\REGF[16].RFW.q_wire[26] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[26].OBUF2  (.A(\REGF[16].RFW.q_wire[26] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[27].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[16].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[27].OBUF1  (.A(\REGF[16].RFW.q_wire[27] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[27].OBUF2  (.A(\REGF[16].RFW.q_wire[27] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[28].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[16].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[28].OBUF1  (.A(\REGF[16].RFW.q_wire[28] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[28].OBUF2  (.A(\REGF[16].RFW.q_wire[28] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[29].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[16].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[29].OBUF1  (.A(\REGF[16].RFW.q_wire[29] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[29].OBUF2  (.A(\REGF[16].RFW.q_wire[29] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[2].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[16].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[2].OBUF1  (.A(\REGF[16].RFW.q_wire[2] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[2].OBUF2  (.A(\REGF[16].RFW.q_wire[2] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[30].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[16].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[30].OBUF1  (.A(\REGF[16].RFW.q_wire[30] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[30].OBUF2  (.A(\REGF[16].RFW.q_wire[30] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[31].FF  (.CLK(\REGF[16].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[16].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[31].OBUF1  (.A(\REGF[16].RFW.q_wire[31] ),
    .TE_B(\REGF[16].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[31].OBUF2  (.A(\REGF[16].RFW.q_wire[31] ),
    .TE_B(\REGF[16].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[3].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[16].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[3].OBUF1  (.A(\REGF[16].RFW.q_wire[3] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[3].OBUF2  (.A(\REGF[16].RFW.q_wire[3] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[4].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[16].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[4].OBUF1  (.A(\REGF[16].RFW.q_wire[4] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[4].OBUF2  (.A(\REGF[16].RFW.q_wire[4] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[5].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[16].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[5].OBUF1  (.A(\REGF[16].RFW.q_wire[5] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[5].OBUF2  (.A(\REGF[16].RFW.q_wire[5] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[6].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[16].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[6].OBUF1  (.A(\REGF[16].RFW.q_wire[6] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[6].OBUF2  (.A(\REGF[16].RFW.q_wire[6] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[7].FF  (.CLK(\REGF[16].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[16].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[7].OBUF1  (.A(\REGF[16].RFW.q_wire[7] ),
    .TE_B(\REGF[16].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[7].OBUF2  (.A(\REGF[16].RFW.q_wire[7] ),
    .TE_B(\REGF[16].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[8].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[16].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[8].OBUF1  (.A(\REGF[16].RFW.q_wire[8] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[8].OBUF2  (.A(\REGF[16].RFW.q_wire[8] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[16].RFW.BIT[9].FF  (.CLK(\REGF[16].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[16].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[9].OBUF1  (.A(\REGF[16].RFW.q_wire[9] ),
    .TE_B(\REGF[16].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[16].RFW.BIT[9].OBUF2  (.A(\REGF[16].RFW.q_wire[9] ),
    .TE_B(\REGF[16].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[16].RFW.CGAND  (.A(\DEC2.D2.SEL[0] ),
    .B(WE),
    .X(\REGF[16].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[16].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[16].RFW.we_wire ),
    .GCLK(\REGF[16].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[16].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[16].RFW.we_wire ),
    .GCLK(\REGF[16].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[16].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[16].RFW.we_wire ),
    .GCLK(\REGF[16].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[16].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[16].RFW.we_wire ),
    .GCLK(\REGF[16].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV1[0]  (.A(\DEC0.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV1[1]  (.A(\DEC0.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV1[2]  (.A(\DEC0.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV1[3]  (.A(\DEC0.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV2[0]  (.A(\DEC1.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV2[1]  (.A(\DEC1.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV2[2]  (.A(\DEC1.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[16].RFW.INV2[3]  (.A(\DEC1.D2.SEL[0] ),
    .Y(\REGF[16].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[0].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[17].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[0].OBUF1  (.A(\REGF[17].RFW.q_wire[0] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[0].OBUF2  (.A(\REGF[17].RFW.q_wire[0] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[10].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[17].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[10].OBUF1  (.A(\REGF[17].RFW.q_wire[10] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[10].OBUF2  (.A(\REGF[17].RFW.q_wire[10] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[11].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[17].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[11].OBUF1  (.A(\REGF[17].RFW.q_wire[11] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[11].OBUF2  (.A(\REGF[17].RFW.q_wire[11] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[12].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[17].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[12].OBUF1  (.A(\REGF[17].RFW.q_wire[12] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[12].OBUF2  (.A(\REGF[17].RFW.q_wire[12] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[13].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[17].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[13].OBUF1  (.A(\REGF[17].RFW.q_wire[13] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[13].OBUF2  (.A(\REGF[17].RFW.q_wire[13] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[14].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[17].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[14].OBUF1  (.A(\REGF[17].RFW.q_wire[14] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[14].OBUF2  (.A(\REGF[17].RFW.q_wire[14] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[15].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[17].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[15].OBUF1  (.A(\REGF[17].RFW.q_wire[15] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[15].OBUF2  (.A(\REGF[17].RFW.q_wire[15] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[16].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[17].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[16].OBUF1  (.A(\REGF[17].RFW.q_wire[16] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[16].OBUF2  (.A(\REGF[17].RFW.q_wire[16] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[17].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[17].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[17].OBUF1  (.A(\REGF[17].RFW.q_wire[17] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[17].OBUF2  (.A(\REGF[17].RFW.q_wire[17] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[18].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[17].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[18].OBUF1  (.A(\REGF[17].RFW.q_wire[18] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[18].OBUF2  (.A(\REGF[17].RFW.q_wire[18] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[19].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[17].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[19].OBUF1  (.A(\REGF[17].RFW.q_wire[19] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[19].OBUF2  (.A(\REGF[17].RFW.q_wire[19] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[1].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[17].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[1].OBUF1  (.A(\REGF[17].RFW.q_wire[1] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[1].OBUF2  (.A(\REGF[17].RFW.q_wire[1] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[20].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[17].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[20].OBUF1  (.A(\REGF[17].RFW.q_wire[20] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[20].OBUF2  (.A(\REGF[17].RFW.q_wire[20] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[21].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[17].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[21].OBUF1  (.A(\REGF[17].RFW.q_wire[21] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[21].OBUF2  (.A(\REGF[17].RFW.q_wire[21] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[22].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[17].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[22].OBUF1  (.A(\REGF[17].RFW.q_wire[22] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[22].OBUF2  (.A(\REGF[17].RFW.q_wire[22] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[23].FF  (.CLK(\REGF[17].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[17].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[23].OBUF1  (.A(\REGF[17].RFW.q_wire[23] ),
    .TE_B(\REGF[17].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[23].OBUF2  (.A(\REGF[17].RFW.q_wire[23] ),
    .TE_B(\REGF[17].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[24].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[17].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[24].OBUF1  (.A(\REGF[17].RFW.q_wire[24] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[24].OBUF2  (.A(\REGF[17].RFW.q_wire[24] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[25].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[17].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[25].OBUF1  (.A(\REGF[17].RFW.q_wire[25] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[25].OBUF2  (.A(\REGF[17].RFW.q_wire[25] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[26].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[17].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[26].OBUF1  (.A(\REGF[17].RFW.q_wire[26] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[26].OBUF2  (.A(\REGF[17].RFW.q_wire[26] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[27].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[17].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[27].OBUF1  (.A(\REGF[17].RFW.q_wire[27] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[27].OBUF2  (.A(\REGF[17].RFW.q_wire[27] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[28].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[17].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[28].OBUF1  (.A(\REGF[17].RFW.q_wire[28] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[28].OBUF2  (.A(\REGF[17].RFW.q_wire[28] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[29].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[17].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[29].OBUF1  (.A(\REGF[17].RFW.q_wire[29] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[29].OBUF2  (.A(\REGF[17].RFW.q_wire[29] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[2].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[17].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[2].OBUF1  (.A(\REGF[17].RFW.q_wire[2] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[2].OBUF2  (.A(\REGF[17].RFW.q_wire[2] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[30].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[17].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[30].OBUF1  (.A(\REGF[17].RFW.q_wire[30] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[30].OBUF2  (.A(\REGF[17].RFW.q_wire[30] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[31].FF  (.CLK(\REGF[17].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[17].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[31].OBUF1  (.A(\REGF[17].RFW.q_wire[31] ),
    .TE_B(\REGF[17].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[31].OBUF2  (.A(\REGF[17].RFW.q_wire[31] ),
    .TE_B(\REGF[17].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[3].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[17].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[3].OBUF1  (.A(\REGF[17].RFW.q_wire[3] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[3].OBUF2  (.A(\REGF[17].RFW.q_wire[3] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[4].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[17].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[4].OBUF1  (.A(\REGF[17].RFW.q_wire[4] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[4].OBUF2  (.A(\REGF[17].RFW.q_wire[4] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[5].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[17].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[5].OBUF1  (.A(\REGF[17].RFW.q_wire[5] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[5].OBUF2  (.A(\REGF[17].RFW.q_wire[5] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[6].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[17].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[6].OBUF1  (.A(\REGF[17].RFW.q_wire[6] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[6].OBUF2  (.A(\REGF[17].RFW.q_wire[6] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[7].FF  (.CLK(\REGF[17].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[17].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[7].OBUF1  (.A(\REGF[17].RFW.q_wire[7] ),
    .TE_B(\REGF[17].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[7].OBUF2  (.A(\REGF[17].RFW.q_wire[7] ),
    .TE_B(\REGF[17].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[8].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[17].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[8].OBUF1  (.A(\REGF[17].RFW.q_wire[8] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[8].OBUF2  (.A(\REGF[17].RFW.q_wire[8] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[17].RFW.BIT[9].FF  (.CLK(\REGF[17].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[17].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[9].OBUF1  (.A(\REGF[17].RFW.q_wire[9] ),
    .TE_B(\REGF[17].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[17].RFW.BIT[9].OBUF2  (.A(\REGF[17].RFW.q_wire[9] ),
    .TE_B(\REGF[17].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[17].RFW.CGAND  (.A(\DEC2.D2.SEL[1] ),
    .B(WE),
    .X(\REGF[17].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[17].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[17].RFW.we_wire ),
    .GCLK(\REGF[17].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[17].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[17].RFW.we_wire ),
    .GCLK(\REGF[17].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[17].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[17].RFW.we_wire ),
    .GCLK(\REGF[17].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[17].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[17].RFW.we_wire ),
    .GCLK(\REGF[17].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV1[0]  (.A(\DEC0.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV1[1]  (.A(\DEC0.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV1[2]  (.A(\DEC0.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV1[3]  (.A(\DEC0.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV2[0]  (.A(\DEC1.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV2[1]  (.A(\DEC1.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV2[2]  (.A(\DEC1.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[17].RFW.INV2[3]  (.A(\DEC1.D2.SEL[1] ),
    .Y(\REGF[17].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[0].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[18].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[0].OBUF1  (.A(\REGF[18].RFW.q_wire[0] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[0].OBUF2  (.A(\REGF[18].RFW.q_wire[0] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[10].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[18].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[10].OBUF1  (.A(\REGF[18].RFW.q_wire[10] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[10].OBUF2  (.A(\REGF[18].RFW.q_wire[10] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[11].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[18].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[11].OBUF1  (.A(\REGF[18].RFW.q_wire[11] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[11].OBUF2  (.A(\REGF[18].RFW.q_wire[11] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[12].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[18].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[12].OBUF1  (.A(\REGF[18].RFW.q_wire[12] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[12].OBUF2  (.A(\REGF[18].RFW.q_wire[12] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[13].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[18].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[13].OBUF1  (.A(\REGF[18].RFW.q_wire[13] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[13].OBUF2  (.A(\REGF[18].RFW.q_wire[13] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[14].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[18].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[14].OBUF1  (.A(\REGF[18].RFW.q_wire[14] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[14].OBUF2  (.A(\REGF[18].RFW.q_wire[14] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[15].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[18].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[15].OBUF1  (.A(\REGF[18].RFW.q_wire[15] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[15].OBUF2  (.A(\REGF[18].RFW.q_wire[15] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[16].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[18].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[16].OBUF1  (.A(\REGF[18].RFW.q_wire[16] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[16].OBUF2  (.A(\REGF[18].RFW.q_wire[16] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[17].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[18].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[17].OBUF1  (.A(\REGF[18].RFW.q_wire[17] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[17].OBUF2  (.A(\REGF[18].RFW.q_wire[17] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[18].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[18].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[18].OBUF1  (.A(\REGF[18].RFW.q_wire[18] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[18].OBUF2  (.A(\REGF[18].RFW.q_wire[18] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[19].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[18].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[19].OBUF1  (.A(\REGF[18].RFW.q_wire[19] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[19].OBUF2  (.A(\REGF[18].RFW.q_wire[19] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[1].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[18].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[1].OBUF1  (.A(\REGF[18].RFW.q_wire[1] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[1].OBUF2  (.A(\REGF[18].RFW.q_wire[1] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[20].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[18].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[20].OBUF1  (.A(\REGF[18].RFW.q_wire[20] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[20].OBUF2  (.A(\REGF[18].RFW.q_wire[20] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[21].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[18].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[21].OBUF1  (.A(\REGF[18].RFW.q_wire[21] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[21].OBUF2  (.A(\REGF[18].RFW.q_wire[21] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[22].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[18].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[22].OBUF1  (.A(\REGF[18].RFW.q_wire[22] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[22].OBUF2  (.A(\REGF[18].RFW.q_wire[22] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[23].FF  (.CLK(\REGF[18].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[18].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[23].OBUF1  (.A(\REGF[18].RFW.q_wire[23] ),
    .TE_B(\REGF[18].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[23].OBUF2  (.A(\REGF[18].RFW.q_wire[23] ),
    .TE_B(\REGF[18].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[24].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[18].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[24].OBUF1  (.A(\REGF[18].RFW.q_wire[24] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[24].OBUF2  (.A(\REGF[18].RFW.q_wire[24] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[25].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[18].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[25].OBUF1  (.A(\REGF[18].RFW.q_wire[25] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[25].OBUF2  (.A(\REGF[18].RFW.q_wire[25] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[26].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[18].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[26].OBUF1  (.A(\REGF[18].RFW.q_wire[26] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[26].OBUF2  (.A(\REGF[18].RFW.q_wire[26] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[27].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[18].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[27].OBUF1  (.A(\REGF[18].RFW.q_wire[27] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[27].OBUF2  (.A(\REGF[18].RFW.q_wire[27] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[28].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[18].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[28].OBUF1  (.A(\REGF[18].RFW.q_wire[28] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[28].OBUF2  (.A(\REGF[18].RFW.q_wire[28] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[29].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[18].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[29].OBUF1  (.A(\REGF[18].RFW.q_wire[29] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[29].OBUF2  (.A(\REGF[18].RFW.q_wire[29] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[2].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[18].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[2].OBUF1  (.A(\REGF[18].RFW.q_wire[2] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[2].OBUF2  (.A(\REGF[18].RFW.q_wire[2] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[30].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[18].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[30].OBUF1  (.A(\REGF[18].RFW.q_wire[30] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[30].OBUF2  (.A(\REGF[18].RFW.q_wire[30] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[31].FF  (.CLK(\REGF[18].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[18].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[31].OBUF1  (.A(\REGF[18].RFW.q_wire[31] ),
    .TE_B(\REGF[18].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[31].OBUF2  (.A(\REGF[18].RFW.q_wire[31] ),
    .TE_B(\REGF[18].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[3].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[18].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[3].OBUF1  (.A(\REGF[18].RFW.q_wire[3] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[3].OBUF2  (.A(\REGF[18].RFW.q_wire[3] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[4].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[18].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[4].OBUF1  (.A(\REGF[18].RFW.q_wire[4] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[4].OBUF2  (.A(\REGF[18].RFW.q_wire[4] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[5].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[18].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[5].OBUF1  (.A(\REGF[18].RFW.q_wire[5] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[5].OBUF2  (.A(\REGF[18].RFW.q_wire[5] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[6].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[18].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[6].OBUF1  (.A(\REGF[18].RFW.q_wire[6] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[6].OBUF2  (.A(\REGF[18].RFW.q_wire[6] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[7].FF  (.CLK(\REGF[18].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[18].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[7].OBUF1  (.A(\REGF[18].RFW.q_wire[7] ),
    .TE_B(\REGF[18].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[7].OBUF2  (.A(\REGF[18].RFW.q_wire[7] ),
    .TE_B(\REGF[18].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[8].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[18].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[8].OBUF1  (.A(\REGF[18].RFW.q_wire[8] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[8].OBUF2  (.A(\REGF[18].RFW.q_wire[8] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[18].RFW.BIT[9].FF  (.CLK(\REGF[18].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[18].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[9].OBUF1  (.A(\REGF[18].RFW.q_wire[9] ),
    .TE_B(\REGF[18].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[18].RFW.BIT[9].OBUF2  (.A(\REGF[18].RFW.q_wire[9] ),
    .TE_B(\REGF[18].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[18].RFW.CGAND  (.A(\DEC2.D2.SEL[2] ),
    .B(WE),
    .X(\REGF[18].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[18].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[18].RFW.we_wire ),
    .GCLK(\REGF[18].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[18].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[18].RFW.we_wire ),
    .GCLK(\REGF[18].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[18].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[18].RFW.we_wire ),
    .GCLK(\REGF[18].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[18].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[18].RFW.we_wire ),
    .GCLK(\REGF[18].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV1[0]  (.A(\DEC0.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV1[1]  (.A(\DEC0.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV1[2]  (.A(\DEC0.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV1[3]  (.A(\DEC0.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV2[0]  (.A(\DEC1.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV2[1]  (.A(\DEC1.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV2[2]  (.A(\DEC1.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[18].RFW.INV2[3]  (.A(\DEC1.D2.SEL[2] ),
    .Y(\REGF[18].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[0].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[19].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[0].OBUF1  (.A(\REGF[19].RFW.q_wire[0] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[0].OBUF2  (.A(\REGF[19].RFW.q_wire[0] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[10].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[19].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[10].OBUF1  (.A(\REGF[19].RFW.q_wire[10] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[10].OBUF2  (.A(\REGF[19].RFW.q_wire[10] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[11].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[19].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[11].OBUF1  (.A(\REGF[19].RFW.q_wire[11] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[11].OBUF2  (.A(\REGF[19].RFW.q_wire[11] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[12].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[19].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[12].OBUF1  (.A(\REGF[19].RFW.q_wire[12] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[12].OBUF2  (.A(\REGF[19].RFW.q_wire[12] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[13].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[19].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[13].OBUF1  (.A(\REGF[19].RFW.q_wire[13] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[13].OBUF2  (.A(\REGF[19].RFW.q_wire[13] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[14].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[19].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[14].OBUF1  (.A(\REGF[19].RFW.q_wire[14] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[14].OBUF2  (.A(\REGF[19].RFW.q_wire[14] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[15].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[19].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[15].OBUF1  (.A(\REGF[19].RFW.q_wire[15] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[15].OBUF2  (.A(\REGF[19].RFW.q_wire[15] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[16].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[19].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[16].OBUF1  (.A(\REGF[19].RFW.q_wire[16] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[16].OBUF2  (.A(\REGF[19].RFW.q_wire[16] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[17].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[19].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[17].OBUF1  (.A(\REGF[19].RFW.q_wire[17] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[17].OBUF2  (.A(\REGF[19].RFW.q_wire[17] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[18].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[19].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[18].OBUF1  (.A(\REGF[19].RFW.q_wire[18] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[18].OBUF2  (.A(\REGF[19].RFW.q_wire[18] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[19].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[19].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[19].OBUF1  (.A(\REGF[19].RFW.q_wire[19] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[19].OBUF2  (.A(\REGF[19].RFW.q_wire[19] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[1].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[19].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[1].OBUF1  (.A(\REGF[19].RFW.q_wire[1] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[1].OBUF2  (.A(\REGF[19].RFW.q_wire[1] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[20].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[19].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[20].OBUF1  (.A(\REGF[19].RFW.q_wire[20] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[20].OBUF2  (.A(\REGF[19].RFW.q_wire[20] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[21].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[19].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[21].OBUF1  (.A(\REGF[19].RFW.q_wire[21] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[21].OBUF2  (.A(\REGF[19].RFW.q_wire[21] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[22].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[19].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[22].OBUF1  (.A(\REGF[19].RFW.q_wire[22] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[22].OBUF2  (.A(\REGF[19].RFW.q_wire[22] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[23].FF  (.CLK(\REGF[19].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[19].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[23].OBUF1  (.A(\REGF[19].RFW.q_wire[23] ),
    .TE_B(\REGF[19].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[23].OBUF2  (.A(\REGF[19].RFW.q_wire[23] ),
    .TE_B(\REGF[19].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[24].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[19].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[24].OBUF1  (.A(\REGF[19].RFW.q_wire[24] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[24].OBUF2  (.A(\REGF[19].RFW.q_wire[24] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[25].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[19].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[25].OBUF1  (.A(\REGF[19].RFW.q_wire[25] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[25].OBUF2  (.A(\REGF[19].RFW.q_wire[25] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[26].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[19].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[26].OBUF1  (.A(\REGF[19].RFW.q_wire[26] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[26].OBUF2  (.A(\REGF[19].RFW.q_wire[26] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[27].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[19].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[27].OBUF1  (.A(\REGF[19].RFW.q_wire[27] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[27].OBUF2  (.A(\REGF[19].RFW.q_wire[27] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[28].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[19].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[28].OBUF1  (.A(\REGF[19].RFW.q_wire[28] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[28].OBUF2  (.A(\REGF[19].RFW.q_wire[28] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[29].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[19].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[29].OBUF1  (.A(\REGF[19].RFW.q_wire[29] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[29].OBUF2  (.A(\REGF[19].RFW.q_wire[29] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[2].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[19].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[2].OBUF1  (.A(\REGF[19].RFW.q_wire[2] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[2].OBUF2  (.A(\REGF[19].RFW.q_wire[2] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[30].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[19].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[30].OBUF1  (.A(\REGF[19].RFW.q_wire[30] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[30].OBUF2  (.A(\REGF[19].RFW.q_wire[30] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[31].FF  (.CLK(\REGF[19].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[19].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[31].OBUF1  (.A(\REGF[19].RFW.q_wire[31] ),
    .TE_B(\REGF[19].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[31].OBUF2  (.A(\REGF[19].RFW.q_wire[31] ),
    .TE_B(\REGF[19].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[3].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[19].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[3].OBUF1  (.A(\REGF[19].RFW.q_wire[3] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[3].OBUF2  (.A(\REGF[19].RFW.q_wire[3] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[4].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[19].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[4].OBUF1  (.A(\REGF[19].RFW.q_wire[4] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[4].OBUF2  (.A(\REGF[19].RFW.q_wire[4] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[5].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[19].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[5].OBUF1  (.A(\REGF[19].RFW.q_wire[5] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[5].OBUF2  (.A(\REGF[19].RFW.q_wire[5] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[6].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[19].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[6].OBUF1  (.A(\REGF[19].RFW.q_wire[6] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[6].OBUF2  (.A(\REGF[19].RFW.q_wire[6] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[7].FF  (.CLK(\REGF[19].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[19].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[7].OBUF1  (.A(\REGF[19].RFW.q_wire[7] ),
    .TE_B(\REGF[19].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[7].OBUF2  (.A(\REGF[19].RFW.q_wire[7] ),
    .TE_B(\REGF[19].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[8].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[19].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[8].OBUF1  (.A(\REGF[19].RFW.q_wire[8] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[8].OBUF2  (.A(\REGF[19].RFW.q_wire[8] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[19].RFW.BIT[9].FF  (.CLK(\REGF[19].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[19].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[9].OBUF1  (.A(\REGF[19].RFW.q_wire[9] ),
    .TE_B(\REGF[19].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[19].RFW.BIT[9].OBUF2  (.A(\REGF[19].RFW.q_wire[9] ),
    .TE_B(\REGF[19].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[19].RFW.CGAND  (.A(\DEC2.D2.SEL[3] ),
    .B(WE),
    .X(\REGF[19].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[19].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[19].RFW.we_wire ),
    .GCLK(\REGF[19].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[19].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[19].RFW.we_wire ),
    .GCLK(\REGF[19].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[19].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[19].RFW.we_wire ),
    .GCLK(\REGF[19].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[19].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[19].RFW.we_wire ),
    .GCLK(\REGF[19].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV1[0]  (.A(\DEC0.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV1[1]  (.A(\DEC0.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV1[2]  (.A(\DEC0.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV1[3]  (.A(\DEC0.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV2[0]  (.A(\DEC1.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV2[1]  (.A(\DEC1.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV2[2]  (.A(\DEC1.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[19].RFW.INV2[3]  (.A(\DEC1.D2.SEL[3] ),
    .Y(\REGF[19].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[0].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[1].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[0].OBUF1  (.A(\REGF[1].RFW.q_wire[0] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[0].OBUF2  (.A(\REGF[1].RFW.q_wire[0] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[10].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[1].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[10].OBUF1  (.A(\REGF[1].RFW.q_wire[10] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[10].OBUF2  (.A(\REGF[1].RFW.q_wire[10] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[11].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[1].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[11].OBUF1  (.A(\REGF[1].RFW.q_wire[11] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[11].OBUF2  (.A(\REGF[1].RFW.q_wire[11] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[12].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[1].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[12].OBUF1  (.A(\REGF[1].RFW.q_wire[12] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[12].OBUF2  (.A(\REGF[1].RFW.q_wire[12] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[13].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[1].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[13].OBUF1  (.A(\REGF[1].RFW.q_wire[13] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[13].OBUF2  (.A(\REGF[1].RFW.q_wire[13] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[14].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[1].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[14].OBUF1  (.A(\REGF[1].RFW.q_wire[14] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[14].OBUF2  (.A(\REGF[1].RFW.q_wire[14] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[15].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[1].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[15].OBUF1  (.A(\REGF[1].RFW.q_wire[15] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[15].OBUF2  (.A(\REGF[1].RFW.q_wire[15] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[16].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[1].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[16].OBUF1  (.A(\REGF[1].RFW.q_wire[16] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[16].OBUF2  (.A(\REGF[1].RFW.q_wire[16] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[17].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[1].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[17].OBUF1  (.A(\REGF[1].RFW.q_wire[17] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[17].OBUF2  (.A(\REGF[1].RFW.q_wire[17] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[18].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[1].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[18].OBUF1  (.A(\REGF[1].RFW.q_wire[18] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[18].OBUF2  (.A(\REGF[1].RFW.q_wire[18] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[19].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[1].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[19].OBUF1  (.A(\REGF[1].RFW.q_wire[19] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[19].OBUF2  (.A(\REGF[1].RFW.q_wire[19] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[1].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[1].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[1].OBUF1  (.A(\REGF[1].RFW.q_wire[1] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[1].OBUF2  (.A(\REGF[1].RFW.q_wire[1] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[20].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[1].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[20].OBUF1  (.A(\REGF[1].RFW.q_wire[20] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[20].OBUF2  (.A(\REGF[1].RFW.q_wire[20] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[21].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[1].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[21].OBUF1  (.A(\REGF[1].RFW.q_wire[21] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[21].OBUF2  (.A(\REGF[1].RFW.q_wire[21] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[22].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[1].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[22].OBUF1  (.A(\REGF[1].RFW.q_wire[22] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[22].OBUF2  (.A(\REGF[1].RFW.q_wire[22] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[23].FF  (.CLK(\REGF[1].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[1].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[23].OBUF1  (.A(\REGF[1].RFW.q_wire[23] ),
    .TE_B(\REGF[1].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[23].OBUF2  (.A(\REGF[1].RFW.q_wire[23] ),
    .TE_B(\REGF[1].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[24].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[1].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[24].OBUF1  (.A(\REGF[1].RFW.q_wire[24] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[24].OBUF2  (.A(\REGF[1].RFW.q_wire[24] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[25].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[1].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[25].OBUF1  (.A(\REGF[1].RFW.q_wire[25] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[25].OBUF2  (.A(\REGF[1].RFW.q_wire[25] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[26].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[1].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[26].OBUF1  (.A(\REGF[1].RFW.q_wire[26] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[26].OBUF2  (.A(\REGF[1].RFW.q_wire[26] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[27].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[1].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[27].OBUF1  (.A(\REGF[1].RFW.q_wire[27] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[27].OBUF2  (.A(\REGF[1].RFW.q_wire[27] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[28].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[1].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[28].OBUF1  (.A(\REGF[1].RFW.q_wire[28] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[28].OBUF2  (.A(\REGF[1].RFW.q_wire[28] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[29].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[1].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[29].OBUF1  (.A(\REGF[1].RFW.q_wire[29] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[29].OBUF2  (.A(\REGF[1].RFW.q_wire[29] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[2].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[1].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[2].OBUF1  (.A(\REGF[1].RFW.q_wire[2] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[2].OBUF2  (.A(\REGF[1].RFW.q_wire[2] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[30].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[1].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[30].OBUF1  (.A(\REGF[1].RFW.q_wire[30] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[30].OBUF2  (.A(\REGF[1].RFW.q_wire[30] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[31].FF  (.CLK(\REGF[1].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[1].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[31].OBUF1  (.A(\REGF[1].RFW.q_wire[31] ),
    .TE_B(\REGF[1].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[31].OBUF2  (.A(\REGF[1].RFW.q_wire[31] ),
    .TE_B(\REGF[1].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[3].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[1].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[3].OBUF1  (.A(\REGF[1].RFW.q_wire[3] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[3].OBUF2  (.A(\REGF[1].RFW.q_wire[3] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[4].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[1].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[4].OBUF1  (.A(\REGF[1].RFW.q_wire[4] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[4].OBUF2  (.A(\REGF[1].RFW.q_wire[4] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[5].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[1].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[5].OBUF1  (.A(\REGF[1].RFW.q_wire[5] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[5].OBUF2  (.A(\REGF[1].RFW.q_wire[5] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[6].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[1].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[6].OBUF1  (.A(\REGF[1].RFW.q_wire[6] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[6].OBUF2  (.A(\REGF[1].RFW.q_wire[6] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[7].FF  (.CLK(\REGF[1].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[1].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[7].OBUF1  (.A(\REGF[1].RFW.q_wire[7] ),
    .TE_B(\REGF[1].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[7].OBUF2  (.A(\REGF[1].RFW.q_wire[7] ),
    .TE_B(\REGF[1].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[8].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[1].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[8].OBUF1  (.A(\REGF[1].RFW.q_wire[8] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[8].OBUF2  (.A(\REGF[1].RFW.q_wire[8] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[1].RFW.BIT[9].FF  (.CLK(\REGF[1].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[1].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[9].OBUF1  (.A(\REGF[1].RFW.q_wire[9] ),
    .TE_B(\REGF[1].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[1].RFW.BIT[9].OBUF2  (.A(\REGF[1].RFW.q_wire[9] ),
    .TE_B(\REGF[1].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[1].RFW.CGAND  (.A(\DEC2.D0.SEL[1] ),
    .B(WE),
    .X(\REGF[1].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[1].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[1].RFW.we_wire ),
    .GCLK(\REGF[1].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[1].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[1].RFW.we_wire ),
    .GCLK(\REGF[1].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[1].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[1].RFW.we_wire ),
    .GCLK(\REGF[1].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[1].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[1].RFW.we_wire ),
    .GCLK(\REGF[1].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV1[0]  (.A(\DEC0.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV1[1]  (.A(\DEC0.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV1[2]  (.A(\DEC0.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV1[3]  (.A(\DEC0.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV2[0]  (.A(\DEC1.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV2[1]  (.A(\DEC1.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV2[2]  (.A(\DEC1.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[1].RFW.INV2[3]  (.A(\DEC1.D0.SEL[1] ),
    .Y(\REGF[1].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[0].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[20].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[0].OBUF1  (.A(\REGF[20].RFW.q_wire[0] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[0].OBUF2  (.A(\REGF[20].RFW.q_wire[0] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[10].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[20].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[10].OBUF1  (.A(\REGF[20].RFW.q_wire[10] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[10].OBUF2  (.A(\REGF[20].RFW.q_wire[10] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[11].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[20].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[11].OBUF1  (.A(\REGF[20].RFW.q_wire[11] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[11].OBUF2  (.A(\REGF[20].RFW.q_wire[11] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[12].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[20].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[12].OBUF1  (.A(\REGF[20].RFW.q_wire[12] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[12].OBUF2  (.A(\REGF[20].RFW.q_wire[12] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[13].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[20].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[13].OBUF1  (.A(\REGF[20].RFW.q_wire[13] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[13].OBUF2  (.A(\REGF[20].RFW.q_wire[13] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[14].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[20].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[14].OBUF1  (.A(\REGF[20].RFW.q_wire[14] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[14].OBUF2  (.A(\REGF[20].RFW.q_wire[14] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[15].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[20].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[15].OBUF1  (.A(\REGF[20].RFW.q_wire[15] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[15].OBUF2  (.A(\REGF[20].RFW.q_wire[15] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[16].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[20].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[16].OBUF1  (.A(\REGF[20].RFW.q_wire[16] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[16].OBUF2  (.A(\REGF[20].RFW.q_wire[16] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[17].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[20].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[17].OBUF1  (.A(\REGF[20].RFW.q_wire[17] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[17].OBUF2  (.A(\REGF[20].RFW.q_wire[17] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[18].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[20].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[18].OBUF1  (.A(\REGF[20].RFW.q_wire[18] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[18].OBUF2  (.A(\REGF[20].RFW.q_wire[18] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[19].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[20].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[19].OBUF1  (.A(\REGF[20].RFW.q_wire[19] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[19].OBUF2  (.A(\REGF[20].RFW.q_wire[19] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[1].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[20].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[1].OBUF1  (.A(\REGF[20].RFW.q_wire[1] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[1].OBUF2  (.A(\REGF[20].RFW.q_wire[1] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[20].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[20].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[20].OBUF1  (.A(\REGF[20].RFW.q_wire[20] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[20].OBUF2  (.A(\REGF[20].RFW.q_wire[20] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[21].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[20].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[21].OBUF1  (.A(\REGF[20].RFW.q_wire[21] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[21].OBUF2  (.A(\REGF[20].RFW.q_wire[21] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[22].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[20].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[22].OBUF1  (.A(\REGF[20].RFW.q_wire[22] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[22].OBUF2  (.A(\REGF[20].RFW.q_wire[22] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[23].FF  (.CLK(\REGF[20].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[20].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[23].OBUF1  (.A(\REGF[20].RFW.q_wire[23] ),
    .TE_B(\REGF[20].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[23].OBUF2  (.A(\REGF[20].RFW.q_wire[23] ),
    .TE_B(\REGF[20].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[24].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[20].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[24].OBUF1  (.A(\REGF[20].RFW.q_wire[24] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[24].OBUF2  (.A(\REGF[20].RFW.q_wire[24] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[25].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[20].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[25].OBUF1  (.A(\REGF[20].RFW.q_wire[25] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[25].OBUF2  (.A(\REGF[20].RFW.q_wire[25] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[26].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[20].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[26].OBUF1  (.A(\REGF[20].RFW.q_wire[26] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[26].OBUF2  (.A(\REGF[20].RFW.q_wire[26] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[27].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[20].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[27].OBUF1  (.A(\REGF[20].RFW.q_wire[27] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[27].OBUF2  (.A(\REGF[20].RFW.q_wire[27] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[28].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[20].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[28].OBUF1  (.A(\REGF[20].RFW.q_wire[28] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[28].OBUF2  (.A(\REGF[20].RFW.q_wire[28] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[29].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[20].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[29].OBUF1  (.A(\REGF[20].RFW.q_wire[29] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[29].OBUF2  (.A(\REGF[20].RFW.q_wire[29] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[2].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[20].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[2].OBUF1  (.A(\REGF[20].RFW.q_wire[2] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[2].OBUF2  (.A(\REGF[20].RFW.q_wire[2] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[30].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[20].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[30].OBUF1  (.A(\REGF[20].RFW.q_wire[30] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[30].OBUF2  (.A(\REGF[20].RFW.q_wire[30] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[31].FF  (.CLK(\REGF[20].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[20].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[31].OBUF1  (.A(\REGF[20].RFW.q_wire[31] ),
    .TE_B(\REGF[20].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[31].OBUF2  (.A(\REGF[20].RFW.q_wire[31] ),
    .TE_B(\REGF[20].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[3].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[20].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[3].OBUF1  (.A(\REGF[20].RFW.q_wire[3] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[3].OBUF2  (.A(\REGF[20].RFW.q_wire[3] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[4].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[20].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[4].OBUF1  (.A(\REGF[20].RFW.q_wire[4] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[4].OBUF2  (.A(\REGF[20].RFW.q_wire[4] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[5].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[20].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[5].OBUF1  (.A(\REGF[20].RFW.q_wire[5] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[5].OBUF2  (.A(\REGF[20].RFW.q_wire[5] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[6].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[20].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[6].OBUF1  (.A(\REGF[20].RFW.q_wire[6] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[6].OBUF2  (.A(\REGF[20].RFW.q_wire[6] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[7].FF  (.CLK(\REGF[20].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[20].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[7].OBUF1  (.A(\REGF[20].RFW.q_wire[7] ),
    .TE_B(\REGF[20].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[7].OBUF2  (.A(\REGF[20].RFW.q_wire[7] ),
    .TE_B(\REGF[20].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[8].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[20].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[8].OBUF1  (.A(\REGF[20].RFW.q_wire[8] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[8].OBUF2  (.A(\REGF[20].RFW.q_wire[8] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[20].RFW.BIT[9].FF  (.CLK(\REGF[20].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[20].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[9].OBUF1  (.A(\REGF[20].RFW.q_wire[9] ),
    .TE_B(\REGF[20].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[20].RFW.BIT[9].OBUF2  (.A(\REGF[20].RFW.q_wire[9] ),
    .TE_B(\REGF[20].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[20].RFW.CGAND  (.A(\DEC2.D2.SEL[4] ),
    .B(WE),
    .X(\REGF[20].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[20].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[20].RFW.we_wire ),
    .GCLK(\REGF[20].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[20].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[20].RFW.we_wire ),
    .GCLK(\REGF[20].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[20].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[20].RFW.we_wire ),
    .GCLK(\REGF[20].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[20].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[20].RFW.we_wire ),
    .GCLK(\REGF[20].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV1[0]  (.A(\DEC0.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV1[1]  (.A(\DEC0.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV1[2]  (.A(\DEC0.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV1[3]  (.A(\DEC0.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV2[0]  (.A(\DEC1.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV2[1]  (.A(\DEC1.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV2[2]  (.A(\DEC1.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[20].RFW.INV2[3]  (.A(\DEC1.D2.SEL[4] ),
    .Y(\REGF[20].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[0].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[21].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[0].OBUF1  (.A(\REGF[21].RFW.q_wire[0] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[0].OBUF2  (.A(\REGF[21].RFW.q_wire[0] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[10].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[21].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[10].OBUF1  (.A(\REGF[21].RFW.q_wire[10] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[10].OBUF2  (.A(\REGF[21].RFW.q_wire[10] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[11].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[21].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[11].OBUF1  (.A(\REGF[21].RFW.q_wire[11] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[11].OBUF2  (.A(\REGF[21].RFW.q_wire[11] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[12].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[21].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[12].OBUF1  (.A(\REGF[21].RFW.q_wire[12] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[12].OBUF2  (.A(\REGF[21].RFW.q_wire[12] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[13].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[21].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[13].OBUF1  (.A(\REGF[21].RFW.q_wire[13] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[13].OBUF2  (.A(\REGF[21].RFW.q_wire[13] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[14].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[21].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[14].OBUF1  (.A(\REGF[21].RFW.q_wire[14] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[14].OBUF2  (.A(\REGF[21].RFW.q_wire[14] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[15].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[21].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[15].OBUF1  (.A(\REGF[21].RFW.q_wire[15] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[15].OBUF2  (.A(\REGF[21].RFW.q_wire[15] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[16].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[21].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[16].OBUF1  (.A(\REGF[21].RFW.q_wire[16] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[16].OBUF2  (.A(\REGF[21].RFW.q_wire[16] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[17].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[21].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[17].OBUF1  (.A(\REGF[21].RFW.q_wire[17] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[17].OBUF2  (.A(\REGF[21].RFW.q_wire[17] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[18].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[21].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[18].OBUF1  (.A(\REGF[21].RFW.q_wire[18] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[18].OBUF2  (.A(\REGF[21].RFW.q_wire[18] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[19].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[21].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[19].OBUF1  (.A(\REGF[21].RFW.q_wire[19] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[19].OBUF2  (.A(\REGF[21].RFW.q_wire[19] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[1].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[21].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[1].OBUF1  (.A(\REGF[21].RFW.q_wire[1] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[1].OBUF2  (.A(\REGF[21].RFW.q_wire[1] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[20].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[21].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[20].OBUF1  (.A(\REGF[21].RFW.q_wire[20] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[20].OBUF2  (.A(\REGF[21].RFW.q_wire[20] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[21].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[21].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[21].OBUF1  (.A(\REGF[21].RFW.q_wire[21] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[21].OBUF2  (.A(\REGF[21].RFW.q_wire[21] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[22].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[21].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[22].OBUF1  (.A(\REGF[21].RFW.q_wire[22] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[22].OBUF2  (.A(\REGF[21].RFW.q_wire[22] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[23].FF  (.CLK(\REGF[21].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[21].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[23].OBUF1  (.A(\REGF[21].RFW.q_wire[23] ),
    .TE_B(\REGF[21].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[23].OBUF2  (.A(\REGF[21].RFW.q_wire[23] ),
    .TE_B(\REGF[21].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[24].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[21].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[24].OBUF1  (.A(\REGF[21].RFW.q_wire[24] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[24].OBUF2  (.A(\REGF[21].RFW.q_wire[24] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[25].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[21].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[25].OBUF1  (.A(\REGF[21].RFW.q_wire[25] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[25].OBUF2  (.A(\REGF[21].RFW.q_wire[25] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[26].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[21].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[26].OBUF1  (.A(\REGF[21].RFW.q_wire[26] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[26].OBUF2  (.A(\REGF[21].RFW.q_wire[26] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[27].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[21].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[27].OBUF1  (.A(\REGF[21].RFW.q_wire[27] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[27].OBUF2  (.A(\REGF[21].RFW.q_wire[27] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[28].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[21].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[28].OBUF1  (.A(\REGF[21].RFW.q_wire[28] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[28].OBUF2  (.A(\REGF[21].RFW.q_wire[28] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[29].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[21].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[29].OBUF1  (.A(\REGF[21].RFW.q_wire[29] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[29].OBUF2  (.A(\REGF[21].RFW.q_wire[29] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[2].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[21].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[2].OBUF1  (.A(\REGF[21].RFW.q_wire[2] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[2].OBUF2  (.A(\REGF[21].RFW.q_wire[2] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[30].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[21].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[30].OBUF1  (.A(\REGF[21].RFW.q_wire[30] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[30].OBUF2  (.A(\REGF[21].RFW.q_wire[30] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[31].FF  (.CLK(\REGF[21].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[21].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[31].OBUF1  (.A(\REGF[21].RFW.q_wire[31] ),
    .TE_B(\REGF[21].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[31].OBUF2  (.A(\REGF[21].RFW.q_wire[31] ),
    .TE_B(\REGF[21].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[3].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[21].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[3].OBUF1  (.A(\REGF[21].RFW.q_wire[3] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[3].OBUF2  (.A(\REGF[21].RFW.q_wire[3] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[4].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[21].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[4].OBUF1  (.A(\REGF[21].RFW.q_wire[4] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[4].OBUF2  (.A(\REGF[21].RFW.q_wire[4] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[5].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[21].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[5].OBUF1  (.A(\REGF[21].RFW.q_wire[5] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[5].OBUF2  (.A(\REGF[21].RFW.q_wire[5] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[6].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[21].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[6].OBUF1  (.A(\REGF[21].RFW.q_wire[6] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[6].OBUF2  (.A(\REGF[21].RFW.q_wire[6] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[7].FF  (.CLK(\REGF[21].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[21].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[7].OBUF1  (.A(\REGF[21].RFW.q_wire[7] ),
    .TE_B(\REGF[21].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[7].OBUF2  (.A(\REGF[21].RFW.q_wire[7] ),
    .TE_B(\REGF[21].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[8].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[21].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[8].OBUF1  (.A(\REGF[21].RFW.q_wire[8] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[8].OBUF2  (.A(\REGF[21].RFW.q_wire[8] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[21].RFW.BIT[9].FF  (.CLK(\REGF[21].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[21].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[9].OBUF1  (.A(\REGF[21].RFW.q_wire[9] ),
    .TE_B(\REGF[21].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[21].RFW.BIT[9].OBUF2  (.A(\REGF[21].RFW.q_wire[9] ),
    .TE_B(\REGF[21].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[21].RFW.CGAND  (.A(\DEC2.D2.SEL[5] ),
    .B(WE),
    .X(\REGF[21].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[21].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[21].RFW.we_wire ),
    .GCLK(\REGF[21].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[21].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[21].RFW.we_wire ),
    .GCLK(\REGF[21].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[21].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[21].RFW.we_wire ),
    .GCLK(\REGF[21].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[21].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[21].RFW.we_wire ),
    .GCLK(\REGF[21].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV1[0]  (.A(\DEC0.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV1[1]  (.A(\DEC0.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV1[2]  (.A(\DEC0.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV1[3]  (.A(\DEC0.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV2[0]  (.A(\DEC1.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV2[1]  (.A(\DEC1.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV2[2]  (.A(\DEC1.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[21].RFW.INV2[3]  (.A(\DEC1.D2.SEL[5] ),
    .Y(\REGF[21].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[0].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[22].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[0].OBUF1  (.A(\REGF[22].RFW.q_wire[0] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[0].OBUF2  (.A(\REGF[22].RFW.q_wire[0] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[10].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[22].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[10].OBUF1  (.A(\REGF[22].RFW.q_wire[10] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[10].OBUF2  (.A(\REGF[22].RFW.q_wire[10] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[11].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[22].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[11].OBUF1  (.A(\REGF[22].RFW.q_wire[11] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[11].OBUF2  (.A(\REGF[22].RFW.q_wire[11] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[12].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[22].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[12].OBUF1  (.A(\REGF[22].RFW.q_wire[12] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[12].OBUF2  (.A(\REGF[22].RFW.q_wire[12] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[13].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[22].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[13].OBUF1  (.A(\REGF[22].RFW.q_wire[13] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[13].OBUF2  (.A(\REGF[22].RFW.q_wire[13] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[14].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[22].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[14].OBUF1  (.A(\REGF[22].RFW.q_wire[14] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[14].OBUF2  (.A(\REGF[22].RFW.q_wire[14] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[15].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[22].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[15].OBUF1  (.A(\REGF[22].RFW.q_wire[15] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[15].OBUF2  (.A(\REGF[22].RFW.q_wire[15] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[16].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[22].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[16].OBUF1  (.A(\REGF[22].RFW.q_wire[16] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[16].OBUF2  (.A(\REGF[22].RFW.q_wire[16] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[17].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[22].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[17].OBUF1  (.A(\REGF[22].RFW.q_wire[17] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[17].OBUF2  (.A(\REGF[22].RFW.q_wire[17] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[18].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[22].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[18].OBUF1  (.A(\REGF[22].RFW.q_wire[18] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[18].OBUF2  (.A(\REGF[22].RFW.q_wire[18] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[19].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[22].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[19].OBUF1  (.A(\REGF[22].RFW.q_wire[19] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[19].OBUF2  (.A(\REGF[22].RFW.q_wire[19] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[1].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[22].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[1].OBUF1  (.A(\REGF[22].RFW.q_wire[1] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[1].OBUF2  (.A(\REGF[22].RFW.q_wire[1] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[20].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[22].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[20].OBUF1  (.A(\REGF[22].RFW.q_wire[20] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[20].OBUF2  (.A(\REGF[22].RFW.q_wire[20] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[21].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[22].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[21].OBUF1  (.A(\REGF[22].RFW.q_wire[21] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[21].OBUF2  (.A(\REGF[22].RFW.q_wire[21] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[22].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[22].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[22].OBUF1  (.A(\REGF[22].RFW.q_wire[22] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[22].OBUF2  (.A(\REGF[22].RFW.q_wire[22] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[23].FF  (.CLK(\REGF[22].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[22].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[23].OBUF1  (.A(\REGF[22].RFW.q_wire[23] ),
    .TE_B(\REGF[22].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[23].OBUF2  (.A(\REGF[22].RFW.q_wire[23] ),
    .TE_B(\REGF[22].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[24].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[22].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[24].OBUF1  (.A(\REGF[22].RFW.q_wire[24] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[24].OBUF2  (.A(\REGF[22].RFW.q_wire[24] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[25].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[22].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[25].OBUF1  (.A(\REGF[22].RFW.q_wire[25] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[25].OBUF2  (.A(\REGF[22].RFW.q_wire[25] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[26].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[22].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[26].OBUF1  (.A(\REGF[22].RFW.q_wire[26] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[26].OBUF2  (.A(\REGF[22].RFW.q_wire[26] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[27].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[22].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[27].OBUF1  (.A(\REGF[22].RFW.q_wire[27] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[27].OBUF2  (.A(\REGF[22].RFW.q_wire[27] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[28].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[22].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[28].OBUF1  (.A(\REGF[22].RFW.q_wire[28] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[28].OBUF2  (.A(\REGF[22].RFW.q_wire[28] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[29].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[22].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[29].OBUF1  (.A(\REGF[22].RFW.q_wire[29] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[29].OBUF2  (.A(\REGF[22].RFW.q_wire[29] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[2].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[22].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[2].OBUF1  (.A(\REGF[22].RFW.q_wire[2] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[2].OBUF2  (.A(\REGF[22].RFW.q_wire[2] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[30].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[22].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[30].OBUF1  (.A(\REGF[22].RFW.q_wire[30] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[30].OBUF2  (.A(\REGF[22].RFW.q_wire[30] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[31].FF  (.CLK(\REGF[22].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[22].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[31].OBUF1  (.A(\REGF[22].RFW.q_wire[31] ),
    .TE_B(\REGF[22].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[31].OBUF2  (.A(\REGF[22].RFW.q_wire[31] ),
    .TE_B(\REGF[22].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[3].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[22].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[3].OBUF1  (.A(\REGF[22].RFW.q_wire[3] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[3].OBUF2  (.A(\REGF[22].RFW.q_wire[3] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[4].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[22].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[4].OBUF1  (.A(\REGF[22].RFW.q_wire[4] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[4].OBUF2  (.A(\REGF[22].RFW.q_wire[4] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[5].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[22].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[5].OBUF1  (.A(\REGF[22].RFW.q_wire[5] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[5].OBUF2  (.A(\REGF[22].RFW.q_wire[5] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[6].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[22].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[6].OBUF1  (.A(\REGF[22].RFW.q_wire[6] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[6].OBUF2  (.A(\REGF[22].RFW.q_wire[6] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[7].FF  (.CLK(\REGF[22].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[22].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[7].OBUF1  (.A(\REGF[22].RFW.q_wire[7] ),
    .TE_B(\REGF[22].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[7].OBUF2  (.A(\REGF[22].RFW.q_wire[7] ),
    .TE_B(\REGF[22].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[8].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[22].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[8].OBUF1  (.A(\REGF[22].RFW.q_wire[8] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[8].OBUF2  (.A(\REGF[22].RFW.q_wire[8] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[22].RFW.BIT[9].FF  (.CLK(\REGF[22].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[22].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[9].OBUF1  (.A(\REGF[22].RFW.q_wire[9] ),
    .TE_B(\REGF[22].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[22].RFW.BIT[9].OBUF2  (.A(\REGF[22].RFW.q_wire[9] ),
    .TE_B(\REGF[22].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[22].RFW.CGAND  (.A(\DEC2.D2.SEL[6] ),
    .B(WE),
    .X(\REGF[22].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[22].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[22].RFW.we_wire ),
    .GCLK(\REGF[22].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[22].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[22].RFW.we_wire ),
    .GCLK(\REGF[22].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[22].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[22].RFW.we_wire ),
    .GCLK(\REGF[22].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[22].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[22].RFW.we_wire ),
    .GCLK(\REGF[22].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV1[0]  (.A(\DEC0.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV1[1]  (.A(\DEC0.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV1[2]  (.A(\DEC0.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV1[3]  (.A(\DEC0.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV2[0]  (.A(\DEC1.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV2[1]  (.A(\DEC1.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV2[2]  (.A(\DEC1.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[22].RFW.INV2[3]  (.A(\DEC1.D2.SEL[6] ),
    .Y(\REGF[22].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[0].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[23].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[0].OBUF1  (.A(\REGF[23].RFW.q_wire[0] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[0].OBUF2  (.A(\REGF[23].RFW.q_wire[0] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[10].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[23].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[10].OBUF1  (.A(\REGF[23].RFW.q_wire[10] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[10].OBUF2  (.A(\REGF[23].RFW.q_wire[10] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[11].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[23].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[11].OBUF1  (.A(\REGF[23].RFW.q_wire[11] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[11].OBUF2  (.A(\REGF[23].RFW.q_wire[11] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[12].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[23].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[12].OBUF1  (.A(\REGF[23].RFW.q_wire[12] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[12].OBUF2  (.A(\REGF[23].RFW.q_wire[12] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[13].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[23].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[13].OBUF1  (.A(\REGF[23].RFW.q_wire[13] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[13].OBUF2  (.A(\REGF[23].RFW.q_wire[13] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[14].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[23].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[14].OBUF1  (.A(\REGF[23].RFW.q_wire[14] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[14].OBUF2  (.A(\REGF[23].RFW.q_wire[14] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[15].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[23].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[15].OBUF1  (.A(\REGF[23].RFW.q_wire[15] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[15].OBUF2  (.A(\REGF[23].RFW.q_wire[15] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[16].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[23].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[16].OBUF1  (.A(\REGF[23].RFW.q_wire[16] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[16].OBUF2  (.A(\REGF[23].RFW.q_wire[16] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[17].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[23].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[17].OBUF1  (.A(\REGF[23].RFW.q_wire[17] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[17].OBUF2  (.A(\REGF[23].RFW.q_wire[17] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[18].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[23].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[18].OBUF1  (.A(\REGF[23].RFW.q_wire[18] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[18].OBUF2  (.A(\REGF[23].RFW.q_wire[18] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[19].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[23].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[19].OBUF1  (.A(\REGF[23].RFW.q_wire[19] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[19].OBUF2  (.A(\REGF[23].RFW.q_wire[19] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[1].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[23].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[1].OBUF1  (.A(\REGF[23].RFW.q_wire[1] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[1].OBUF2  (.A(\REGF[23].RFW.q_wire[1] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[20].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[23].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[20].OBUF1  (.A(\REGF[23].RFW.q_wire[20] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[20].OBUF2  (.A(\REGF[23].RFW.q_wire[20] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[21].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[23].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[21].OBUF1  (.A(\REGF[23].RFW.q_wire[21] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[21].OBUF2  (.A(\REGF[23].RFW.q_wire[21] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[22].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[23].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[22].OBUF1  (.A(\REGF[23].RFW.q_wire[22] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[22].OBUF2  (.A(\REGF[23].RFW.q_wire[22] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[23].FF  (.CLK(\REGF[23].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[23].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[23].OBUF1  (.A(\REGF[23].RFW.q_wire[23] ),
    .TE_B(\REGF[23].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[23].OBUF2  (.A(\REGF[23].RFW.q_wire[23] ),
    .TE_B(\REGF[23].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[24].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[23].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[24].OBUF1  (.A(\REGF[23].RFW.q_wire[24] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[24].OBUF2  (.A(\REGF[23].RFW.q_wire[24] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[25].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[23].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[25].OBUF1  (.A(\REGF[23].RFW.q_wire[25] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[25].OBUF2  (.A(\REGF[23].RFW.q_wire[25] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[26].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[23].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[26].OBUF1  (.A(\REGF[23].RFW.q_wire[26] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[26].OBUF2  (.A(\REGF[23].RFW.q_wire[26] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[27].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[23].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[27].OBUF1  (.A(\REGF[23].RFW.q_wire[27] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[27].OBUF2  (.A(\REGF[23].RFW.q_wire[27] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[28].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[23].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[28].OBUF1  (.A(\REGF[23].RFW.q_wire[28] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[28].OBUF2  (.A(\REGF[23].RFW.q_wire[28] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[29].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[23].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[29].OBUF1  (.A(\REGF[23].RFW.q_wire[29] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[29].OBUF2  (.A(\REGF[23].RFW.q_wire[29] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[2].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[23].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[2].OBUF1  (.A(\REGF[23].RFW.q_wire[2] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[2].OBUF2  (.A(\REGF[23].RFW.q_wire[2] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[30].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[23].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[30].OBUF1  (.A(\REGF[23].RFW.q_wire[30] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[30].OBUF2  (.A(\REGF[23].RFW.q_wire[30] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[31].FF  (.CLK(\REGF[23].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[23].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[31].OBUF1  (.A(\REGF[23].RFW.q_wire[31] ),
    .TE_B(\REGF[23].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[31].OBUF2  (.A(\REGF[23].RFW.q_wire[31] ),
    .TE_B(\REGF[23].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[3].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[23].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[3].OBUF1  (.A(\REGF[23].RFW.q_wire[3] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[3].OBUF2  (.A(\REGF[23].RFW.q_wire[3] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[4].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[23].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[4].OBUF1  (.A(\REGF[23].RFW.q_wire[4] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[4].OBUF2  (.A(\REGF[23].RFW.q_wire[4] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[5].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[23].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[5].OBUF1  (.A(\REGF[23].RFW.q_wire[5] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[5].OBUF2  (.A(\REGF[23].RFW.q_wire[5] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[6].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[23].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[6].OBUF1  (.A(\REGF[23].RFW.q_wire[6] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[6].OBUF2  (.A(\REGF[23].RFW.q_wire[6] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[7].FF  (.CLK(\REGF[23].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[23].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[7].OBUF1  (.A(\REGF[23].RFW.q_wire[7] ),
    .TE_B(\REGF[23].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[7].OBUF2  (.A(\REGF[23].RFW.q_wire[7] ),
    .TE_B(\REGF[23].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[8].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[23].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[8].OBUF1  (.A(\REGF[23].RFW.q_wire[8] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[8].OBUF2  (.A(\REGF[23].RFW.q_wire[8] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[23].RFW.BIT[9].FF  (.CLK(\REGF[23].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[23].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[9].OBUF1  (.A(\REGF[23].RFW.q_wire[9] ),
    .TE_B(\REGF[23].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[23].RFW.BIT[9].OBUF2  (.A(\REGF[23].RFW.q_wire[9] ),
    .TE_B(\REGF[23].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[23].RFW.CGAND  (.A(\DEC2.D2.SEL[7] ),
    .B(WE),
    .X(\REGF[23].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[23].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[23].RFW.we_wire ),
    .GCLK(\REGF[23].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[23].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[23].RFW.we_wire ),
    .GCLK(\REGF[23].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[23].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[23].RFW.we_wire ),
    .GCLK(\REGF[23].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[23].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[23].RFW.we_wire ),
    .GCLK(\REGF[23].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV1[0]  (.A(\DEC0.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV1[1]  (.A(\DEC0.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV1[2]  (.A(\DEC0.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV1[3]  (.A(\DEC0.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV2[0]  (.A(\DEC1.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV2[1]  (.A(\DEC1.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV2[2]  (.A(\DEC1.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[23].RFW.INV2[3]  (.A(\DEC1.D2.SEL[7] ),
    .Y(\REGF[23].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[0].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[24].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[0].OBUF1  (.A(\REGF[24].RFW.q_wire[0] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[0].OBUF2  (.A(\REGF[24].RFW.q_wire[0] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[10].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[24].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[10].OBUF1  (.A(\REGF[24].RFW.q_wire[10] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[10].OBUF2  (.A(\REGF[24].RFW.q_wire[10] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[11].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[24].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[11].OBUF1  (.A(\REGF[24].RFW.q_wire[11] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[11].OBUF2  (.A(\REGF[24].RFW.q_wire[11] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[12].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[24].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[12].OBUF1  (.A(\REGF[24].RFW.q_wire[12] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[12].OBUF2  (.A(\REGF[24].RFW.q_wire[12] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[13].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[24].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[13].OBUF1  (.A(\REGF[24].RFW.q_wire[13] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[13].OBUF2  (.A(\REGF[24].RFW.q_wire[13] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[14].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[24].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[14].OBUF1  (.A(\REGF[24].RFW.q_wire[14] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[14].OBUF2  (.A(\REGF[24].RFW.q_wire[14] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[15].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[24].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[15].OBUF1  (.A(\REGF[24].RFW.q_wire[15] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[15].OBUF2  (.A(\REGF[24].RFW.q_wire[15] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[16].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[24].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[16].OBUF1  (.A(\REGF[24].RFW.q_wire[16] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[16].OBUF2  (.A(\REGF[24].RFW.q_wire[16] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[17].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[24].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[17].OBUF1  (.A(\REGF[24].RFW.q_wire[17] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[17].OBUF2  (.A(\REGF[24].RFW.q_wire[17] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[18].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[24].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[18].OBUF1  (.A(\REGF[24].RFW.q_wire[18] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[18].OBUF2  (.A(\REGF[24].RFW.q_wire[18] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[19].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[24].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[19].OBUF1  (.A(\REGF[24].RFW.q_wire[19] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[19].OBUF2  (.A(\REGF[24].RFW.q_wire[19] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[1].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[24].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[1].OBUF1  (.A(\REGF[24].RFW.q_wire[1] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[1].OBUF2  (.A(\REGF[24].RFW.q_wire[1] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[20].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[24].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[20].OBUF1  (.A(\REGF[24].RFW.q_wire[20] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[20].OBUF2  (.A(\REGF[24].RFW.q_wire[20] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[21].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[24].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[21].OBUF1  (.A(\REGF[24].RFW.q_wire[21] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[21].OBUF2  (.A(\REGF[24].RFW.q_wire[21] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[22].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[24].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[22].OBUF1  (.A(\REGF[24].RFW.q_wire[22] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[22].OBUF2  (.A(\REGF[24].RFW.q_wire[22] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[23].FF  (.CLK(\REGF[24].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[24].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[23].OBUF1  (.A(\REGF[24].RFW.q_wire[23] ),
    .TE_B(\REGF[24].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[23].OBUF2  (.A(\REGF[24].RFW.q_wire[23] ),
    .TE_B(\REGF[24].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[24].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[24].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[24].OBUF1  (.A(\REGF[24].RFW.q_wire[24] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[24].OBUF2  (.A(\REGF[24].RFW.q_wire[24] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[25].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[24].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[25].OBUF1  (.A(\REGF[24].RFW.q_wire[25] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[25].OBUF2  (.A(\REGF[24].RFW.q_wire[25] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[26].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[24].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[26].OBUF1  (.A(\REGF[24].RFW.q_wire[26] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[26].OBUF2  (.A(\REGF[24].RFW.q_wire[26] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[27].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[24].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[27].OBUF1  (.A(\REGF[24].RFW.q_wire[27] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[27].OBUF2  (.A(\REGF[24].RFW.q_wire[27] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[28].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[24].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[28].OBUF1  (.A(\REGF[24].RFW.q_wire[28] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[28].OBUF2  (.A(\REGF[24].RFW.q_wire[28] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[29].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[24].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[29].OBUF1  (.A(\REGF[24].RFW.q_wire[29] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[29].OBUF2  (.A(\REGF[24].RFW.q_wire[29] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[2].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[24].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[2].OBUF1  (.A(\REGF[24].RFW.q_wire[2] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[2].OBUF2  (.A(\REGF[24].RFW.q_wire[2] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[30].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[24].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[30].OBUF1  (.A(\REGF[24].RFW.q_wire[30] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[30].OBUF2  (.A(\REGF[24].RFW.q_wire[30] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[31].FF  (.CLK(\REGF[24].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[24].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[31].OBUF1  (.A(\REGF[24].RFW.q_wire[31] ),
    .TE_B(\REGF[24].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[31].OBUF2  (.A(\REGF[24].RFW.q_wire[31] ),
    .TE_B(\REGF[24].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[3].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[24].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[3].OBUF1  (.A(\REGF[24].RFW.q_wire[3] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[3].OBUF2  (.A(\REGF[24].RFW.q_wire[3] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[4].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[24].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[4].OBUF1  (.A(\REGF[24].RFW.q_wire[4] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[4].OBUF2  (.A(\REGF[24].RFW.q_wire[4] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[5].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[24].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[5].OBUF1  (.A(\REGF[24].RFW.q_wire[5] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[5].OBUF2  (.A(\REGF[24].RFW.q_wire[5] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[6].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[24].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[6].OBUF1  (.A(\REGF[24].RFW.q_wire[6] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[6].OBUF2  (.A(\REGF[24].RFW.q_wire[6] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[7].FF  (.CLK(\REGF[24].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[24].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[7].OBUF1  (.A(\REGF[24].RFW.q_wire[7] ),
    .TE_B(\REGF[24].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[7].OBUF2  (.A(\REGF[24].RFW.q_wire[7] ),
    .TE_B(\REGF[24].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[8].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[24].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[8].OBUF1  (.A(\REGF[24].RFW.q_wire[8] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[8].OBUF2  (.A(\REGF[24].RFW.q_wire[8] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[24].RFW.BIT[9].FF  (.CLK(\REGF[24].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[24].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[9].OBUF1  (.A(\REGF[24].RFW.q_wire[9] ),
    .TE_B(\REGF[24].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[24].RFW.BIT[9].OBUF2  (.A(\REGF[24].RFW.q_wire[9] ),
    .TE_B(\REGF[24].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[24].RFW.CGAND  (.A(\DEC2.D3.SEL[0] ),
    .B(WE),
    .X(\REGF[24].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[24].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[24].RFW.we_wire ),
    .GCLK(\REGF[24].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[24].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[24].RFW.we_wire ),
    .GCLK(\REGF[24].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[24].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[24].RFW.we_wire ),
    .GCLK(\REGF[24].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[24].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[24].RFW.we_wire ),
    .GCLK(\REGF[24].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV1[0]  (.A(\DEC0.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV1[1]  (.A(\DEC0.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV1[2]  (.A(\DEC0.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV1[3]  (.A(\DEC0.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV2[0]  (.A(\DEC1.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV2[1]  (.A(\DEC1.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV2[2]  (.A(\DEC1.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[24].RFW.INV2[3]  (.A(\DEC1.D3.SEL[0] ),
    .Y(\REGF[24].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[0].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[25].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[0].OBUF1  (.A(\REGF[25].RFW.q_wire[0] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[0].OBUF2  (.A(\REGF[25].RFW.q_wire[0] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[10].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[25].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[10].OBUF1  (.A(\REGF[25].RFW.q_wire[10] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[10].OBUF2  (.A(\REGF[25].RFW.q_wire[10] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[11].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[25].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[11].OBUF1  (.A(\REGF[25].RFW.q_wire[11] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[11].OBUF2  (.A(\REGF[25].RFW.q_wire[11] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[12].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[25].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[12].OBUF1  (.A(\REGF[25].RFW.q_wire[12] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[12].OBUF2  (.A(\REGF[25].RFW.q_wire[12] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[13].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[25].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[13].OBUF1  (.A(\REGF[25].RFW.q_wire[13] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[13].OBUF2  (.A(\REGF[25].RFW.q_wire[13] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[14].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[25].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[14].OBUF1  (.A(\REGF[25].RFW.q_wire[14] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[14].OBUF2  (.A(\REGF[25].RFW.q_wire[14] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[15].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[25].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[15].OBUF1  (.A(\REGF[25].RFW.q_wire[15] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[15].OBUF2  (.A(\REGF[25].RFW.q_wire[15] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[16].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[25].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[16].OBUF1  (.A(\REGF[25].RFW.q_wire[16] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[16].OBUF2  (.A(\REGF[25].RFW.q_wire[16] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[17].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[25].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[17].OBUF1  (.A(\REGF[25].RFW.q_wire[17] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[17].OBUF2  (.A(\REGF[25].RFW.q_wire[17] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[18].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[25].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[18].OBUF1  (.A(\REGF[25].RFW.q_wire[18] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[18].OBUF2  (.A(\REGF[25].RFW.q_wire[18] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[19].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[25].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[19].OBUF1  (.A(\REGF[25].RFW.q_wire[19] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[19].OBUF2  (.A(\REGF[25].RFW.q_wire[19] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[1].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[25].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[1].OBUF1  (.A(\REGF[25].RFW.q_wire[1] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[1].OBUF2  (.A(\REGF[25].RFW.q_wire[1] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[20].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[25].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[20].OBUF1  (.A(\REGF[25].RFW.q_wire[20] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[20].OBUF2  (.A(\REGF[25].RFW.q_wire[20] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[21].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[25].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[21].OBUF1  (.A(\REGF[25].RFW.q_wire[21] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[21].OBUF2  (.A(\REGF[25].RFW.q_wire[21] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[22].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[25].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[22].OBUF1  (.A(\REGF[25].RFW.q_wire[22] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[22].OBUF2  (.A(\REGF[25].RFW.q_wire[22] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[23].FF  (.CLK(\REGF[25].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[25].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[23].OBUF1  (.A(\REGF[25].RFW.q_wire[23] ),
    .TE_B(\REGF[25].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[23].OBUF2  (.A(\REGF[25].RFW.q_wire[23] ),
    .TE_B(\REGF[25].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[24].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[25].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[24].OBUF1  (.A(\REGF[25].RFW.q_wire[24] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[24].OBUF2  (.A(\REGF[25].RFW.q_wire[24] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[25].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[25].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[25].OBUF1  (.A(\REGF[25].RFW.q_wire[25] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[25].OBUF2  (.A(\REGF[25].RFW.q_wire[25] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[26].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[25].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[26].OBUF1  (.A(\REGF[25].RFW.q_wire[26] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[26].OBUF2  (.A(\REGF[25].RFW.q_wire[26] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[27].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[25].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[27].OBUF1  (.A(\REGF[25].RFW.q_wire[27] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[27].OBUF2  (.A(\REGF[25].RFW.q_wire[27] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[28].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[25].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[28].OBUF1  (.A(\REGF[25].RFW.q_wire[28] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[28].OBUF2  (.A(\REGF[25].RFW.q_wire[28] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[29].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[25].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[29].OBUF1  (.A(\REGF[25].RFW.q_wire[29] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[29].OBUF2  (.A(\REGF[25].RFW.q_wire[29] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[2].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[25].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[2].OBUF1  (.A(\REGF[25].RFW.q_wire[2] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[2].OBUF2  (.A(\REGF[25].RFW.q_wire[2] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[30].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[25].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[30].OBUF1  (.A(\REGF[25].RFW.q_wire[30] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[30].OBUF2  (.A(\REGF[25].RFW.q_wire[30] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[31].FF  (.CLK(\REGF[25].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[25].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[31].OBUF1  (.A(\REGF[25].RFW.q_wire[31] ),
    .TE_B(\REGF[25].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[31].OBUF2  (.A(\REGF[25].RFW.q_wire[31] ),
    .TE_B(\REGF[25].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[3].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[25].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[3].OBUF1  (.A(\REGF[25].RFW.q_wire[3] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[3].OBUF2  (.A(\REGF[25].RFW.q_wire[3] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[4].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[25].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[4].OBUF1  (.A(\REGF[25].RFW.q_wire[4] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[4].OBUF2  (.A(\REGF[25].RFW.q_wire[4] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[5].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[25].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[5].OBUF1  (.A(\REGF[25].RFW.q_wire[5] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[5].OBUF2  (.A(\REGF[25].RFW.q_wire[5] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[6].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[25].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[6].OBUF1  (.A(\REGF[25].RFW.q_wire[6] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[6].OBUF2  (.A(\REGF[25].RFW.q_wire[6] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[7].FF  (.CLK(\REGF[25].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[25].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[7].OBUF1  (.A(\REGF[25].RFW.q_wire[7] ),
    .TE_B(\REGF[25].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[7].OBUF2  (.A(\REGF[25].RFW.q_wire[7] ),
    .TE_B(\REGF[25].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[8].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[25].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[8].OBUF1  (.A(\REGF[25].RFW.q_wire[8] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[8].OBUF2  (.A(\REGF[25].RFW.q_wire[8] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[25].RFW.BIT[9].FF  (.CLK(\REGF[25].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[25].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[9].OBUF1  (.A(\REGF[25].RFW.q_wire[9] ),
    .TE_B(\REGF[25].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[25].RFW.BIT[9].OBUF2  (.A(\REGF[25].RFW.q_wire[9] ),
    .TE_B(\REGF[25].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[25].RFW.CGAND  (.A(\DEC2.D3.SEL[1] ),
    .B(WE),
    .X(\REGF[25].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[25].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[25].RFW.we_wire ),
    .GCLK(\REGF[25].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[25].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[25].RFW.we_wire ),
    .GCLK(\REGF[25].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[25].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[25].RFW.we_wire ),
    .GCLK(\REGF[25].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[25].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[25].RFW.we_wire ),
    .GCLK(\REGF[25].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV1[0]  (.A(\DEC0.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV1[1]  (.A(\DEC0.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV1[2]  (.A(\DEC0.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV1[3]  (.A(\DEC0.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV2[0]  (.A(\DEC1.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV2[1]  (.A(\DEC1.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV2[2]  (.A(\DEC1.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[25].RFW.INV2[3]  (.A(\DEC1.D3.SEL[1] ),
    .Y(\REGF[25].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[0].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[26].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[0].OBUF1  (.A(\REGF[26].RFW.q_wire[0] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[0].OBUF2  (.A(\REGF[26].RFW.q_wire[0] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[10].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[26].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[10].OBUF1  (.A(\REGF[26].RFW.q_wire[10] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[10].OBUF2  (.A(\REGF[26].RFW.q_wire[10] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[11].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[26].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[11].OBUF1  (.A(\REGF[26].RFW.q_wire[11] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[11].OBUF2  (.A(\REGF[26].RFW.q_wire[11] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[12].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[26].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[12].OBUF1  (.A(\REGF[26].RFW.q_wire[12] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[12].OBUF2  (.A(\REGF[26].RFW.q_wire[12] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[13].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[26].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[13].OBUF1  (.A(\REGF[26].RFW.q_wire[13] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[13].OBUF2  (.A(\REGF[26].RFW.q_wire[13] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[14].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[26].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[14].OBUF1  (.A(\REGF[26].RFW.q_wire[14] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[14].OBUF2  (.A(\REGF[26].RFW.q_wire[14] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[15].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[26].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[15].OBUF1  (.A(\REGF[26].RFW.q_wire[15] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[15].OBUF2  (.A(\REGF[26].RFW.q_wire[15] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[16].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[26].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[16].OBUF1  (.A(\REGF[26].RFW.q_wire[16] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[16].OBUF2  (.A(\REGF[26].RFW.q_wire[16] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[17].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[26].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[17].OBUF1  (.A(\REGF[26].RFW.q_wire[17] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[17].OBUF2  (.A(\REGF[26].RFW.q_wire[17] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[18].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[26].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[18].OBUF1  (.A(\REGF[26].RFW.q_wire[18] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[18].OBUF2  (.A(\REGF[26].RFW.q_wire[18] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[19].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[26].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[19].OBUF1  (.A(\REGF[26].RFW.q_wire[19] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[19].OBUF2  (.A(\REGF[26].RFW.q_wire[19] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[1].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[26].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[1].OBUF1  (.A(\REGF[26].RFW.q_wire[1] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[1].OBUF2  (.A(\REGF[26].RFW.q_wire[1] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[20].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[26].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[20].OBUF1  (.A(\REGF[26].RFW.q_wire[20] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[20].OBUF2  (.A(\REGF[26].RFW.q_wire[20] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[21].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[26].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[21].OBUF1  (.A(\REGF[26].RFW.q_wire[21] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[21].OBUF2  (.A(\REGF[26].RFW.q_wire[21] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[22].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[26].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[22].OBUF1  (.A(\REGF[26].RFW.q_wire[22] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[22].OBUF2  (.A(\REGF[26].RFW.q_wire[22] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[23].FF  (.CLK(\REGF[26].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[26].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[23].OBUF1  (.A(\REGF[26].RFW.q_wire[23] ),
    .TE_B(\REGF[26].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[23].OBUF2  (.A(\REGF[26].RFW.q_wire[23] ),
    .TE_B(\REGF[26].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[24].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[26].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[24].OBUF1  (.A(\REGF[26].RFW.q_wire[24] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[24].OBUF2  (.A(\REGF[26].RFW.q_wire[24] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[25].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[26].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[25].OBUF1  (.A(\REGF[26].RFW.q_wire[25] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[25].OBUF2  (.A(\REGF[26].RFW.q_wire[25] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[26].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[26].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[26].OBUF1  (.A(\REGF[26].RFW.q_wire[26] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[26].OBUF2  (.A(\REGF[26].RFW.q_wire[26] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[27].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[26].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[27].OBUF1  (.A(\REGF[26].RFW.q_wire[27] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[27].OBUF2  (.A(\REGF[26].RFW.q_wire[27] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[28].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[26].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[28].OBUF1  (.A(\REGF[26].RFW.q_wire[28] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[28].OBUF2  (.A(\REGF[26].RFW.q_wire[28] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[29].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[26].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[29].OBUF1  (.A(\REGF[26].RFW.q_wire[29] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[29].OBUF2  (.A(\REGF[26].RFW.q_wire[29] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[2].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[26].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[2].OBUF1  (.A(\REGF[26].RFW.q_wire[2] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[2].OBUF2  (.A(\REGF[26].RFW.q_wire[2] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[30].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[26].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[30].OBUF1  (.A(\REGF[26].RFW.q_wire[30] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[30].OBUF2  (.A(\REGF[26].RFW.q_wire[30] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[31].FF  (.CLK(\REGF[26].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[26].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[31].OBUF1  (.A(\REGF[26].RFW.q_wire[31] ),
    .TE_B(\REGF[26].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[31].OBUF2  (.A(\REGF[26].RFW.q_wire[31] ),
    .TE_B(\REGF[26].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[3].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[26].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[3].OBUF1  (.A(\REGF[26].RFW.q_wire[3] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[3].OBUF2  (.A(\REGF[26].RFW.q_wire[3] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[4].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[26].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[4].OBUF1  (.A(\REGF[26].RFW.q_wire[4] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[4].OBUF2  (.A(\REGF[26].RFW.q_wire[4] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[5].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[26].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[5].OBUF1  (.A(\REGF[26].RFW.q_wire[5] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[5].OBUF2  (.A(\REGF[26].RFW.q_wire[5] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[6].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[26].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[6].OBUF1  (.A(\REGF[26].RFW.q_wire[6] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[6].OBUF2  (.A(\REGF[26].RFW.q_wire[6] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[7].FF  (.CLK(\REGF[26].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[26].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[7].OBUF1  (.A(\REGF[26].RFW.q_wire[7] ),
    .TE_B(\REGF[26].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[7].OBUF2  (.A(\REGF[26].RFW.q_wire[7] ),
    .TE_B(\REGF[26].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[8].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[26].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[8].OBUF1  (.A(\REGF[26].RFW.q_wire[8] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[8].OBUF2  (.A(\REGF[26].RFW.q_wire[8] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[26].RFW.BIT[9].FF  (.CLK(\REGF[26].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[26].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[9].OBUF1  (.A(\REGF[26].RFW.q_wire[9] ),
    .TE_B(\REGF[26].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[26].RFW.BIT[9].OBUF2  (.A(\REGF[26].RFW.q_wire[9] ),
    .TE_B(\REGF[26].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[26].RFW.CGAND  (.A(\DEC2.D3.SEL[2] ),
    .B(WE),
    .X(\REGF[26].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[26].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[26].RFW.we_wire ),
    .GCLK(\REGF[26].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[26].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[26].RFW.we_wire ),
    .GCLK(\REGF[26].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[26].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[26].RFW.we_wire ),
    .GCLK(\REGF[26].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[26].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[26].RFW.we_wire ),
    .GCLK(\REGF[26].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV1[0]  (.A(\DEC0.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV1[1]  (.A(\DEC0.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV1[2]  (.A(\DEC0.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV1[3]  (.A(\DEC0.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV2[0]  (.A(\DEC1.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV2[1]  (.A(\DEC1.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV2[2]  (.A(\DEC1.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[26].RFW.INV2[3]  (.A(\DEC1.D3.SEL[2] ),
    .Y(\REGF[26].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[0].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[27].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[0].OBUF1  (.A(\REGF[27].RFW.q_wire[0] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[0].OBUF2  (.A(\REGF[27].RFW.q_wire[0] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[10].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[27].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[10].OBUF1  (.A(\REGF[27].RFW.q_wire[10] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[10].OBUF2  (.A(\REGF[27].RFW.q_wire[10] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[11].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[27].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[11].OBUF1  (.A(\REGF[27].RFW.q_wire[11] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[11].OBUF2  (.A(\REGF[27].RFW.q_wire[11] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[12].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[27].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[12].OBUF1  (.A(\REGF[27].RFW.q_wire[12] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[12].OBUF2  (.A(\REGF[27].RFW.q_wire[12] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[13].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[27].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[13].OBUF1  (.A(\REGF[27].RFW.q_wire[13] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[13].OBUF2  (.A(\REGF[27].RFW.q_wire[13] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[14].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[27].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[14].OBUF1  (.A(\REGF[27].RFW.q_wire[14] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[14].OBUF2  (.A(\REGF[27].RFW.q_wire[14] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[15].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[27].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[15].OBUF1  (.A(\REGF[27].RFW.q_wire[15] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[15].OBUF2  (.A(\REGF[27].RFW.q_wire[15] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[16].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[27].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[16].OBUF1  (.A(\REGF[27].RFW.q_wire[16] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[16].OBUF2  (.A(\REGF[27].RFW.q_wire[16] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[17].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[27].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[17].OBUF1  (.A(\REGF[27].RFW.q_wire[17] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[17].OBUF2  (.A(\REGF[27].RFW.q_wire[17] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[18].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[27].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[18].OBUF1  (.A(\REGF[27].RFW.q_wire[18] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[18].OBUF2  (.A(\REGF[27].RFW.q_wire[18] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[19].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[27].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[19].OBUF1  (.A(\REGF[27].RFW.q_wire[19] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[19].OBUF2  (.A(\REGF[27].RFW.q_wire[19] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[1].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[27].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[1].OBUF1  (.A(\REGF[27].RFW.q_wire[1] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[1].OBUF2  (.A(\REGF[27].RFW.q_wire[1] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[20].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[27].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[20].OBUF1  (.A(\REGF[27].RFW.q_wire[20] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[20].OBUF2  (.A(\REGF[27].RFW.q_wire[20] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[21].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[27].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[21].OBUF1  (.A(\REGF[27].RFW.q_wire[21] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[21].OBUF2  (.A(\REGF[27].RFW.q_wire[21] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[22].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[27].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[22].OBUF1  (.A(\REGF[27].RFW.q_wire[22] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[22].OBUF2  (.A(\REGF[27].RFW.q_wire[22] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[23].FF  (.CLK(\REGF[27].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[27].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[23].OBUF1  (.A(\REGF[27].RFW.q_wire[23] ),
    .TE_B(\REGF[27].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[23].OBUF2  (.A(\REGF[27].RFW.q_wire[23] ),
    .TE_B(\REGF[27].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[24].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[27].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[24].OBUF1  (.A(\REGF[27].RFW.q_wire[24] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[24].OBUF2  (.A(\REGF[27].RFW.q_wire[24] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[25].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[27].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[25].OBUF1  (.A(\REGF[27].RFW.q_wire[25] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[25].OBUF2  (.A(\REGF[27].RFW.q_wire[25] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[26].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[27].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[26].OBUF1  (.A(\REGF[27].RFW.q_wire[26] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[26].OBUF2  (.A(\REGF[27].RFW.q_wire[26] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[27].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[27].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[27].OBUF1  (.A(\REGF[27].RFW.q_wire[27] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[27].OBUF2  (.A(\REGF[27].RFW.q_wire[27] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[28].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[27].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[28].OBUF1  (.A(\REGF[27].RFW.q_wire[28] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[28].OBUF2  (.A(\REGF[27].RFW.q_wire[28] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[29].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[27].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[29].OBUF1  (.A(\REGF[27].RFW.q_wire[29] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[29].OBUF2  (.A(\REGF[27].RFW.q_wire[29] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[2].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[27].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[2].OBUF1  (.A(\REGF[27].RFW.q_wire[2] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[2].OBUF2  (.A(\REGF[27].RFW.q_wire[2] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[30].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[27].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[30].OBUF1  (.A(\REGF[27].RFW.q_wire[30] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[30].OBUF2  (.A(\REGF[27].RFW.q_wire[30] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[31].FF  (.CLK(\REGF[27].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[27].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[31].OBUF1  (.A(\REGF[27].RFW.q_wire[31] ),
    .TE_B(\REGF[27].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[31].OBUF2  (.A(\REGF[27].RFW.q_wire[31] ),
    .TE_B(\REGF[27].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[3].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[27].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[3].OBUF1  (.A(\REGF[27].RFW.q_wire[3] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[3].OBUF2  (.A(\REGF[27].RFW.q_wire[3] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[4].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[27].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[4].OBUF1  (.A(\REGF[27].RFW.q_wire[4] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[4].OBUF2  (.A(\REGF[27].RFW.q_wire[4] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[5].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[27].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[5].OBUF1  (.A(\REGF[27].RFW.q_wire[5] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[5].OBUF2  (.A(\REGF[27].RFW.q_wire[5] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[6].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[27].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[6].OBUF1  (.A(\REGF[27].RFW.q_wire[6] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[6].OBUF2  (.A(\REGF[27].RFW.q_wire[6] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[7].FF  (.CLK(\REGF[27].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[27].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[7].OBUF1  (.A(\REGF[27].RFW.q_wire[7] ),
    .TE_B(\REGF[27].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[7].OBUF2  (.A(\REGF[27].RFW.q_wire[7] ),
    .TE_B(\REGF[27].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[8].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[27].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[8].OBUF1  (.A(\REGF[27].RFW.q_wire[8] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[8].OBUF2  (.A(\REGF[27].RFW.q_wire[8] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[27].RFW.BIT[9].FF  (.CLK(\REGF[27].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[27].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[9].OBUF1  (.A(\REGF[27].RFW.q_wire[9] ),
    .TE_B(\REGF[27].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[27].RFW.BIT[9].OBUF2  (.A(\REGF[27].RFW.q_wire[9] ),
    .TE_B(\REGF[27].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[27].RFW.CGAND  (.A(\DEC2.D3.SEL[3] ),
    .B(WE),
    .X(\REGF[27].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[27].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[27].RFW.we_wire ),
    .GCLK(\REGF[27].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[27].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[27].RFW.we_wire ),
    .GCLK(\REGF[27].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[27].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[27].RFW.we_wire ),
    .GCLK(\REGF[27].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[27].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[27].RFW.we_wire ),
    .GCLK(\REGF[27].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV1[0]  (.A(\DEC0.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV1[1]  (.A(\DEC0.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV1[2]  (.A(\DEC0.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV1[3]  (.A(\DEC0.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV2[0]  (.A(\DEC1.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV2[1]  (.A(\DEC1.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV2[2]  (.A(\DEC1.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[27].RFW.INV2[3]  (.A(\DEC1.D3.SEL[3] ),
    .Y(\REGF[27].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[0].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[28].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[0].OBUF1  (.A(\REGF[28].RFW.q_wire[0] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[0].OBUF2  (.A(\REGF[28].RFW.q_wire[0] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[10].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[28].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[10].OBUF1  (.A(\REGF[28].RFW.q_wire[10] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[10].OBUF2  (.A(\REGF[28].RFW.q_wire[10] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[11].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[28].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[11].OBUF1  (.A(\REGF[28].RFW.q_wire[11] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[11].OBUF2  (.A(\REGF[28].RFW.q_wire[11] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[12].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[28].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[12].OBUF1  (.A(\REGF[28].RFW.q_wire[12] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[12].OBUF2  (.A(\REGF[28].RFW.q_wire[12] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[13].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[28].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[13].OBUF1  (.A(\REGF[28].RFW.q_wire[13] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[13].OBUF2  (.A(\REGF[28].RFW.q_wire[13] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[14].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[28].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[14].OBUF1  (.A(\REGF[28].RFW.q_wire[14] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[14].OBUF2  (.A(\REGF[28].RFW.q_wire[14] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[15].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[28].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[15].OBUF1  (.A(\REGF[28].RFW.q_wire[15] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[15].OBUF2  (.A(\REGF[28].RFW.q_wire[15] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[16].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[28].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[16].OBUF1  (.A(\REGF[28].RFW.q_wire[16] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[16].OBUF2  (.A(\REGF[28].RFW.q_wire[16] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[17].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[28].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[17].OBUF1  (.A(\REGF[28].RFW.q_wire[17] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[17].OBUF2  (.A(\REGF[28].RFW.q_wire[17] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[18].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[28].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[18].OBUF1  (.A(\REGF[28].RFW.q_wire[18] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[18].OBUF2  (.A(\REGF[28].RFW.q_wire[18] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[19].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[28].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[19].OBUF1  (.A(\REGF[28].RFW.q_wire[19] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[19].OBUF2  (.A(\REGF[28].RFW.q_wire[19] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[1].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[28].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[1].OBUF1  (.A(\REGF[28].RFW.q_wire[1] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[1].OBUF2  (.A(\REGF[28].RFW.q_wire[1] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[20].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[28].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[20].OBUF1  (.A(\REGF[28].RFW.q_wire[20] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[20].OBUF2  (.A(\REGF[28].RFW.q_wire[20] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[21].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[28].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[21].OBUF1  (.A(\REGF[28].RFW.q_wire[21] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[21].OBUF2  (.A(\REGF[28].RFW.q_wire[21] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[22].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[28].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[22].OBUF1  (.A(\REGF[28].RFW.q_wire[22] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[22].OBUF2  (.A(\REGF[28].RFW.q_wire[22] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[23].FF  (.CLK(\REGF[28].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[28].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[23].OBUF1  (.A(\REGF[28].RFW.q_wire[23] ),
    .TE_B(\REGF[28].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[23].OBUF2  (.A(\REGF[28].RFW.q_wire[23] ),
    .TE_B(\REGF[28].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[24].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[28].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[24].OBUF1  (.A(\REGF[28].RFW.q_wire[24] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[24].OBUF2  (.A(\REGF[28].RFW.q_wire[24] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[25].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[28].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[25].OBUF1  (.A(\REGF[28].RFW.q_wire[25] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[25].OBUF2  (.A(\REGF[28].RFW.q_wire[25] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[26].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[28].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[26].OBUF1  (.A(\REGF[28].RFW.q_wire[26] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[26].OBUF2  (.A(\REGF[28].RFW.q_wire[26] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[27].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[28].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[27].OBUF1  (.A(\REGF[28].RFW.q_wire[27] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[27].OBUF2  (.A(\REGF[28].RFW.q_wire[27] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[28].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[28].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[28].OBUF1  (.A(\REGF[28].RFW.q_wire[28] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[28].OBUF2  (.A(\REGF[28].RFW.q_wire[28] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[29].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[28].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[29].OBUF1  (.A(\REGF[28].RFW.q_wire[29] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[29].OBUF2  (.A(\REGF[28].RFW.q_wire[29] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[2].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[28].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[2].OBUF1  (.A(\REGF[28].RFW.q_wire[2] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[2].OBUF2  (.A(\REGF[28].RFW.q_wire[2] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[30].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[28].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[30].OBUF1  (.A(\REGF[28].RFW.q_wire[30] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[30].OBUF2  (.A(\REGF[28].RFW.q_wire[30] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[31].FF  (.CLK(\REGF[28].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[28].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[31].OBUF1  (.A(\REGF[28].RFW.q_wire[31] ),
    .TE_B(\REGF[28].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[31].OBUF2  (.A(\REGF[28].RFW.q_wire[31] ),
    .TE_B(\REGF[28].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[3].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[28].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[3].OBUF1  (.A(\REGF[28].RFW.q_wire[3] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[3].OBUF2  (.A(\REGF[28].RFW.q_wire[3] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[4].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[28].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[4].OBUF1  (.A(\REGF[28].RFW.q_wire[4] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[4].OBUF2  (.A(\REGF[28].RFW.q_wire[4] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[5].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[28].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[5].OBUF1  (.A(\REGF[28].RFW.q_wire[5] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[5].OBUF2  (.A(\REGF[28].RFW.q_wire[5] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[6].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[28].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[6].OBUF1  (.A(\REGF[28].RFW.q_wire[6] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[6].OBUF2  (.A(\REGF[28].RFW.q_wire[6] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[7].FF  (.CLK(\REGF[28].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[28].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[7].OBUF1  (.A(\REGF[28].RFW.q_wire[7] ),
    .TE_B(\REGF[28].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[7].OBUF2  (.A(\REGF[28].RFW.q_wire[7] ),
    .TE_B(\REGF[28].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[8].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[28].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[8].OBUF1  (.A(\REGF[28].RFW.q_wire[8] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[8].OBUF2  (.A(\REGF[28].RFW.q_wire[8] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[28].RFW.BIT[9].FF  (.CLK(\REGF[28].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[28].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[9].OBUF1  (.A(\REGF[28].RFW.q_wire[9] ),
    .TE_B(\REGF[28].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[28].RFW.BIT[9].OBUF2  (.A(\REGF[28].RFW.q_wire[9] ),
    .TE_B(\REGF[28].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[28].RFW.CGAND  (.A(\DEC2.D3.SEL[4] ),
    .B(WE),
    .X(\REGF[28].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[28].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[28].RFW.we_wire ),
    .GCLK(\REGF[28].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[28].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[28].RFW.we_wire ),
    .GCLK(\REGF[28].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[28].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[28].RFW.we_wire ),
    .GCLK(\REGF[28].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[28].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[28].RFW.we_wire ),
    .GCLK(\REGF[28].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV1[0]  (.A(\DEC0.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV1[1]  (.A(\DEC0.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV1[2]  (.A(\DEC0.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV1[3]  (.A(\DEC0.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV2[0]  (.A(\DEC1.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV2[1]  (.A(\DEC1.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV2[2]  (.A(\DEC1.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[28].RFW.INV2[3]  (.A(\DEC1.D3.SEL[4] ),
    .Y(\REGF[28].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[0].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[29].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[0].OBUF1  (.A(\REGF[29].RFW.q_wire[0] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[0].OBUF2  (.A(\REGF[29].RFW.q_wire[0] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[10].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[29].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[10].OBUF1  (.A(\REGF[29].RFW.q_wire[10] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[10].OBUF2  (.A(\REGF[29].RFW.q_wire[10] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[11].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[29].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[11].OBUF1  (.A(\REGF[29].RFW.q_wire[11] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[11].OBUF2  (.A(\REGF[29].RFW.q_wire[11] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[12].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[29].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[12].OBUF1  (.A(\REGF[29].RFW.q_wire[12] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[12].OBUF2  (.A(\REGF[29].RFW.q_wire[12] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[13].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[29].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[13].OBUF1  (.A(\REGF[29].RFW.q_wire[13] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[13].OBUF2  (.A(\REGF[29].RFW.q_wire[13] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[14].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[29].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[14].OBUF1  (.A(\REGF[29].RFW.q_wire[14] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[14].OBUF2  (.A(\REGF[29].RFW.q_wire[14] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[15].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[29].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[15].OBUF1  (.A(\REGF[29].RFW.q_wire[15] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[15].OBUF2  (.A(\REGF[29].RFW.q_wire[15] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[16].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[29].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[16].OBUF1  (.A(\REGF[29].RFW.q_wire[16] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[16].OBUF2  (.A(\REGF[29].RFW.q_wire[16] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[17].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[29].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[17].OBUF1  (.A(\REGF[29].RFW.q_wire[17] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[17].OBUF2  (.A(\REGF[29].RFW.q_wire[17] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[18].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[29].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[18].OBUF1  (.A(\REGF[29].RFW.q_wire[18] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[18].OBUF2  (.A(\REGF[29].RFW.q_wire[18] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[19].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[29].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[19].OBUF1  (.A(\REGF[29].RFW.q_wire[19] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[19].OBUF2  (.A(\REGF[29].RFW.q_wire[19] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[1].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[29].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[1].OBUF1  (.A(\REGF[29].RFW.q_wire[1] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[1].OBUF2  (.A(\REGF[29].RFW.q_wire[1] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[20].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[29].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[20].OBUF1  (.A(\REGF[29].RFW.q_wire[20] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[20].OBUF2  (.A(\REGF[29].RFW.q_wire[20] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[21].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[29].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[21].OBUF1  (.A(\REGF[29].RFW.q_wire[21] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[21].OBUF2  (.A(\REGF[29].RFW.q_wire[21] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[22].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[29].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[22].OBUF1  (.A(\REGF[29].RFW.q_wire[22] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[22].OBUF2  (.A(\REGF[29].RFW.q_wire[22] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[23].FF  (.CLK(\REGF[29].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[29].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[23].OBUF1  (.A(\REGF[29].RFW.q_wire[23] ),
    .TE_B(\REGF[29].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[23].OBUF2  (.A(\REGF[29].RFW.q_wire[23] ),
    .TE_B(\REGF[29].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[24].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[29].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[24].OBUF1  (.A(\REGF[29].RFW.q_wire[24] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[24].OBUF2  (.A(\REGF[29].RFW.q_wire[24] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[25].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[29].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[25].OBUF1  (.A(\REGF[29].RFW.q_wire[25] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[25].OBUF2  (.A(\REGF[29].RFW.q_wire[25] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[26].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[29].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[26].OBUF1  (.A(\REGF[29].RFW.q_wire[26] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[26].OBUF2  (.A(\REGF[29].RFW.q_wire[26] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[27].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[29].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[27].OBUF1  (.A(\REGF[29].RFW.q_wire[27] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[27].OBUF2  (.A(\REGF[29].RFW.q_wire[27] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[28].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[29].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[28].OBUF1  (.A(\REGF[29].RFW.q_wire[28] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[28].OBUF2  (.A(\REGF[29].RFW.q_wire[28] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[29].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[29].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[29].OBUF1  (.A(\REGF[29].RFW.q_wire[29] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[29].OBUF2  (.A(\REGF[29].RFW.q_wire[29] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[2].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[29].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[2].OBUF1  (.A(\REGF[29].RFW.q_wire[2] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[2].OBUF2  (.A(\REGF[29].RFW.q_wire[2] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[30].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[29].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[30].OBUF1  (.A(\REGF[29].RFW.q_wire[30] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[30].OBUF2  (.A(\REGF[29].RFW.q_wire[30] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[31].FF  (.CLK(\REGF[29].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[29].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[31].OBUF1  (.A(\REGF[29].RFW.q_wire[31] ),
    .TE_B(\REGF[29].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[31].OBUF2  (.A(\REGF[29].RFW.q_wire[31] ),
    .TE_B(\REGF[29].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[3].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[29].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[3].OBUF1  (.A(\REGF[29].RFW.q_wire[3] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[3].OBUF2  (.A(\REGF[29].RFW.q_wire[3] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[4].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[29].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[4].OBUF1  (.A(\REGF[29].RFW.q_wire[4] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[4].OBUF2  (.A(\REGF[29].RFW.q_wire[4] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[5].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[29].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[5].OBUF1  (.A(\REGF[29].RFW.q_wire[5] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[5].OBUF2  (.A(\REGF[29].RFW.q_wire[5] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[6].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[29].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[6].OBUF1  (.A(\REGF[29].RFW.q_wire[6] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[6].OBUF2  (.A(\REGF[29].RFW.q_wire[6] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[7].FF  (.CLK(\REGF[29].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[29].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[7].OBUF1  (.A(\REGF[29].RFW.q_wire[7] ),
    .TE_B(\REGF[29].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[7].OBUF2  (.A(\REGF[29].RFW.q_wire[7] ),
    .TE_B(\REGF[29].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[8].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[29].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[8].OBUF1  (.A(\REGF[29].RFW.q_wire[8] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[8].OBUF2  (.A(\REGF[29].RFW.q_wire[8] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[29].RFW.BIT[9].FF  (.CLK(\REGF[29].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[29].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[9].OBUF1  (.A(\REGF[29].RFW.q_wire[9] ),
    .TE_B(\REGF[29].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[29].RFW.BIT[9].OBUF2  (.A(\REGF[29].RFW.q_wire[9] ),
    .TE_B(\REGF[29].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[29].RFW.CGAND  (.A(\DEC2.D3.SEL[5] ),
    .B(WE),
    .X(\REGF[29].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[29].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[29].RFW.we_wire ),
    .GCLK(\REGF[29].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[29].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[29].RFW.we_wire ),
    .GCLK(\REGF[29].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[29].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[29].RFW.we_wire ),
    .GCLK(\REGF[29].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[29].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[29].RFW.we_wire ),
    .GCLK(\REGF[29].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV1[0]  (.A(\DEC0.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV1[1]  (.A(\DEC0.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV1[2]  (.A(\DEC0.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV1[3]  (.A(\DEC0.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV2[0]  (.A(\DEC1.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV2[1]  (.A(\DEC1.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV2[2]  (.A(\DEC1.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[29].RFW.INV2[3]  (.A(\DEC1.D3.SEL[5] ),
    .Y(\REGF[29].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[0].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[2].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[0].OBUF1  (.A(\REGF[2].RFW.q_wire[0] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[0].OBUF2  (.A(\REGF[2].RFW.q_wire[0] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[10].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[2].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[10].OBUF1  (.A(\REGF[2].RFW.q_wire[10] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[10].OBUF2  (.A(\REGF[2].RFW.q_wire[10] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[11].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[2].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[11].OBUF1  (.A(\REGF[2].RFW.q_wire[11] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[11].OBUF2  (.A(\REGF[2].RFW.q_wire[11] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[12].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[2].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[12].OBUF1  (.A(\REGF[2].RFW.q_wire[12] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[12].OBUF2  (.A(\REGF[2].RFW.q_wire[12] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[13].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[2].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[13].OBUF1  (.A(\REGF[2].RFW.q_wire[13] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[13].OBUF2  (.A(\REGF[2].RFW.q_wire[13] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[14].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[2].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[14].OBUF1  (.A(\REGF[2].RFW.q_wire[14] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[14].OBUF2  (.A(\REGF[2].RFW.q_wire[14] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[15].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[2].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[15].OBUF1  (.A(\REGF[2].RFW.q_wire[15] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[15].OBUF2  (.A(\REGF[2].RFW.q_wire[15] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[16].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[2].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[16].OBUF1  (.A(\REGF[2].RFW.q_wire[16] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[16].OBUF2  (.A(\REGF[2].RFW.q_wire[16] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[17].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[2].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[17].OBUF1  (.A(\REGF[2].RFW.q_wire[17] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[17].OBUF2  (.A(\REGF[2].RFW.q_wire[17] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[18].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[2].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[18].OBUF1  (.A(\REGF[2].RFW.q_wire[18] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[18].OBUF2  (.A(\REGF[2].RFW.q_wire[18] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[19].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[2].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[19].OBUF1  (.A(\REGF[2].RFW.q_wire[19] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[19].OBUF2  (.A(\REGF[2].RFW.q_wire[19] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[1].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[2].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[1].OBUF1  (.A(\REGF[2].RFW.q_wire[1] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[1].OBUF2  (.A(\REGF[2].RFW.q_wire[1] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[20].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[2].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[20].OBUF1  (.A(\REGF[2].RFW.q_wire[20] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[20].OBUF2  (.A(\REGF[2].RFW.q_wire[20] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[21].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[2].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[21].OBUF1  (.A(\REGF[2].RFW.q_wire[21] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[21].OBUF2  (.A(\REGF[2].RFW.q_wire[21] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[22].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[2].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[22].OBUF1  (.A(\REGF[2].RFW.q_wire[22] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[22].OBUF2  (.A(\REGF[2].RFW.q_wire[22] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[23].FF  (.CLK(\REGF[2].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[2].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[23].OBUF1  (.A(\REGF[2].RFW.q_wire[23] ),
    .TE_B(\REGF[2].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[23].OBUF2  (.A(\REGF[2].RFW.q_wire[23] ),
    .TE_B(\REGF[2].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[24].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[2].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[24].OBUF1  (.A(\REGF[2].RFW.q_wire[24] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[24].OBUF2  (.A(\REGF[2].RFW.q_wire[24] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[25].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[2].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[25].OBUF1  (.A(\REGF[2].RFW.q_wire[25] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[25].OBUF2  (.A(\REGF[2].RFW.q_wire[25] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[26].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[2].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[26].OBUF1  (.A(\REGF[2].RFW.q_wire[26] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[26].OBUF2  (.A(\REGF[2].RFW.q_wire[26] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[27].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[2].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[27].OBUF1  (.A(\REGF[2].RFW.q_wire[27] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[27].OBUF2  (.A(\REGF[2].RFW.q_wire[27] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[28].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[2].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[28].OBUF1  (.A(\REGF[2].RFW.q_wire[28] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[28].OBUF2  (.A(\REGF[2].RFW.q_wire[28] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[29].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[2].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[29].OBUF1  (.A(\REGF[2].RFW.q_wire[29] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[29].OBUF2  (.A(\REGF[2].RFW.q_wire[29] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[2].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[2].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[2].OBUF1  (.A(\REGF[2].RFW.q_wire[2] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[2].OBUF2  (.A(\REGF[2].RFW.q_wire[2] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[30].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[2].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[30].OBUF1  (.A(\REGF[2].RFW.q_wire[30] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[30].OBUF2  (.A(\REGF[2].RFW.q_wire[30] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[31].FF  (.CLK(\REGF[2].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[2].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[31].OBUF1  (.A(\REGF[2].RFW.q_wire[31] ),
    .TE_B(\REGF[2].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[31].OBUF2  (.A(\REGF[2].RFW.q_wire[31] ),
    .TE_B(\REGF[2].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[3].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[2].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[3].OBUF1  (.A(\REGF[2].RFW.q_wire[3] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[3].OBUF2  (.A(\REGF[2].RFW.q_wire[3] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[4].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[2].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[4].OBUF1  (.A(\REGF[2].RFW.q_wire[4] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[4].OBUF2  (.A(\REGF[2].RFW.q_wire[4] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[5].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[2].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[5].OBUF1  (.A(\REGF[2].RFW.q_wire[5] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[5].OBUF2  (.A(\REGF[2].RFW.q_wire[5] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[6].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[2].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[6].OBUF1  (.A(\REGF[2].RFW.q_wire[6] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[6].OBUF2  (.A(\REGF[2].RFW.q_wire[6] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[7].FF  (.CLK(\REGF[2].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[2].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[7].OBUF1  (.A(\REGF[2].RFW.q_wire[7] ),
    .TE_B(\REGF[2].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[7].OBUF2  (.A(\REGF[2].RFW.q_wire[7] ),
    .TE_B(\REGF[2].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[8].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[2].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[8].OBUF1  (.A(\REGF[2].RFW.q_wire[8] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[8].OBUF2  (.A(\REGF[2].RFW.q_wire[8] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[2].RFW.BIT[9].FF  (.CLK(\REGF[2].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[2].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[9].OBUF1  (.A(\REGF[2].RFW.q_wire[9] ),
    .TE_B(\REGF[2].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[2].RFW.BIT[9].OBUF2  (.A(\REGF[2].RFW.q_wire[9] ),
    .TE_B(\REGF[2].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[2].RFW.CGAND  (.A(\DEC2.D0.SEL[2] ),
    .B(WE),
    .X(\REGF[2].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[2].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[2].RFW.we_wire ),
    .GCLK(\REGF[2].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[2].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[2].RFW.we_wire ),
    .GCLK(\REGF[2].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[2].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[2].RFW.we_wire ),
    .GCLK(\REGF[2].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[2].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[2].RFW.we_wire ),
    .GCLK(\REGF[2].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV1[0]  (.A(\DEC0.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV1[1]  (.A(\DEC0.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV1[2]  (.A(\DEC0.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV1[3]  (.A(\DEC0.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV2[0]  (.A(\DEC1.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV2[1]  (.A(\DEC1.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV2[2]  (.A(\DEC1.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[2].RFW.INV2[3]  (.A(\DEC1.D0.SEL[2] ),
    .Y(\REGF[2].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[0].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[30].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[0].OBUF1  (.A(\REGF[30].RFW.q_wire[0] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[0].OBUF2  (.A(\REGF[30].RFW.q_wire[0] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[10].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[30].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[10].OBUF1  (.A(\REGF[30].RFW.q_wire[10] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[10].OBUF2  (.A(\REGF[30].RFW.q_wire[10] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[11].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[30].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[11].OBUF1  (.A(\REGF[30].RFW.q_wire[11] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[11].OBUF2  (.A(\REGF[30].RFW.q_wire[11] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[12].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[30].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[12].OBUF1  (.A(\REGF[30].RFW.q_wire[12] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[12].OBUF2  (.A(\REGF[30].RFW.q_wire[12] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[13].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[30].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[13].OBUF1  (.A(\REGF[30].RFW.q_wire[13] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[13].OBUF2  (.A(\REGF[30].RFW.q_wire[13] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[14].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[30].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[14].OBUF1  (.A(\REGF[30].RFW.q_wire[14] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[14].OBUF2  (.A(\REGF[30].RFW.q_wire[14] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[15].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[30].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[15].OBUF1  (.A(\REGF[30].RFW.q_wire[15] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[15].OBUF2  (.A(\REGF[30].RFW.q_wire[15] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[16].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[30].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[16].OBUF1  (.A(\REGF[30].RFW.q_wire[16] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[16].OBUF2  (.A(\REGF[30].RFW.q_wire[16] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[17].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[30].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[17].OBUF1  (.A(\REGF[30].RFW.q_wire[17] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[17].OBUF2  (.A(\REGF[30].RFW.q_wire[17] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[18].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[30].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[18].OBUF1  (.A(\REGF[30].RFW.q_wire[18] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[18].OBUF2  (.A(\REGF[30].RFW.q_wire[18] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[19].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[30].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[19].OBUF1  (.A(\REGF[30].RFW.q_wire[19] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[19].OBUF2  (.A(\REGF[30].RFW.q_wire[19] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[1].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[30].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[1].OBUF1  (.A(\REGF[30].RFW.q_wire[1] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[1].OBUF2  (.A(\REGF[30].RFW.q_wire[1] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[20].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[30].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[20].OBUF1  (.A(\REGF[30].RFW.q_wire[20] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[20].OBUF2  (.A(\REGF[30].RFW.q_wire[20] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[21].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[30].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[21].OBUF1  (.A(\REGF[30].RFW.q_wire[21] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[21].OBUF2  (.A(\REGF[30].RFW.q_wire[21] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[22].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[30].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[22].OBUF1  (.A(\REGF[30].RFW.q_wire[22] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[22].OBUF2  (.A(\REGF[30].RFW.q_wire[22] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[23].FF  (.CLK(\REGF[30].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[30].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[23].OBUF1  (.A(\REGF[30].RFW.q_wire[23] ),
    .TE_B(\REGF[30].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[23].OBUF2  (.A(\REGF[30].RFW.q_wire[23] ),
    .TE_B(\REGF[30].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[24].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[30].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[24].OBUF1  (.A(\REGF[30].RFW.q_wire[24] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[24].OBUF2  (.A(\REGF[30].RFW.q_wire[24] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[25].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[30].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[25].OBUF1  (.A(\REGF[30].RFW.q_wire[25] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[25].OBUF2  (.A(\REGF[30].RFW.q_wire[25] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[26].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[30].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[26].OBUF1  (.A(\REGF[30].RFW.q_wire[26] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[26].OBUF2  (.A(\REGF[30].RFW.q_wire[26] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[27].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[30].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[27].OBUF1  (.A(\REGF[30].RFW.q_wire[27] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[27].OBUF2  (.A(\REGF[30].RFW.q_wire[27] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[28].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[30].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[28].OBUF1  (.A(\REGF[30].RFW.q_wire[28] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[28].OBUF2  (.A(\REGF[30].RFW.q_wire[28] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[29].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[30].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[29].OBUF1  (.A(\REGF[30].RFW.q_wire[29] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[29].OBUF2  (.A(\REGF[30].RFW.q_wire[29] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[2].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[30].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[2].OBUF1  (.A(\REGF[30].RFW.q_wire[2] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[2].OBUF2  (.A(\REGF[30].RFW.q_wire[2] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[30].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[30].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[30].OBUF1  (.A(\REGF[30].RFW.q_wire[30] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[30].OBUF2  (.A(\REGF[30].RFW.q_wire[30] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[31].FF  (.CLK(\REGF[30].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[30].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[31].OBUF1  (.A(\REGF[30].RFW.q_wire[31] ),
    .TE_B(\REGF[30].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[31].OBUF2  (.A(\REGF[30].RFW.q_wire[31] ),
    .TE_B(\REGF[30].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[3].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[30].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[3].OBUF1  (.A(\REGF[30].RFW.q_wire[3] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[3].OBUF2  (.A(\REGF[30].RFW.q_wire[3] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[4].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[30].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[4].OBUF1  (.A(\REGF[30].RFW.q_wire[4] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[4].OBUF2  (.A(\REGF[30].RFW.q_wire[4] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[5].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[30].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[5].OBUF1  (.A(\REGF[30].RFW.q_wire[5] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[5].OBUF2  (.A(\REGF[30].RFW.q_wire[5] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[6].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[30].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[6].OBUF1  (.A(\REGF[30].RFW.q_wire[6] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[6].OBUF2  (.A(\REGF[30].RFW.q_wire[6] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[7].FF  (.CLK(\REGF[30].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[30].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[7].OBUF1  (.A(\REGF[30].RFW.q_wire[7] ),
    .TE_B(\REGF[30].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[7].OBUF2  (.A(\REGF[30].RFW.q_wire[7] ),
    .TE_B(\REGF[30].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[8].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[30].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[8].OBUF1  (.A(\REGF[30].RFW.q_wire[8] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[8].OBUF2  (.A(\REGF[30].RFW.q_wire[8] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[30].RFW.BIT[9].FF  (.CLK(\REGF[30].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[30].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[9].OBUF1  (.A(\REGF[30].RFW.q_wire[9] ),
    .TE_B(\REGF[30].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[30].RFW.BIT[9].OBUF2  (.A(\REGF[30].RFW.q_wire[9] ),
    .TE_B(\REGF[30].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[30].RFW.CGAND  (.A(\DEC2.D3.SEL[6] ),
    .B(WE),
    .X(\REGF[30].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[30].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[30].RFW.we_wire ),
    .GCLK(\REGF[30].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[30].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[30].RFW.we_wire ),
    .GCLK(\REGF[30].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[30].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[30].RFW.we_wire ),
    .GCLK(\REGF[30].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[30].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[30].RFW.we_wire ),
    .GCLK(\REGF[30].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV1[0]  (.A(\DEC0.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV1[1]  (.A(\DEC0.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV1[2]  (.A(\DEC0.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV1[3]  (.A(\DEC0.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV2[0]  (.A(\DEC1.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV2[1]  (.A(\DEC1.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV2[2]  (.A(\DEC1.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[30].RFW.INV2[3]  (.A(\DEC1.D3.SEL[6] ),
    .Y(\REGF[30].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[0].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[31].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[0].OBUF1  (.A(\REGF[31].RFW.q_wire[0] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[0].OBUF2  (.A(\REGF[31].RFW.q_wire[0] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[10].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[31].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[10].OBUF1  (.A(\REGF[31].RFW.q_wire[10] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[10].OBUF2  (.A(\REGF[31].RFW.q_wire[10] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[11].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[31].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[11].OBUF1  (.A(\REGF[31].RFW.q_wire[11] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[11].OBUF2  (.A(\REGF[31].RFW.q_wire[11] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[12].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[31].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[12].OBUF1  (.A(\REGF[31].RFW.q_wire[12] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[12].OBUF2  (.A(\REGF[31].RFW.q_wire[12] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[13].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[31].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[13].OBUF1  (.A(\REGF[31].RFW.q_wire[13] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[13].OBUF2  (.A(\REGF[31].RFW.q_wire[13] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[14].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[31].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[14].OBUF1  (.A(\REGF[31].RFW.q_wire[14] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[14].OBUF2  (.A(\REGF[31].RFW.q_wire[14] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[15].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[31].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[15].OBUF1  (.A(\REGF[31].RFW.q_wire[15] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[15].OBUF2  (.A(\REGF[31].RFW.q_wire[15] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[16].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[31].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[16].OBUF1  (.A(\REGF[31].RFW.q_wire[16] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[16].OBUF2  (.A(\REGF[31].RFW.q_wire[16] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[17].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[31].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[17].OBUF1  (.A(\REGF[31].RFW.q_wire[17] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[17].OBUF2  (.A(\REGF[31].RFW.q_wire[17] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[18].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[31].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[18].OBUF1  (.A(\REGF[31].RFW.q_wire[18] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[18].OBUF2  (.A(\REGF[31].RFW.q_wire[18] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[19].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[31].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[19].OBUF1  (.A(\REGF[31].RFW.q_wire[19] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[19].OBUF2  (.A(\REGF[31].RFW.q_wire[19] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[1].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[31].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[1].OBUF1  (.A(\REGF[31].RFW.q_wire[1] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[1].OBUF2  (.A(\REGF[31].RFW.q_wire[1] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[20].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[31].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[20].OBUF1  (.A(\REGF[31].RFW.q_wire[20] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[20].OBUF2  (.A(\REGF[31].RFW.q_wire[20] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[21].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[31].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[21].OBUF1  (.A(\REGF[31].RFW.q_wire[21] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[21].OBUF2  (.A(\REGF[31].RFW.q_wire[21] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[22].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[31].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[22].OBUF1  (.A(\REGF[31].RFW.q_wire[22] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[22].OBUF2  (.A(\REGF[31].RFW.q_wire[22] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[23].FF  (.CLK(\REGF[31].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[31].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[23].OBUF1  (.A(\REGF[31].RFW.q_wire[23] ),
    .TE_B(\REGF[31].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[23].OBUF2  (.A(\REGF[31].RFW.q_wire[23] ),
    .TE_B(\REGF[31].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[24].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[31].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[24].OBUF1  (.A(\REGF[31].RFW.q_wire[24] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[24].OBUF2  (.A(\REGF[31].RFW.q_wire[24] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[25].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[31].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[25].OBUF1  (.A(\REGF[31].RFW.q_wire[25] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[25].OBUF2  (.A(\REGF[31].RFW.q_wire[25] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[26].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[31].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[26].OBUF1  (.A(\REGF[31].RFW.q_wire[26] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[26].OBUF2  (.A(\REGF[31].RFW.q_wire[26] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[27].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[31].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[27].OBUF1  (.A(\REGF[31].RFW.q_wire[27] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[27].OBUF2  (.A(\REGF[31].RFW.q_wire[27] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[28].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[31].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[28].OBUF1  (.A(\REGF[31].RFW.q_wire[28] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[28].OBUF2  (.A(\REGF[31].RFW.q_wire[28] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[29].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[31].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[29].OBUF1  (.A(\REGF[31].RFW.q_wire[29] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[29].OBUF2  (.A(\REGF[31].RFW.q_wire[29] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[2].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[31].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[2].OBUF1  (.A(\REGF[31].RFW.q_wire[2] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[2].OBUF2  (.A(\REGF[31].RFW.q_wire[2] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[30].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[31].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[30].OBUF1  (.A(\REGF[31].RFW.q_wire[30] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[30].OBUF2  (.A(\REGF[31].RFW.q_wire[30] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[31].FF  (.CLK(\REGF[31].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[31].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[31].OBUF1  (.A(\REGF[31].RFW.q_wire[31] ),
    .TE_B(\REGF[31].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[31].OBUF2  (.A(\REGF[31].RFW.q_wire[31] ),
    .TE_B(\REGF[31].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[3].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[31].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[3].OBUF1  (.A(\REGF[31].RFW.q_wire[3] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[3].OBUF2  (.A(\REGF[31].RFW.q_wire[3] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[4].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[31].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[4].OBUF1  (.A(\REGF[31].RFW.q_wire[4] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[4].OBUF2  (.A(\REGF[31].RFW.q_wire[4] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[5].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[31].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[5].OBUF1  (.A(\REGF[31].RFW.q_wire[5] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[5].OBUF2  (.A(\REGF[31].RFW.q_wire[5] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[6].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[31].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[6].OBUF1  (.A(\REGF[31].RFW.q_wire[6] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[6].OBUF2  (.A(\REGF[31].RFW.q_wire[6] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[7].FF  (.CLK(\REGF[31].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[31].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[7].OBUF1  (.A(\REGF[31].RFW.q_wire[7] ),
    .TE_B(\REGF[31].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[7].OBUF2  (.A(\REGF[31].RFW.q_wire[7] ),
    .TE_B(\REGF[31].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[8].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[31].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[8].OBUF1  (.A(\REGF[31].RFW.q_wire[8] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[8].OBUF2  (.A(\REGF[31].RFW.q_wire[8] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[31].RFW.BIT[9].FF  (.CLK(\REGF[31].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[31].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[9].OBUF1  (.A(\REGF[31].RFW.q_wire[9] ),
    .TE_B(\REGF[31].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[31].RFW.BIT[9].OBUF2  (.A(\REGF[31].RFW.q_wire[9] ),
    .TE_B(\REGF[31].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[31].RFW.CGAND  (.A(\DEC2.D3.SEL[7] ),
    .B(WE),
    .X(\REGF[31].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[31].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[31].RFW.we_wire ),
    .GCLK(\REGF[31].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[31].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[31].RFW.we_wire ),
    .GCLK(\REGF[31].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[31].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[31].RFW.we_wire ),
    .GCLK(\REGF[31].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[31].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[31].RFW.we_wire ),
    .GCLK(\REGF[31].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV1[0]  (.A(\DEC0.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV1[1]  (.A(\DEC0.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV1[2]  (.A(\DEC0.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV1[3]  (.A(\DEC0.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV2[0]  (.A(\DEC1.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV2[1]  (.A(\DEC1.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV2[2]  (.A(\DEC1.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[31].RFW.INV2[3]  (.A(\DEC1.D3.SEL[7] ),
    .Y(\REGF[31].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[0].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[3].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[0].OBUF1  (.A(\REGF[3].RFW.q_wire[0] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[0].OBUF2  (.A(\REGF[3].RFW.q_wire[0] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[10].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[3].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[10].OBUF1  (.A(\REGF[3].RFW.q_wire[10] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[10].OBUF2  (.A(\REGF[3].RFW.q_wire[10] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[11].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[3].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[11].OBUF1  (.A(\REGF[3].RFW.q_wire[11] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[11].OBUF2  (.A(\REGF[3].RFW.q_wire[11] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[12].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[3].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[12].OBUF1  (.A(\REGF[3].RFW.q_wire[12] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[12].OBUF2  (.A(\REGF[3].RFW.q_wire[12] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[13].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[3].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[13].OBUF1  (.A(\REGF[3].RFW.q_wire[13] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[13].OBUF2  (.A(\REGF[3].RFW.q_wire[13] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[14].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[3].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[14].OBUF1  (.A(\REGF[3].RFW.q_wire[14] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[14].OBUF2  (.A(\REGF[3].RFW.q_wire[14] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[15].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[3].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[15].OBUF1  (.A(\REGF[3].RFW.q_wire[15] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[15].OBUF2  (.A(\REGF[3].RFW.q_wire[15] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[16].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[3].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[16].OBUF1  (.A(\REGF[3].RFW.q_wire[16] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[16].OBUF2  (.A(\REGF[3].RFW.q_wire[16] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[17].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[3].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[17].OBUF1  (.A(\REGF[3].RFW.q_wire[17] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[17].OBUF2  (.A(\REGF[3].RFW.q_wire[17] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[18].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[3].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[18].OBUF1  (.A(\REGF[3].RFW.q_wire[18] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[18].OBUF2  (.A(\REGF[3].RFW.q_wire[18] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[19].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[3].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[19].OBUF1  (.A(\REGF[3].RFW.q_wire[19] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[19].OBUF2  (.A(\REGF[3].RFW.q_wire[19] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[1].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[3].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[1].OBUF1  (.A(\REGF[3].RFW.q_wire[1] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[1].OBUF2  (.A(\REGF[3].RFW.q_wire[1] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[20].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[3].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[20].OBUF1  (.A(\REGF[3].RFW.q_wire[20] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[20].OBUF2  (.A(\REGF[3].RFW.q_wire[20] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[21].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[3].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[21].OBUF1  (.A(\REGF[3].RFW.q_wire[21] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[21].OBUF2  (.A(\REGF[3].RFW.q_wire[21] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[22].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[3].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[22].OBUF1  (.A(\REGF[3].RFW.q_wire[22] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[22].OBUF2  (.A(\REGF[3].RFW.q_wire[22] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[23].FF  (.CLK(\REGF[3].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[3].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[23].OBUF1  (.A(\REGF[3].RFW.q_wire[23] ),
    .TE_B(\REGF[3].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[23].OBUF2  (.A(\REGF[3].RFW.q_wire[23] ),
    .TE_B(\REGF[3].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[24].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[3].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[24].OBUF1  (.A(\REGF[3].RFW.q_wire[24] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[24].OBUF2  (.A(\REGF[3].RFW.q_wire[24] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[25].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[3].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[25].OBUF1  (.A(\REGF[3].RFW.q_wire[25] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[25].OBUF2  (.A(\REGF[3].RFW.q_wire[25] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[26].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[3].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[26].OBUF1  (.A(\REGF[3].RFW.q_wire[26] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[26].OBUF2  (.A(\REGF[3].RFW.q_wire[26] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[27].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[3].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[27].OBUF1  (.A(\REGF[3].RFW.q_wire[27] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[27].OBUF2  (.A(\REGF[3].RFW.q_wire[27] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[28].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[3].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[28].OBUF1  (.A(\REGF[3].RFW.q_wire[28] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[28].OBUF2  (.A(\REGF[3].RFW.q_wire[28] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[29].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[3].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[29].OBUF1  (.A(\REGF[3].RFW.q_wire[29] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[29].OBUF2  (.A(\REGF[3].RFW.q_wire[29] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[2].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[3].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[2].OBUF1  (.A(\REGF[3].RFW.q_wire[2] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[2].OBUF2  (.A(\REGF[3].RFW.q_wire[2] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[30].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[3].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[30].OBUF1  (.A(\REGF[3].RFW.q_wire[30] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[30].OBUF2  (.A(\REGF[3].RFW.q_wire[30] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[31].FF  (.CLK(\REGF[3].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[3].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[31].OBUF1  (.A(\REGF[3].RFW.q_wire[31] ),
    .TE_B(\REGF[3].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[31].OBUF2  (.A(\REGF[3].RFW.q_wire[31] ),
    .TE_B(\REGF[3].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[3].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[3].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[3].OBUF1  (.A(\REGF[3].RFW.q_wire[3] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[3].OBUF2  (.A(\REGF[3].RFW.q_wire[3] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[4].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[3].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[4].OBUF1  (.A(\REGF[3].RFW.q_wire[4] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[4].OBUF2  (.A(\REGF[3].RFW.q_wire[4] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[5].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[3].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[5].OBUF1  (.A(\REGF[3].RFW.q_wire[5] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[5].OBUF2  (.A(\REGF[3].RFW.q_wire[5] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[6].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[3].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[6].OBUF1  (.A(\REGF[3].RFW.q_wire[6] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[6].OBUF2  (.A(\REGF[3].RFW.q_wire[6] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[7].FF  (.CLK(\REGF[3].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[3].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[7].OBUF1  (.A(\REGF[3].RFW.q_wire[7] ),
    .TE_B(\REGF[3].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[7].OBUF2  (.A(\REGF[3].RFW.q_wire[7] ),
    .TE_B(\REGF[3].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[8].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[3].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[8].OBUF1  (.A(\REGF[3].RFW.q_wire[8] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[8].OBUF2  (.A(\REGF[3].RFW.q_wire[8] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[3].RFW.BIT[9].FF  (.CLK(\REGF[3].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[3].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[9].OBUF1  (.A(\REGF[3].RFW.q_wire[9] ),
    .TE_B(\REGF[3].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[3].RFW.BIT[9].OBUF2  (.A(\REGF[3].RFW.q_wire[9] ),
    .TE_B(\REGF[3].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[3].RFW.CGAND  (.A(\DEC2.D0.SEL[3] ),
    .B(WE),
    .X(\REGF[3].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[3].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[3].RFW.we_wire ),
    .GCLK(\REGF[3].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[3].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[3].RFW.we_wire ),
    .GCLK(\REGF[3].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[3].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[3].RFW.we_wire ),
    .GCLK(\REGF[3].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[3].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[3].RFW.we_wire ),
    .GCLK(\REGF[3].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV1[0]  (.A(\DEC0.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV1[1]  (.A(\DEC0.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV1[2]  (.A(\DEC0.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV1[3]  (.A(\DEC0.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV2[0]  (.A(\DEC1.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV2[1]  (.A(\DEC1.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV2[2]  (.A(\DEC1.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[3].RFW.INV2[3]  (.A(\DEC1.D0.SEL[3] ),
    .Y(\REGF[3].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[0].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[4].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[0].OBUF1  (.A(\REGF[4].RFW.q_wire[0] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[0].OBUF2  (.A(\REGF[4].RFW.q_wire[0] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[10].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[4].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[10].OBUF1  (.A(\REGF[4].RFW.q_wire[10] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[10].OBUF2  (.A(\REGF[4].RFW.q_wire[10] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[11].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[4].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[11].OBUF1  (.A(\REGF[4].RFW.q_wire[11] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[11].OBUF2  (.A(\REGF[4].RFW.q_wire[11] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[12].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[4].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[12].OBUF1  (.A(\REGF[4].RFW.q_wire[12] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[12].OBUF2  (.A(\REGF[4].RFW.q_wire[12] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[13].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[4].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[13].OBUF1  (.A(\REGF[4].RFW.q_wire[13] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[13].OBUF2  (.A(\REGF[4].RFW.q_wire[13] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[14].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[4].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[14].OBUF1  (.A(\REGF[4].RFW.q_wire[14] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[14].OBUF2  (.A(\REGF[4].RFW.q_wire[14] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[15].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[4].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[15].OBUF1  (.A(\REGF[4].RFW.q_wire[15] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[15].OBUF2  (.A(\REGF[4].RFW.q_wire[15] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[16].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[4].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[16].OBUF1  (.A(\REGF[4].RFW.q_wire[16] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[16].OBUF2  (.A(\REGF[4].RFW.q_wire[16] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[17].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[4].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[17].OBUF1  (.A(\REGF[4].RFW.q_wire[17] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[17].OBUF2  (.A(\REGF[4].RFW.q_wire[17] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[18].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[4].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[18].OBUF1  (.A(\REGF[4].RFW.q_wire[18] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[18].OBUF2  (.A(\REGF[4].RFW.q_wire[18] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[19].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[4].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[19].OBUF1  (.A(\REGF[4].RFW.q_wire[19] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[19].OBUF2  (.A(\REGF[4].RFW.q_wire[19] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[1].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[4].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[1].OBUF1  (.A(\REGF[4].RFW.q_wire[1] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[1].OBUF2  (.A(\REGF[4].RFW.q_wire[1] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[20].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[4].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[20].OBUF1  (.A(\REGF[4].RFW.q_wire[20] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[20].OBUF2  (.A(\REGF[4].RFW.q_wire[20] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[21].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[4].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[21].OBUF1  (.A(\REGF[4].RFW.q_wire[21] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[21].OBUF2  (.A(\REGF[4].RFW.q_wire[21] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[22].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[4].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[22].OBUF1  (.A(\REGF[4].RFW.q_wire[22] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[22].OBUF2  (.A(\REGF[4].RFW.q_wire[22] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[23].FF  (.CLK(\REGF[4].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[4].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[23].OBUF1  (.A(\REGF[4].RFW.q_wire[23] ),
    .TE_B(\REGF[4].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[23].OBUF2  (.A(\REGF[4].RFW.q_wire[23] ),
    .TE_B(\REGF[4].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[24].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[4].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[24].OBUF1  (.A(\REGF[4].RFW.q_wire[24] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[24].OBUF2  (.A(\REGF[4].RFW.q_wire[24] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[25].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[4].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[25].OBUF1  (.A(\REGF[4].RFW.q_wire[25] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[25].OBUF2  (.A(\REGF[4].RFW.q_wire[25] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[26].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[4].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[26].OBUF1  (.A(\REGF[4].RFW.q_wire[26] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[26].OBUF2  (.A(\REGF[4].RFW.q_wire[26] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[27].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[4].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[27].OBUF1  (.A(\REGF[4].RFW.q_wire[27] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[27].OBUF2  (.A(\REGF[4].RFW.q_wire[27] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[28].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[4].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[28].OBUF1  (.A(\REGF[4].RFW.q_wire[28] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[28].OBUF2  (.A(\REGF[4].RFW.q_wire[28] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[29].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[4].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[29].OBUF1  (.A(\REGF[4].RFW.q_wire[29] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[29].OBUF2  (.A(\REGF[4].RFW.q_wire[29] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[2].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[4].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[2].OBUF1  (.A(\REGF[4].RFW.q_wire[2] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[2].OBUF2  (.A(\REGF[4].RFW.q_wire[2] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[30].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[4].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[30].OBUF1  (.A(\REGF[4].RFW.q_wire[30] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[30].OBUF2  (.A(\REGF[4].RFW.q_wire[30] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[31].FF  (.CLK(\REGF[4].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[4].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[31].OBUF1  (.A(\REGF[4].RFW.q_wire[31] ),
    .TE_B(\REGF[4].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[31].OBUF2  (.A(\REGF[4].RFW.q_wire[31] ),
    .TE_B(\REGF[4].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[3].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[4].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[3].OBUF1  (.A(\REGF[4].RFW.q_wire[3] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[3].OBUF2  (.A(\REGF[4].RFW.q_wire[3] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[4].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[4].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[4].OBUF1  (.A(\REGF[4].RFW.q_wire[4] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[4].OBUF2  (.A(\REGF[4].RFW.q_wire[4] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[5].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[4].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[5].OBUF1  (.A(\REGF[4].RFW.q_wire[5] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[5].OBUF2  (.A(\REGF[4].RFW.q_wire[5] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[6].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[4].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[6].OBUF1  (.A(\REGF[4].RFW.q_wire[6] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[6].OBUF2  (.A(\REGF[4].RFW.q_wire[6] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[7].FF  (.CLK(\REGF[4].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[4].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[7].OBUF1  (.A(\REGF[4].RFW.q_wire[7] ),
    .TE_B(\REGF[4].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[7].OBUF2  (.A(\REGF[4].RFW.q_wire[7] ),
    .TE_B(\REGF[4].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[8].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[4].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[8].OBUF1  (.A(\REGF[4].RFW.q_wire[8] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[8].OBUF2  (.A(\REGF[4].RFW.q_wire[8] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[4].RFW.BIT[9].FF  (.CLK(\REGF[4].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[4].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[9].OBUF1  (.A(\REGF[4].RFW.q_wire[9] ),
    .TE_B(\REGF[4].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[4].RFW.BIT[9].OBUF2  (.A(\REGF[4].RFW.q_wire[9] ),
    .TE_B(\REGF[4].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[4].RFW.CGAND  (.A(\DEC2.D0.SEL[4] ),
    .B(WE),
    .X(\REGF[4].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[4].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[4].RFW.we_wire ),
    .GCLK(\REGF[4].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[4].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[4].RFW.we_wire ),
    .GCLK(\REGF[4].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[4].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[4].RFW.we_wire ),
    .GCLK(\REGF[4].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[4].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[4].RFW.we_wire ),
    .GCLK(\REGF[4].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV1[0]  (.A(\DEC0.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV1[1]  (.A(\DEC0.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV1[2]  (.A(\DEC0.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV1[3]  (.A(\DEC0.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV2[0]  (.A(\DEC1.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV2[1]  (.A(\DEC1.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV2[2]  (.A(\DEC1.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[4].RFW.INV2[3]  (.A(\DEC1.D0.SEL[4] ),
    .Y(\REGF[4].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[0].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[5].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[0].OBUF1  (.A(\REGF[5].RFW.q_wire[0] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[0].OBUF2  (.A(\REGF[5].RFW.q_wire[0] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[10].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[5].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[10].OBUF1  (.A(\REGF[5].RFW.q_wire[10] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[10].OBUF2  (.A(\REGF[5].RFW.q_wire[10] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[11].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[5].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[11].OBUF1  (.A(\REGF[5].RFW.q_wire[11] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[11].OBUF2  (.A(\REGF[5].RFW.q_wire[11] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[12].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[5].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[12].OBUF1  (.A(\REGF[5].RFW.q_wire[12] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[12].OBUF2  (.A(\REGF[5].RFW.q_wire[12] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[13].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[5].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[13].OBUF1  (.A(\REGF[5].RFW.q_wire[13] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[13].OBUF2  (.A(\REGF[5].RFW.q_wire[13] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[14].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[5].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[14].OBUF1  (.A(\REGF[5].RFW.q_wire[14] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[14].OBUF2  (.A(\REGF[5].RFW.q_wire[14] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[15].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[5].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[15].OBUF1  (.A(\REGF[5].RFW.q_wire[15] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[15].OBUF2  (.A(\REGF[5].RFW.q_wire[15] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[16].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[5].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[16].OBUF1  (.A(\REGF[5].RFW.q_wire[16] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[16].OBUF2  (.A(\REGF[5].RFW.q_wire[16] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[17].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[5].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[17].OBUF1  (.A(\REGF[5].RFW.q_wire[17] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[17].OBUF2  (.A(\REGF[5].RFW.q_wire[17] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[18].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[5].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[18].OBUF1  (.A(\REGF[5].RFW.q_wire[18] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[18].OBUF2  (.A(\REGF[5].RFW.q_wire[18] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[19].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[5].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[19].OBUF1  (.A(\REGF[5].RFW.q_wire[19] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[19].OBUF2  (.A(\REGF[5].RFW.q_wire[19] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[1].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[5].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[1].OBUF1  (.A(\REGF[5].RFW.q_wire[1] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[1].OBUF2  (.A(\REGF[5].RFW.q_wire[1] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[20].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[5].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[20].OBUF1  (.A(\REGF[5].RFW.q_wire[20] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[20].OBUF2  (.A(\REGF[5].RFW.q_wire[20] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[21].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[5].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[21].OBUF1  (.A(\REGF[5].RFW.q_wire[21] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[21].OBUF2  (.A(\REGF[5].RFW.q_wire[21] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[22].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[5].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[22].OBUF1  (.A(\REGF[5].RFW.q_wire[22] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[22].OBUF2  (.A(\REGF[5].RFW.q_wire[22] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[23].FF  (.CLK(\REGF[5].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[5].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[23].OBUF1  (.A(\REGF[5].RFW.q_wire[23] ),
    .TE_B(\REGF[5].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[23].OBUF2  (.A(\REGF[5].RFW.q_wire[23] ),
    .TE_B(\REGF[5].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[24].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[5].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[24].OBUF1  (.A(\REGF[5].RFW.q_wire[24] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[24].OBUF2  (.A(\REGF[5].RFW.q_wire[24] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[25].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[5].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[25].OBUF1  (.A(\REGF[5].RFW.q_wire[25] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[25].OBUF2  (.A(\REGF[5].RFW.q_wire[25] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[26].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[5].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[26].OBUF1  (.A(\REGF[5].RFW.q_wire[26] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[26].OBUF2  (.A(\REGF[5].RFW.q_wire[26] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[27].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[5].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[27].OBUF1  (.A(\REGF[5].RFW.q_wire[27] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[27].OBUF2  (.A(\REGF[5].RFW.q_wire[27] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[28].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[5].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[28].OBUF1  (.A(\REGF[5].RFW.q_wire[28] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[28].OBUF2  (.A(\REGF[5].RFW.q_wire[28] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[29].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[5].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[29].OBUF1  (.A(\REGF[5].RFW.q_wire[29] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[29].OBUF2  (.A(\REGF[5].RFW.q_wire[29] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[2].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[5].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[2].OBUF1  (.A(\REGF[5].RFW.q_wire[2] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[2].OBUF2  (.A(\REGF[5].RFW.q_wire[2] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[30].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[5].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[30].OBUF1  (.A(\REGF[5].RFW.q_wire[30] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[30].OBUF2  (.A(\REGF[5].RFW.q_wire[30] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[31].FF  (.CLK(\REGF[5].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[5].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[31].OBUF1  (.A(\REGF[5].RFW.q_wire[31] ),
    .TE_B(\REGF[5].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[31].OBUF2  (.A(\REGF[5].RFW.q_wire[31] ),
    .TE_B(\REGF[5].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[3].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[5].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[3].OBUF1  (.A(\REGF[5].RFW.q_wire[3] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[3].OBUF2  (.A(\REGF[5].RFW.q_wire[3] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[4].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[5].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[4].OBUF1  (.A(\REGF[5].RFW.q_wire[4] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[4].OBUF2  (.A(\REGF[5].RFW.q_wire[4] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[5].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[5].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[5].OBUF1  (.A(\REGF[5].RFW.q_wire[5] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[5].OBUF2  (.A(\REGF[5].RFW.q_wire[5] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[6].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[5].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[6].OBUF1  (.A(\REGF[5].RFW.q_wire[6] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[6].OBUF2  (.A(\REGF[5].RFW.q_wire[6] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[7].FF  (.CLK(\REGF[5].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[5].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[7].OBUF1  (.A(\REGF[5].RFW.q_wire[7] ),
    .TE_B(\REGF[5].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[7].OBUF2  (.A(\REGF[5].RFW.q_wire[7] ),
    .TE_B(\REGF[5].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[8].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[5].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[8].OBUF1  (.A(\REGF[5].RFW.q_wire[8] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[8].OBUF2  (.A(\REGF[5].RFW.q_wire[8] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[5].RFW.BIT[9].FF  (.CLK(\REGF[5].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[5].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[9].OBUF1  (.A(\REGF[5].RFW.q_wire[9] ),
    .TE_B(\REGF[5].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[5].RFW.BIT[9].OBUF2  (.A(\REGF[5].RFW.q_wire[9] ),
    .TE_B(\REGF[5].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[5].RFW.CGAND  (.A(\DEC2.D0.SEL[5] ),
    .B(WE),
    .X(\REGF[5].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[5].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[5].RFW.we_wire ),
    .GCLK(\REGF[5].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[5].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[5].RFW.we_wire ),
    .GCLK(\REGF[5].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[5].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[5].RFW.we_wire ),
    .GCLK(\REGF[5].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[5].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[5].RFW.we_wire ),
    .GCLK(\REGF[5].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV1[0]  (.A(\DEC0.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV1[1]  (.A(\DEC0.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV1[2]  (.A(\DEC0.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV1[3]  (.A(\DEC0.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV2[0]  (.A(\DEC1.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV2[1]  (.A(\DEC1.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV2[2]  (.A(\DEC1.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[5].RFW.INV2[3]  (.A(\DEC1.D0.SEL[5] ),
    .Y(\REGF[5].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[0].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[6].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[0].OBUF1  (.A(\REGF[6].RFW.q_wire[0] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[0].OBUF2  (.A(\REGF[6].RFW.q_wire[0] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[10].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[6].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[10].OBUF1  (.A(\REGF[6].RFW.q_wire[10] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[10].OBUF2  (.A(\REGF[6].RFW.q_wire[10] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[11].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[6].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[11].OBUF1  (.A(\REGF[6].RFW.q_wire[11] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[11].OBUF2  (.A(\REGF[6].RFW.q_wire[11] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[12].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[6].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[12].OBUF1  (.A(\REGF[6].RFW.q_wire[12] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[12].OBUF2  (.A(\REGF[6].RFW.q_wire[12] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[13].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[6].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[13].OBUF1  (.A(\REGF[6].RFW.q_wire[13] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[13].OBUF2  (.A(\REGF[6].RFW.q_wire[13] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[14].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[6].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[14].OBUF1  (.A(\REGF[6].RFW.q_wire[14] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[14].OBUF2  (.A(\REGF[6].RFW.q_wire[14] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[15].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[6].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[15].OBUF1  (.A(\REGF[6].RFW.q_wire[15] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[15].OBUF2  (.A(\REGF[6].RFW.q_wire[15] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[16].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[6].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[16].OBUF1  (.A(\REGF[6].RFW.q_wire[16] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[16].OBUF2  (.A(\REGF[6].RFW.q_wire[16] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[17].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[6].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[17].OBUF1  (.A(\REGF[6].RFW.q_wire[17] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[17].OBUF2  (.A(\REGF[6].RFW.q_wire[17] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[18].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[6].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[18].OBUF1  (.A(\REGF[6].RFW.q_wire[18] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[18].OBUF2  (.A(\REGF[6].RFW.q_wire[18] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[19].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[6].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[19].OBUF1  (.A(\REGF[6].RFW.q_wire[19] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[19].OBUF2  (.A(\REGF[6].RFW.q_wire[19] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[1].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[6].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[1].OBUF1  (.A(\REGF[6].RFW.q_wire[1] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[1].OBUF2  (.A(\REGF[6].RFW.q_wire[1] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[20].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[6].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[20].OBUF1  (.A(\REGF[6].RFW.q_wire[20] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[20].OBUF2  (.A(\REGF[6].RFW.q_wire[20] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[21].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[6].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[21].OBUF1  (.A(\REGF[6].RFW.q_wire[21] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[21].OBUF2  (.A(\REGF[6].RFW.q_wire[21] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[22].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[6].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[22].OBUF1  (.A(\REGF[6].RFW.q_wire[22] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[22].OBUF2  (.A(\REGF[6].RFW.q_wire[22] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[23].FF  (.CLK(\REGF[6].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[6].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[23].OBUF1  (.A(\REGF[6].RFW.q_wire[23] ),
    .TE_B(\REGF[6].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[23].OBUF2  (.A(\REGF[6].RFW.q_wire[23] ),
    .TE_B(\REGF[6].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[24].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[6].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[24].OBUF1  (.A(\REGF[6].RFW.q_wire[24] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[24].OBUF2  (.A(\REGF[6].RFW.q_wire[24] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[25].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[6].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[25].OBUF1  (.A(\REGF[6].RFW.q_wire[25] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[25].OBUF2  (.A(\REGF[6].RFW.q_wire[25] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[26].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[6].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[26].OBUF1  (.A(\REGF[6].RFW.q_wire[26] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[26].OBUF2  (.A(\REGF[6].RFW.q_wire[26] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[27].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[6].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[27].OBUF1  (.A(\REGF[6].RFW.q_wire[27] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[27].OBUF2  (.A(\REGF[6].RFW.q_wire[27] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[28].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[6].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[28].OBUF1  (.A(\REGF[6].RFW.q_wire[28] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[28].OBUF2  (.A(\REGF[6].RFW.q_wire[28] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[29].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[6].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[29].OBUF1  (.A(\REGF[6].RFW.q_wire[29] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[29].OBUF2  (.A(\REGF[6].RFW.q_wire[29] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[2].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[6].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[2].OBUF1  (.A(\REGF[6].RFW.q_wire[2] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[2].OBUF2  (.A(\REGF[6].RFW.q_wire[2] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[30].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[6].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[30].OBUF1  (.A(\REGF[6].RFW.q_wire[30] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[30].OBUF2  (.A(\REGF[6].RFW.q_wire[30] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[31].FF  (.CLK(\REGF[6].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[6].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[31].OBUF1  (.A(\REGF[6].RFW.q_wire[31] ),
    .TE_B(\REGF[6].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[31].OBUF2  (.A(\REGF[6].RFW.q_wire[31] ),
    .TE_B(\REGF[6].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[3].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[6].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[3].OBUF1  (.A(\REGF[6].RFW.q_wire[3] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[3].OBUF2  (.A(\REGF[6].RFW.q_wire[3] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[4].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[6].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[4].OBUF1  (.A(\REGF[6].RFW.q_wire[4] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[4].OBUF2  (.A(\REGF[6].RFW.q_wire[4] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[5].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[6].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[5].OBUF1  (.A(\REGF[6].RFW.q_wire[5] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[5].OBUF2  (.A(\REGF[6].RFW.q_wire[5] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[6].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[6].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[6].OBUF1  (.A(\REGF[6].RFW.q_wire[6] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[6].OBUF2  (.A(\REGF[6].RFW.q_wire[6] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[7].FF  (.CLK(\REGF[6].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[6].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[7].OBUF1  (.A(\REGF[6].RFW.q_wire[7] ),
    .TE_B(\REGF[6].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[7].OBUF2  (.A(\REGF[6].RFW.q_wire[7] ),
    .TE_B(\REGF[6].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[8].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[6].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[8].OBUF1  (.A(\REGF[6].RFW.q_wire[8] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[8].OBUF2  (.A(\REGF[6].RFW.q_wire[8] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[6].RFW.BIT[9].FF  (.CLK(\REGF[6].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[6].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[9].OBUF1  (.A(\REGF[6].RFW.q_wire[9] ),
    .TE_B(\REGF[6].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[6].RFW.BIT[9].OBUF2  (.A(\REGF[6].RFW.q_wire[9] ),
    .TE_B(\REGF[6].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[6].RFW.CGAND  (.A(\DEC2.D0.SEL[6] ),
    .B(WE),
    .X(\REGF[6].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[6].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[6].RFW.we_wire ),
    .GCLK(\REGF[6].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[6].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[6].RFW.we_wire ),
    .GCLK(\REGF[6].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[6].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[6].RFW.we_wire ),
    .GCLK(\REGF[6].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[6].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[6].RFW.we_wire ),
    .GCLK(\REGF[6].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV1[0]  (.A(\DEC0.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV1[1]  (.A(\DEC0.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV1[2]  (.A(\DEC0.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV1[3]  (.A(\DEC0.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV2[0]  (.A(\DEC1.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV2[1]  (.A(\DEC1.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV2[2]  (.A(\DEC1.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[6].RFW.INV2[3]  (.A(\DEC1.D0.SEL[6] ),
    .Y(\REGF[6].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[0].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[7].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[0].OBUF1  (.A(\REGF[7].RFW.q_wire[0] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[0].OBUF2  (.A(\REGF[7].RFW.q_wire[0] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[10].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[7].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[10].OBUF1  (.A(\REGF[7].RFW.q_wire[10] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[10].OBUF2  (.A(\REGF[7].RFW.q_wire[10] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[11].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[7].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[11].OBUF1  (.A(\REGF[7].RFW.q_wire[11] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[11].OBUF2  (.A(\REGF[7].RFW.q_wire[11] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[12].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[7].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[12].OBUF1  (.A(\REGF[7].RFW.q_wire[12] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[12].OBUF2  (.A(\REGF[7].RFW.q_wire[12] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[13].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[7].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[13].OBUF1  (.A(\REGF[7].RFW.q_wire[13] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[13].OBUF2  (.A(\REGF[7].RFW.q_wire[13] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[14].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[7].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[14].OBUF1  (.A(\REGF[7].RFW.q_wire[14] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[14].OBUF2  (.A(\REGF[7].RFW.q_wire[14] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[15].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[7].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[15].OBUF1  (.A(\REGF[7].RFW.q_wire[15] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[15].OBUF2  (.A(\REGF[7].RFW.q_wire[15] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[16].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[7].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[16].OBUF1  (.A(\REGF[7].RFW.q_wire[16] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[16].OBUF2  (.A(\REGF[7].RFW.q_wire[16] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[17].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[7].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[17].OBUF1  (.A(\REGF[7].RFW.q_wire[17] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[17].OBUF2  (.A(\REGF[7].RFW.q_wire[17] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[18].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[7].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[18].OBUF1  (.A(\REGF[7].RFW.q_wire[18] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[18].OBUF2  (.A(\REGF[7].RFW.q_wire[18] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[19].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[7].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[19].OBUF1  (.A(\REGF[7].RFW.q_wire[19] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[19].OBUF2  (.A(\REGF[7].RFW.q_wire[19] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[1].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[7].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[1].OBUF1  (.A(\REGF[7].RFW.q_wire[1] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[1].OBUF2  (.A(\REGF[7].RFW.q_wire[1] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[20].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[7].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[20].OBUF1  (.A(\REGF[7].RFW.q_wire[20] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[20].OBUF2  (.A(\REGF[7].RFW.q_wire[20] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[21].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[7].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[21].OBUF1  (.A(\REGF[7].RFW.q_wire[21] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[21].OBUF2  (.A(\REGF[7].RFW.q_wire[21] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[22].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[7].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[22].OBUF1  (.A(\REGF[7].RFW.q_wire[22] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[22].OBUF2  (.A(\REGF[7].RFW.q_wire[22] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[23].FF  (.CLK(\REGF[7].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[7].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[23].OBUF1  (.A(\REGF[7].RFW.q_wire[23] ),
    .TE_B(\REGF[7].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[23].OBUF2  (.A(\REGF[7].RFW.q_wire[23] ),
    .TE_B(\REGF[7].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[24].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[7].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[24].OBUF1  (.A(\REGF[7].RFW.q_wire[24] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[24].OBUF2  (.A(\REGF[7].RFW.q_wire[24] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[25].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[7].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[25].OBUF1  (.A(\REGF[7].RFW.q_wire[25] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[25].OBUF2  (.A(\REGF[7].RFW.q_wire[25] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[26].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[7].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[26].OBUF1  (.A(\REGF[7].RFW.q_wire[26] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[26].OBUF2  (.A(\REGF[7].RFW.q_wire[26] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[27].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[7].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[27].OBUF1  (.A(\REGF[7].RFW.q_wire[27] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[27].OBUF2  (.A(\REGF[7].RFW.q_wire[27] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[28].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[7].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[28].OBUF1  (.A(\REGF[7].RFW.q_wire[28] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[28].OBUF2  (.A(\REGF[7].RFW.q_wire[28] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[29].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[7].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[29].OBUF1  (.A(\REGF[7].RFW.q_wire[29] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[29].OBUF2  (.A(\REGF[7].RFW.q_wire[29] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[2].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[7].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[2].OBUF1  (.A(\REGF[7].RFW.q_wire[2] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[2].OBUF2  (.A(\REGF[7].RFW.q_wire[2] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[30].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[7].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[30].OBUF1  (.A(\REGF[7].RFW.q_wire[30] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[30].OBUF2  (.A(\REGF[7].RFW.q_wire[30] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[31].FF  (.CLK(\REGF[7].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[7].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[31].OBUF1  (.A(\REGF[7].RFW.q_wire[31] ),
    .TE_B(\REGF[7].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[31].OBUF2  (.A(\REGF[7].RFW.q_wire[31] ),
    .TE_B(\REGF[7].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[3].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[7].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[3].OBUF1  (.A(\REGF[7].RFW.q_wire[3] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[3].OBUF2  (.A(\REGF[7].RFW.q_wire[3] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[4].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[7].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[4].OBUF1  (.A(\REGF[7].RFW.q_wire[4] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[4].OBUF2  (.A(\REGF[7].RFW.q_wire[4] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[5].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[7].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[5].OBUF1  (.A(\REGF[7].RFW.q_wire[5] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[5].OBUF2  (.A(\REGF[7].RFW.q_wire[5] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[6].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[7].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[6].OBUF1  (.A(\REGF[7].RFW.q_wire[6] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[6].OBUF2  (.A(\REGF[7].RFW.q_wire[6] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[7].FF  (.CLK(\REGF[7].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[7].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[7].OBUF1  (.A(\REGF[7].RFW.q_wire[7] ),
    .TE_B(\REGF[7].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[7].OBUF2  (.A(\REGF[7].RFW.q_wire[7] ),
    .TE_B(\REGF[7].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[8].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[7].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[8].OBUF1  (.A(\REGF[7].RFW.q_wire[8] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[8].OBUF2  (.A(\REGF[7].RFW.q_wire[8] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[7].RFW.BIT[9].FF  (.CLK(\REGF[7].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[7].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[9].OBUF1  (.A(\REGF[7].RFW.q_wire[9] ),
    .TE_B(\REGF[7].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[7].RFW.BIT[9].OBUF2  (.A(\REGF[7].RFW.q_wire[9] ),
    .TE_B(\REGF[7].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[7].RFW.CGAND  (.A(\DEC2.D0.SEL[7] ),
    .B(WE),
    .X(\REGF[7].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[7].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[7].RFW.we_wire ),
    .GCLK(\REGF[7].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[7].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[7].RFW.we_wire ),
    .GCLK(\REGF[7].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[7].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[7].RFW.we_wire ),
    .GCLK(\REGF[7].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[7].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[7].RFW.we_wire ),
    .GCLK(\REGF[7].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV1[0]  (.A(\DEC0.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV1[1]  (.A(\DEC0.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV1[2]  (.A(\DEC0.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV1[3]  (.A(\DEC0.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV2[0]  (.A(\DEC1.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV2[1]  (.A(\DEC1.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV2[2]  (.A(\DEC1.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[7].RFW.INV2[3]  (.A(\DEC1.D0.SEL[7] ),
    .Y(\REGF[7].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[0].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[8].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[0].OBUF1  (.A(\REGF[8].RFW.q_wire[0] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[0].OBUF2  (.A(\REGF[8].RFW.q_wire[0] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[10].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[8].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[10].OBUF1  (.A(\REGF[8].RFW.q_wire[10] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[10].OBUF2  (.A(\REGF[8].RFW.q_wire[10] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[11].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[8].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[11].OBUF1  (.A(\REGF[8].RFW.q_wire[11] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[11].OBUF2  (.A(\REGF[8].RFW.q_wire[11] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[12].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[8].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[12].OBUF1  (.A(\REGF[8].RFW.q_wire[12] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[12].OBUF2  (.A(\REGF[8].RFW.q_wire[12] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[13].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[8].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[13].OBUF1  (.A(\REGF[8].RFW.q_wire[13] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[13].OBUF2  (.A(\REGF[8].RFW.q_wire[13] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[14].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[8].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[14].OBUF1  (.A(\REGF[8].RFW.q_wire[14] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[14].OBUF2  (.A(\REGF[8].RFW.q_wire[14] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[15].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[8].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[15].OBUF1  (.A(\REGF[8].RFW.q_wire[15] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[15].OBUF2  (.A(\REGF[8].RFW.q_wire[15] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[16].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[8].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[16].OBUF1  (.A(\REGF[8].RFW.q_wire[16] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[16].OBUF2  (.A(\REGF[8].RFW.q_wire[16] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[17].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[8].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[17].OBUF1  (.A(\REGF[8].RFW.q_wire[17] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[17].OBUF2  (.A(\REGF[8].RFW.q_wire[17] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[18].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[8].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[18].OBUF1  (.A(\REGF[8].RFW.q_wire[18] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[18].OBUF2  (.A(\REGF[8].RFW.q_wire[18] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[19].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[8].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[19].OBUF1  (.A(\REGF[8].RFW.q_wire[19] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[19].OBUF2  (.A(\REGF[8].RFW.q_wire[19] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[1].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[8].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[1].OBUF1  (.A(\REGF[8].RFW.q_wire[1] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[1].OBUF2  (.A(\REGF[8].RFW.q_wire[1] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[20].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[8].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[20].OBUF1  (.A(\REGF[8].RFW.q_wire[20] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[20].OBUF2  (.A(\REGF[8].RFW.q_wire[20] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[21].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[8].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[21].OBUF1  (.A(\REGF[8].RFW.q_wire[21] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[21].OBUF2  (.A(\REGF[8].RFW.q_wire[21] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[22].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[8].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[22].OBUF1  (.A(\REGF[8].RFW.q_wire[22] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[22].OBUF2  (.A(\REGF[8].RFW.q_wire[22] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[23].FF  (.CLK(\REGF[8].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[8].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[23].OBUF1  (.A(\REGF[8].RFW.q_wire[23] ),
    .TE_B(\REGF[8].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[23].OBUF2  (.A(\REGF[8].RFW.q_wire[23] ),
    .TE_B(\REGF[8].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[24].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[8].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[24].OBUF1  (.A(\REGF[8].RFW.q_wire[24] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[24].OBUF2  (.A(\REGF[8].RFW.q_wire[24] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[25].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[8].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[25].OBUF1  (.A(\REGF[8].RFW.q_wire[25] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[25].OBUF2  (.A(\REGF[8].RFW.q_wire[25] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[26].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[8].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[26].OBUF1  (.A(\REGF[8].RFW.q_wire[26] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[26].OBUF2  (.A(\REGF[8].RFW.q_wire[26] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[27].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[8].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[27].OBUF1  (.A(\REGF[8].RFW.q_wire[27] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[27].OBUF2  (.A(\REGF[8].RFW.q_wire[27] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[28].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[8].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[28].OBUF1  (.A(\REGF[8].RFW.q_wire[28] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[28].OBUF2  (.A(\REGF[8].RFW.q_wire[28] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[29].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[8].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[29].OBUF1  (.A(\REGF[8].RFW.q_wire[29] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[29].OBUF2  (.A(\REGF[8].RFW.q_wire[29] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[2].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[8].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[2].OBUF1  (.A(\REGF[8].RFW.q_wire[2] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[2].OBUF2  (.A(\REGF[8].RFW.q_wire[2] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[30].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[8].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[30].OBUF1  (.A(\REGF[8].RFW.q_wire[30] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[30].OBUF2  (.A(\REGF[8].RFW.q_wire[30] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[31].FF  (.CLK(\REGF[8].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[8].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[31].OBUF1  (.A(\REGF[8].RFW.q_wire[31] ),
    .TE_B(\REGF[8].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[31].OBUF2  (.A(\REGF[8].RFW.q_wire[31] ),
    .TE_B(\REGF[8].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[3].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[8].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[3].OBUF1  (.A(\REGF[8].RFW.q_wire[3] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[3].OBUF2  (.A(\REGF[8].RFW.q_wire[3] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[4].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[8].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[4].OBUF1  (.A(\REGF[8].RFW.q_wire[4] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[4].OBUF2  (.A(\REGF[8].RFW.q_wire[4] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[5].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[8].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[5].OBUF1  (.A(\REGF[8].RFW.q_wire[5] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[5].OBUF2  (.A(\REGF[8].RFW.q_wire[5] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[6].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[8].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[6].OBUF1  (.A(\REGF[8].RFW.q_wire[6] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[6].OBUF2  (.A(\REGF[8].RFW.q_wire[6] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[7].FF  (.CLK(\REGF[8].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[8].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[7].OBUF1  (.A(\REGF[8].RFW.q_wire[7] ),
    .TE_B(\REGF[8].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[7].OBUF2  (.A(\REGF[8].RFW.q_wire[7] ),
    .TE_B(\REGF[8].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[8].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[8].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[8].OBUF1  (.A(\REGF[8].RFW.q_wire[8] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[8].OBUF2  (.A(\REGF[8].RFW.q_wire[8] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[8].RFW.BIT[9].FF  (.CLK(\REGF[8].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[8].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[9].OBUF1  (.A(\REGF[8].RFW.q_wire[9] ),
    .TE_B(\REGF[8].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[8].RFW.BIT[9].OBUF2  (.A(\REGF[8].RFW.q_wire[9] ),
    .TE_B(\REGF[8].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[8].RFW.CGAND  (.A(\DEC2.D1.SEL[0] ),
    .B(WE),
    .X(\REGF[8].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[8].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[8].RFW.we_wire ),
    .GCLK(\REGF[8].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[8].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[8].RFW.we_wire ),
    .GCLK(\REGF[8].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[8].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[8].RFW.we_wire ),
    .GCLK(\REGF[8].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[8].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[8].RFW.we_wire ),
    .GCLK(\REGF[8].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV1[0]  (.A(\DEC0.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV1[1]  (.A(\DEC0.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV1[2]  (.A(\DEC0.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV1[3]  (.A(\DEC0.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV2[0]  (.A(\DEC1.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV2[1]  (.A(\DEC1.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV2[2]  (.A(\DEC1.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[8].RFW.INV2[3]  (.A(\DEC1.D1.SEL[0] ),
    .Y(\REGF[8].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[0].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[0]),
    .Q(\REGF[9].RFW.q_wire[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[0].OBUF1  (.A(\REGF[9].RFW.q_wire[0] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[0].OBUF2  (.A(\REGF[9].RFW.q_wire[0] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[10].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[10]),
    .Q(\REGF[9].RFW.q_wire[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[10].OBUF1  (.A(\REGF[9].RFW.q_wire[10] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[10].OBUF2  (.A(\REGF[9].RFW.q_wire[10] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[11].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[11]),
    .Q(\REGF[9].RFW.q_wire[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[11].OBUF1  (.A(\REGF[9].RFW.q_wire[11] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[11].OBUF2  (.A(\REGF[9].RFW.q_wire[11] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[12].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[12]),
    .Q(\REGF[9].RFW.q_wire[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[12].OBUF1  (.A(\REGF[9].RFW.q_wire[12] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[12].OBUF2  (.A(\REGF[9].RFW.q_wire[12] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[13].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[13]),
    .Q(\REGF[9].RFW.q_wire[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[13].OBUF1  (.A(\REGF[9].RFW.q_wire[13] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[13].OBUF2  (.A(\REGF[9].RFW.q_wire[13] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[14].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[14]),
    .Q(\REGF[9].RFW.q_wire[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[14].OBUF1  (.A(\REGF[9].RFW.q_wire[14] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[14].OBUF2  (.A(\REGF[9].RFW.q_wire[14] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[15].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[15]),
    .Q(\REGF[9].RFW.q_wire[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[15].OBUF1  (.A(\REGF[9].RFW.q_wire[15] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[15].OBUF2  (.A(\REGF[9].RFW.q_wire[15] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[16].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[16]),
    .Q(\REGF[9].RFW.q_wire[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[16].OBUF1  (.A(\REGF[9].RFW.q_wire[16] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[16].OBUF2  (.A(\REGF[9].RFW.q_wire[16] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[17].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[17]),
    .Q(\REGF[9].RFW.q_wire[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[17].OBUF1  (.A(\REGF[9].RFW.q_wire[17] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[17].OBUF2  (.A(\REGF[9].RFW.q_wire[17] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[18].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[18]),
    .Q(\REGF[9].RFW.q_wire[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[18].OBUF1  (.A(\REGF[9].RFW.q_wire[18] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[18].OBUF2  (.A(\REGF[9].RFW.q_wire[18] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[19].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[19]),
    .Q(\REGF[9].RFW.q_wire[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[19].OBUF1  (.A(\REGF[9].RFW.q_wire[19] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[19].OBUF2  (.A(\REGF[9].RFW.q_wire[19] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[1].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[1]),
    .Q(\REGF[9].RFW.q_wire[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[1].OBUF1  (.A(\REGF[9].RFW.q_wire[1] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[1].OBUF2  (.A(\REGF[9].RFW.q_wire[1] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[20].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[20]),
    .Q(\REGF[9].RFW.q_wire[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[20].OBUF1  (.A(\REGF[9].RFW.q_wire[20] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[20].OBUF2  (.A(\REGF[9].RFW.q_wire[20] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[21].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[21]),
    .Q(\REGF[9].RFW.q_wire[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[21].OBUF1  (.A(\REGF[9].RFW.q_wire[21] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[21].OBUF2  (.A(\REGF[9].RFW.q_wire[21] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[22].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[22]),
    .Q(\REGF[9].RFW.q_wire[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[22].OBUF1  (.A(\REGF[9].RFW.q_wire[22] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[22].OBUF2  (.A(\REGF[9].RFW.q_wire[22] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[23].FF  (.CLK(\REGF[9].RFW.GCLK[2] ),
    .D(DW[23]),
    .Q(\REGF[9].RFW.q_wire[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[23].OBUF1  (.A(\REGF[9].RFW.q_wire[23] ),
    .TE_B(\REGF[9].RFW.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[23].OBUF2  (.A(\REGF[9].RFW.q_wire[23] ),
    .TE_B(\REGF[9].RFW.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[24].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[24]),
    .Q(\REGF[9].RFW.q_wire[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[24].OBUF1  (.A(\REGF[9].RFW.q_wire[24] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[24].OBUF2  (.A(\REGF[9].RFW.q_wire[24] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[25].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[25]),
    .Q(\REGF[9].RFW.q_wire[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[25].OBUF1  (.A(\REGF[9].RFW.q_wire[25] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[25].OBUF2  (.A(\REGF[9].RFW.q_wire[25] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[26].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[26]),
    .Q(\REGF[9].RFW.q_wire[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[26].OBUF1  (.A(\REGF[9].RFW.q_wire[26] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[26].OBUF2  (.A(\REGF[9].RFW.q_wire[26] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[27].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[27]),
    .Q(\REGF[9].RFW.q_wire[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[27].OBUF1  (.A(\REGF[9].RFW.q_wire[27] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[27].OBUF2  (.A(\REGF[9].RFW.q_wire[27] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[28].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[28]),
    .Q(\REGF[9].RFW.q_wire[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[28].OBUF1  (.A(\REGF[9].RFW.q_wire[28] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[28].OBUF2  (.A(\REGF[9].RFW.q_wire[28] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[29].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[29]),
    .Q(\REGF[9].RFW.q_wire[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[29].OBUF1  (.A(\REGF[9].RFW.q_wire[29] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[29].OBUF2  (.A(\REGF[9].RFW.q_wire[29] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[2].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[2]),
    .Q(\REGF[9].RFW.q_wire[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[2].OBUF1  (.A(\REGF[9].RFW.q_wire[2] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[2].OBUF2  (.A(\REGF[9].RFW.q_wire[2] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[30].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[30]),
    .Q(\REGF[9].RFW.q_wire[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[30].OBUF1  (.A(\REGF[9].RFW.q_wire[30] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[30].OBUF2  (.A(\REGF[9].RFW.q_wire[30] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[31].FF  (.CLK(\REGF[9].RFW.GCLK[3] ),
    .D(DW[31]),
    .Q(\REGF[9].RFW.q_wire[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[31].OBUF1  (.A(\REGF[9].RFW.q_wire[31] ),
    .TE_B(\REGF[9].RFW.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[31].OBUF2  (.A(\REGF[9].RFW.q_wire[31] ),
    .TE_B(\REGF[9].RFW.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[3].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[3]),
    .Q(\REGF[9].RFW.q_wire[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[3].OBUF1  (.A(\REGF[9].RFW.q_wire[3] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[3].OBUF2  (.A(\REGF[9].RFW.q_wire[3] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[4].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[4]),
    .Q(\REGF[9].RFW.q_wire[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[4].OBUF1  (.A(\REGF[9].RFW.q_wire[4] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[4].OBUF2  (.A(\REGF[9].RFW.q_wire[4] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[5].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[5]),
    .Q(\REGF[9].RFW.q_wire[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[5].OBUF1  (.A(\REGF[9].RFW.q_wire[5] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[5].OBUF2  (.A(\REGF[9].RFW.q_wire[5] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[6].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[6]),
    .Q(\REGF[9].RFW.q_wire[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[6].OBUF1  (.A(\REGF[9].RFW.q_wire[6] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[6].OBUF2  (.A(\REGF[9].RFW.q_wire[6] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[7].FF  (.CLK(\REGF[9].RFW.GCLK[0] ),
    .D(DW[7]),
    .Q(\REGF[9].RFW.q_wire[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[7].OBUF1  (.A(\REGF[9].RFW.q_wire[7] ),
    .TE_B(\REGF[9].RFW.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[7].OBUF2  (.A(\REGF[9].RFW.q_wire[7] ),
    .TE_B(\REGF[9].RFW.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[8].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[8]),
    .Q(\REGF[9].RFW.q_wire[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[8].OBUF1  (.A(\REGF[9].RFW.q_wire[8] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[8].OBUF2  (.A(\REGF[9].RFW.q_wire[8] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__dfxtp_1 \REGF[9].RFW.BIT[9].FF  (.CLK(\REGF[9].RFW.GCLK[1] ),
    .D(DW[9]),
    .Q(\REGF[9].RFW.q_wire[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[9].OBUF1  (.A(\REGF[9].RFW.q_wire[9] ),
    .TE_B(\REGF[9].RFW.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \REGF[9].RFW.BIT[9].OBUF2  (.A(\REGF[9].RFW.q_wire[9] ),
    .TE_B(\REGF[9].RFW.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__and2_1 \REGF[9].RFW.CGAND  (.A(\DEC2.D1.SEL[1] ),
    .B(WE),
    .X(\REGF[9].RFW.we_wire ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[9].RFW.CG[0]  (.CLK(CLK),
    .GATE(\REGF[9].RFW.we_wire ),
    .GCLK(\REGF[9].RFW.GCLK[0] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[9].RFW.CG[1]  (.CLK(CLK),
    .GATE(\REGF[9].RFW.we_wire ),
    .GCLK(\REGF[9].RFW.GCLK[1] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[9].RFW.CG[2]  (.CLK(CLK),
    .GATE(\REGF[9].RFW.we_wire ),
    .GCLK(\REGF[9].RFW.GCLK[2] ));
 sky130_fd_sc_hd__dlclkp_1 \REGF[9].RFW.CG[3]  (.CLK(CLK),
    .GATE(\REGF[9].RFW.we_wire ),
    .GCLK(\REGF[9].RFW.GCLK[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV1[0]  (.A(\DEC0.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV1[1]  (.A(\DEC0.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV1[2]  (.A(\DEC0.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV1[3]  (.A(\DEC0.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV2[0]  (.A(\DEC1.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV2[1]  (.A(\DEC1.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV2[2]  (.A(\DEC1.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \REGF[9].RFW.INV2[3]  (.A(\DEC1.D1.SEL[1] ),
    .Y(\REGF[9].RFW.SEL2_B[3] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[0].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[0] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[0].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[0] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[10].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[10] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[10].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[10] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[11].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[11] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[11].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[11] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[12].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[12] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[12].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[12] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[13].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[13] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[13].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[13] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[14].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[14] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[14].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[14] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[15].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[15] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[15].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[15] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[16].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[16] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[16].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[16] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[17].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[17] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[17].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[17] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[18].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[18] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[18].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[18] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[19].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[19] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[19].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[19] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[1].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[1] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[1].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[1] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[20].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[20] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[20].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[20] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[21].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[21] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[21].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[21] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[22].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[22] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[22].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[22] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[23].OBUF1  (.A(\genblk1.RFW0.lo[2] ),
    .TE_B(\genblk1.RFW0.SEL1_B[2] ),
    .Z(\REGF[10].RFW.D1[23] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[23].OBUF2  (.A(\genblk1.RFW0.lo[6] ),
    .TE_B(\genblk1.RFW0.SEL2_B[2] ),
    .Z(\REGF[10].RFW.D2[23] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[24].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[24] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[24].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[24] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[25].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[25] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[25].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[25] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[26].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[26] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[26].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[26] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[27].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[27] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[27].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[27] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[28].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[28] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[28].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[28] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[29].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[29] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[29].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[29] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[2].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[2] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[2].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[2] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[30].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[30] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[30].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[30] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[31].OBUF1  (.A(\genblk1.RFW0.lo[3] ),
    .TE_B(\genblk1.RFW0.SEL1_B[3] ),
    .Z(\REGF[10].RFW.D1[31] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[31].OBUF2  (.A(\genblk1.RFW0.lo[7] ),
    .TE_B(\genblk1.RFW0.SEL2_B[3] ),
    .Z(\REGF[10].RFW.D2[31] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[3].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[3] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[3].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[3] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[4].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[4] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[4].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[4] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[5].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[5] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[5].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[5] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[6].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[6] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[6].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[6] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[7].OBUF1  (.A(\genblk1.RFW0.lo[0] ),
    .TE_B(\genblk1.RFW0.SEL1_B[0] ),
    .Z(\REGF[10].RFW.D1[7] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[7].OBUF2  (.A(\genblk1.RFW0.lo[4] ),
    .TE_B(\genblk1.RFW0.SEL2_B[0] ),
    .Z(\REGF[10].RFW.D2[7] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[8].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[8] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[8].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[8] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[9].OBUF1  (.A(\genblk1.RFW0.lo[1] ),
    .TE_B(\genblk1.RFW0.SEL1_B[1] ),
    .Z(\REGF[10].RFW.D1[9] ));
 sky130_fd_sc_hd__ebufn_2 \genblk1.RFW0.BIT[9].OBUF2  (.A(\genblk1.RFW0.lo[5] ),
    .TE_B(\genblk1.RFW0.SEL2_B[1] ),
    .Z(\REGF[10].RFW.D2[9] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV1[0]  (.A(\DEC0.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL1_B[0] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV1[1]  (.A(\DEC0.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL1_B[1] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV1[2]  (.A(\DEC0.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL1_B[2] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV1[3]  (.A(\DEC0.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL1_B[3] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV2[0]  (.A(\DEC1.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL2_B[0] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV2[1]  (.A(\DEC1.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL2_B[1] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV2[2]  (.A(\DEC1.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL2_B[2] ));
 sky130_fd_sc_hd__inv_4 \genblk1.RFW0.INV2[3]  (.A(\DEC1.D0.SEL[0] ),
    .Y(\genblk1.RFW0.SEL2_B[3] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[0]  (.LO(\genblk1.RFW0.lo[0] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[1]  (.LO(\genblk1.RFW0.lo[1] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[2]  (.LO(\genblk1.RFW0.lo[2] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[3]  (.LO(\genblk1.RFW0.lo[3] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[4]  (.LO(\genblk1.RFW0.lo[4] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[5]  (.LO(\genblk1.RFW0.lo[5] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[6]  (.LO(\genblk1.RFW0.lo[6] ));
 sky130_fd_sc_hd__conb_1 \genblk1.RFW0.TIE[7]  (.LO(\genblk1.RFW0.lo[7] ));
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_15_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_17_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_1_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_3_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_5_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_7_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_9_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_11_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_13_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_19_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_21_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_23_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_25_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_27_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_29_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_31_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_0 ();
 sky130_fd_sc_hd__decap_4 fill_0_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_0 ();
 sky130_fd_sc_hd__decap_8 fill_1_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_0 ();
 sky130_fd_sc_hd__decap_8 fill_2_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_0 ();
 sky130_fd_sc_hd__decap_8 fill_3_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_0 ();
 sky130_fd_sc_hd__decap_12 fill_4_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_0 ();
 sky130_fd_sc_hd__decap_12 fill_5_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_0 ();
 sky130_fd_sc_hd__decap_12 fill_6_1 ();
 sky130_fd_sc_hd__fill_2 fill_6_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_0 ();
 sky130_fd_sc_hd__decap_12 fill_7_1 ();
 sky130_fd_sc_hd__fill_2 fill_7_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_0 ();
 sky130_fd_sc_hd__decap_6 fill_8_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_0 ();
 sky130_fd_sc_hd__decap_8 fill_9_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_0 ();
 sky130_fd_sc_hd__decap_8 fill_10_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_0 ();
 sky130_fd_sc_hd__decap_8 fill_11_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_0 ();
 sky130_fd_sc_hd__decap_12 fill_12_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_0 ();
 sky130_fd_sc_hd__decap_12 fill_13_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_0 ();
 sky130_fd_sc_hd__decap_4 fill_14_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_0 ();
 sky130_fd_sc_hd__decap_6 fill_15_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_0 ();
 sky130_fd_sc_hd__fill_2 fill_17_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_0 ();
 sky130_fd_sc_hd__decap_8 fill_18_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_0 ();
 sky130_fd_sc_hd__decap_8 fill_19_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_0 ();
 sky130_fd_sc_hd__decap_12 fill_20_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_0 ();
 sky130_fd_sc_hd__decap_12 fill_21_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_0 ();
 sky130_fd_sc_hd__decap_12 fill_22_1 ();
 sky130_fd_sc_hd__fill_2 fill_22_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_0 ();
 sky130_fd_sc_hd__decap_12 fill_23_1 ();
 sky130_fd_sc_hd__fill_2 fill_23_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_0 ();
 sky130_fd_sc_hd__decap_6 fill_24_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_0 ();
 sky130_fd_sc_hd__decap_8 fill_25_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_0 ();
 sky130_fd_sc_hd__decap_8 fill_26_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_0 ();
 sky130_fd_sc_hd__decap_8 fill_27_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_0 ();
 sky130_fd_sc_hd__decap_12 fill_28_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_0 ();
 sky130_fd_sc_hd__decap_12 fill_29_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_0 ();
 sky130_fd_sc_hd__decap_12 fill_30_1 ();
 sky130_fd_sc_hd__fill_2 fill_30_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_0 ();
 sky130_fd_sc_hd__decap_12 fill_31_1 ();
 sky130_fd_sc_hd__fill_2 fill_31_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_0 ();
 sky130_fd_sc_hd__decap_12 fill_32_1 ();
 sky130_fd_sc_hd__decap_8 fill_32_2 ();
 sky130_fd_sc_hd__decap_3 fill_32_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_0 ();
 sky130_fd_sc_hd__decap_12 fill_33_1 ();
 sky130_fd_sc_hd__decap_8 fill_33_2 ();
 sky130_fd_sc_hd__decap_3 fill_33_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_0 ();
 sky130_fd_sc_hd__decap_12 fill_34_1 ();
 sky130_fd_sc_hd__decap_8 fill_34_2 ();
 sky130_fd_sc_hd__decap_3 fill_34_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_0 ();
 sky130_fd_sc_hd__decap_12 fill_35_1 ();
 sky130_fd_sc_hd__decap_8 fill_35_2 ();
 sky130_fd_sc_hd__decap_3 fill_35_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_0 ();
 sky130_fd_sc_hd__decap_12 fill_36_1 ();
 sky130_fd_sc_hd__decap_8 fill_36_2 ();
 sky130_fd_sc_hd__decap_3 fill_36_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_0 ();
 sky130_fd_sc_hd__decap_12 fill_37_1 ();
 sky130_fd_sc_hd__decap_8 fill_37_2 ();
 sky130_fd_sc_hd__decap_3 fill_37_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_0 ();
 sky130_fd_sc_hd__decap_12 fill_38_1 ();
 sky130_fd_sc_hd__decap_8 fill_38_2 ();
 sky130_fd_sc_hd__decap_3 fill_38_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_0 ();
 sky130_fd_sc_hd__decap_12 fill_39_1 ();
 sky130_fd_sc_hd__decap_8 fill_39_2 ();
 sky130_fd_sc_hd__decap_3 fill_39_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_0 ();
 sky130_fd_sc_hd__decap_12 fill_40_1 ();
 sky130_fd_sc_hd__decap_8 fill_40_2 ();
 sky130_fd_sc_hd__decap_3 fill_40_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_0 ();
 sky130_fd_sc_hd__decap_12 fill_41_1 ();
 sky130_fd_sc_hd__decap_8 fill_41_2 ();
 sky130_fd_sc_hd__decap_3 fill_41_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_0 ();
 sky130_fd_sc_hd__decap_12 fill_42_1 ();
 sky130_fd_sc_hd__decap_8 fill_42_2 ();
 sky130_fd_sc_hd__decap_3 fill_42_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_0 ();
 sky130_fd_sc_hd__decap_12 fill_43_1 ();
 sky130_fd_sc_hd__decap_8 fill_43_2 ();
 sky130_fd_sc_hd__decap_3 fill_43_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_0 ();
 sky130_fd_sc_hd__decap_12 fill_44_1 ();
 sky130_fd_sc_hd__decap_8 fill_44_2 ();
 sky130_fd_sc_hd__decap_3 fill_44_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_0 ();
 sky130_fd_sc_hd__decap_12 fill_45_1 ();
 sky130_fd_sc_hd__decap_8 fill_45_2 ();
 sky130_fd_sc_hd__decap_3 fill_45_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_0 ();
 sky130_fd_sc_hd__decap_12 fill_46_1 ();
 sky130_fd_sc_hd__decap_8 fill_46_2 ();
 sky130_fd_sc_hd__decap_3 fill_46_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_0 ();
 sky130_fd_sc_hd__decap_12 fill_47_1 ();
 sky130_fd_sc_hd__decap_8 fill_47_2 ();
 sky130_fd_sc_hd__decap_3 fill_47_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_0 ();
 sky130_fd_sc_hd__decap_12 fill_48_1 ();
 sky130_fd_sc_hd__decap_8 fill_48_2 ();
 sky130_fd_sc_hd__decap_3 fill_48_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_0 ();
 sky130_fd_sc_hd__decap_12 fill_49_1 ();
 sky130_fd_sc_hd__decap_8 fill_49_2 ();
 sky130_fd_sc_hd__decap_3 fill_49_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_0 ();
 sky130_fd_sc_hd__decap_12 fill_50_1 ();
 sky130_fd_sc_hd__decap_8 fill_50_2 ();
 sky130_fd_sc_hd__decap_3 fill_50_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_0 ();
 sky130_fd_sc_hd__decap_12 fill_51_1 ();
 sky130_fd_sc_hd__decap_8 fill_51_2 ();
 sky130_fd_sc_hd__decap_3 fill_51_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_0 ();
 sky130_fd_sc_hd__decap_12 fill_52_1 ();
 sky130_fd_sc_hd__decap_8 fill_52_2 ();
 sky130_fd_sc_hd__decap_3 fill_52_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_0 ();
 sky130_fd_sc_hd__decap_12 fill_53_1 ();
 sky130_fd_sc_hd__decap_8 fill_53_2 ();
 sky130_fd_sc_hd__decap_3 fill_53_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_0 ();
 sky130_fd_sc_hd__decap_12 fill_54_1 ();
 sky130_fd_sc_hd__decap_8 fill_54_2 ();
 sky130_fd_sc_hd__decap_3 fill_54_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_0 ();
 sky130_fd_sc_hd__decap_12 fill_55_1 ();
 sky130_fd_sc_hd__decap_8 fill_55_2 ();
 sky130_fd_sc_hd__decap_3 fill_55_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_0 ();
 sky130_fd_sc_hd__decap_12 fill_56_1 ();
 sky130_fd_sc_hd__decap_8 fill_56_2 ();
 sky130_fd_sc_hd__decap_3 fill_56_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_0 ();
 sky130_fd_sc_hd__decap_12 fill_57_1 ();
 sky130_fd_sc_hd__decap_8 fill_57_2 ();
 sky130_fd_sc_hd__decap_3 fill_57_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_0 ();
 sky130_fd_sc_hd__decap_12 fill_58_1 ();
 sky130_fd_sc_hd__decap_8 fill_58_2 ();
 sky130_fd_sc_hd__decap_3 fill_58_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_0 ();
 sky130_fd_sc_hd__decap_12 fill_59_1 ();
 sky130_fd_sc_hd__decap_8 fill_59_2 ();
 sky130_fd_sc_hd__decap_3 fill_59_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_0 ();
 sky130_fd_sc_hd__decap_12 fill_60_1 ();
 sky130_fd_sc_hd__decap_8 fill_60_2 ();
 sky130_fd_sc_hd__decap_3 fill_60_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_0 ();
 sky130_fd_sc_hd__decap_12 fill_61_1 ();
 sky130_fd_sc_hd__decap_8 fill_61_2 ();
 sky130_fd_sc_hd__decap_3 fill_61_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_1_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_3_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_5_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_7_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_9_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_11_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_13_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_15_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_17_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_19_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_21_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_23_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_25_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_27_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_29_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_31_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_33_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_33_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_35_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_35_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_37_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_37_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_39_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_39_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_41_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_41_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_43_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_43_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_45_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_45_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_47_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_47_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_49_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_49_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_51_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_51_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_53_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_53_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_55_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_55_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_57_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_57_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_59_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_59_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_61_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_61_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_2 ();
 sky130_fd_sc_hd__decap_8 fill_0_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_3 ();
 sky130_fd_sc_hd__decap_12 fill_2_4 ();
 sky130_fd_sc_hd__decap_8 fill_2_5 ();
 sky130_fd_sc_hd__decap_3 fill_2_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_3 ();
 sky130_fd_sc_hd__decap_12 fill_4_4 ();
 sky130_fd_sc_hd__decap_8 fill_4_5 ();
 sky130_fd_sc_hd__decap_3 fill_4_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_3 ();
 sky130_fd_sc_hd__decap_12 fill_6_4 ();
 sky130_fd_sc_hd__decap_8 fill_6_5 ();
 sky130_fd_sc_hd__decap_3 fill_6_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_3 ();
 sky130_fd_sc_hd__decap_12 fill_8_4 ();
 sky130_fd_sc_hd__decap_8 fill_8_5 ();
 sky130_fd_sc_hd__decap_3 fill_8_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_3 ();
 sky130_fd_sc_hd__decap_12 fill_10_4 ();
 sky130_fd_sc_hd__decap_8 fill_10_5 ();
 sky130_fd_sc_hd__decap_3 fill_10_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_3 ();
 sky130_fd_sc_hd__decap_12 fill_12_4 ();
 sky130_fd_sc_hd__decap_8 fill_12_5 ();
 sky130_fd_sc_hd__decap_3 fill_12_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_2 ();
 sky130_fd_sc_hd__decap_12 fill_14_3 ();
 sky130_fd_sc_hd__decap_8 fill_14_4 ();
 sky130_fd_sc_hd__decap_3 fill_14_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_0 ();
 sky130_fd_sc_hd__decap_12 fill_16_1 ();
 sky130_fd_sc_hd__decap_8 fill_16_2 ();
 sky130_fd_sc_hd__fill_2 fill_16_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_3 ();
 sky130_fd_sc_hd__decap_12 fill_18_4 ();
 sky130_fd_sc_hd__decap_8 fill_18_5 ();
 sky130_fd_sc_hd__decap_3 fill_18_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_3 ();
 sky130_fd_sc_hd__decap_12 fill_20_4 ();
 sky130_fd_sc_hd__decap_8 fill_20_5 ();
 sky130_fd_sc_hd__decap_3 fill_20_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_3 ();
 sky130_fd_sc_hd__decap_12 fill_22_4 ();
 sky130_fd_sc_hd__decap_8 fill_22_5 ();
 sky130_fd_sc_hd__decap_3 fill_22_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_3 ();
 sky130_fd_sc_hd__decap_12 fill_24_4 ();
 sky130_fd_sc_hd__decap_8 fill_24_5 ();
 sky130_fd_sc_hd__decap_3 fill_24_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_3 ();
 sky130_fd_sc_hd__decap_12 fill_26_4 ();
 sky130_fd_sc_hd__decap_8 fill_26_5 ();
 sky130_fd_sc_hd__decap_3 fill_26_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_3 ();
 sky130_fd_sc_hd__decap_12 fill_28_4 ();
 sky130_fd_sc_hd__decap_8 fill_28_5 ();
 sky130_fd_sc_hd__decap_3 fill_28_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_3 ();
 sky130_fd_sc_hd__decap_12 fill_30_4 ();
 sky130_fd_sc_hd__decap_8 fill_30_5 ();
 sky130_fd_sc_hd__decap_3 fill_30_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_4 ();
 sky130_fd_sc_hd__decap_12 fill_32_5 ();
 sky130_fd_sc_hd__decap_8 fill_32_6 ();
 sky130_fd_sc_hd__fill_2 fill_32_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_4 ();
 sky130_fd_sc_hd__decap_12 fill_34_5 ();
 sky130_fd_sc_hd__decap_8 fill_34_6 ();
 sky130_fd_sc_hd__fill_2 fill_34_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_4 ();
 sky130_fd_sc_hd__decap_12 fill_36_5 ();
 sky130_fd_sc_hd__decap_8 fill_36_6 ();
 sky130_fd_sc_hd__fill_2 fill_36_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_4 ();
 sky130_fd_sc_hd__decap_12 fill_38_5 ();
 sky130_fd_sc_hd__decap_8 fill_38_6 ();
 sky130_fd_sc_hd__fill_2 fill_38_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_4 ();
 sky130_fd_sc_hd__decap_12 fill_40_5 ();
 sky130_fd_sc_hd__decap_8 fill_40_6 ();
 sky130_fd_sc_hd__fill_2 fill_40_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_4 ();
 sky130_fd_sc_hd__decap_12 fill_42_5 ();
 sky130_fd_sc_hd__decap_8 fill_42_6 ();
 sky130_fd_sc_hd__fill_2 fill_42_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_4 ();
 sky130_fd_sc_hd__decap_12 fill_44_5 ();
 sky130_fd_sc_hd__decap_8 fill_44_6 ();
 sky130_fd_sc_hd__fill_2 fill_44_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_4 ();
 sky130_fd_sc_hd__decap_12 fill_46_5 ();
 sky130_fd_sc_hd__decap_8 fill_46_6 ();
 sky130_fd_sc_hd__fill_2 fill_46_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_4 ();
 sky130_fd_sc_hd__decap_12 fill_48_5 ();
 sky130_fd_sc_hd__decap_8 fill_48_6 ();
 sky130_fd_sc_hd__fill_2 fill_48_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_4 ();
 sky130_fd_sc_hd__decap_12 fill_50_5 ();
 sky130_fd_sc_hd__decap_8 fill_50_6 ();
 sky130_fd_sc_hd__fill_2 fill_50_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_4 ();
 sky130_fd_sc_hd__decap_12 fill_52_5 ();
 sky130_fd_sc_hd__decap_8 fill_52_6 ();
 sky130_fd_sc_hd__fill_2 fill_52_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_4 ();
 sky130_fd_sc_hd__decap_12 fill_54_5 ();
 sky130_fd_sc_hd__decap_8 fill_54_6 ();
 sky130_fd_sc_hd__fill_2 fill_54_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_4 ();
 sky130_fd_sc_hd__decap_12 fill_56_5 ();
 sky130_fd_sc_hd__decap_8 fill_56_6 ();
 sky130_fd_sc_hd__fill_2 fill_56_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_4 ();
 sky130_fd_sc_hd__decap_12 fill_58_5 ();
 sky130_fd_sc_hd__decap_8 fill_58_6 ();
 sky130_fd_sc_hd__fill_2 fill_58_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_4 ();
 sky130_fd_sc_hd__decap_12 fill_60_5 ();
 sky130_fd_sc_hd__decap_8 fill_60_6 ();
 sky130_fd_sc_hd__fill_2 fill_60_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_0 ();
 sky130_fd_sc_hd__decap_12 fill_62_1 ();
 sky130_fd_sc_hd__decap_12 fill_62_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_3 ();
 sky130_fd_sc_hd__decap_12 fill_62_4 ();
 sky130_fd_sc_hd__decap_8 fill_62_5 ();
 sky130_fd_sc_hd__fill_2 fill_62_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_0 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_3 ();
 sky130_fd_sc_hd__fill_2 fill_1_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_4 ();
 sky130_fd_sc_hd__fill_2 fill_3_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_4 ();
 sky130_fd_sc_hd__fill_2 fill_5_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_4 ();
 sky130_fd_sc_hd__fill_2 fill_7_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_3 ();
 sky130_fd_sc_hd__fill_2 fill_9_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_4 ();
 sky130_fd_sc_hd__fill_2 fill_11_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_4 ();
 sky130_fd_sc_hd__fill_2 fill_13_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_3 ();
 sky130_fd_sc_hd__fill_2 fill_15_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_3 ();
 sky130_fd_sc_hd__fill_2 fill_17_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_4 ();
 sky130_fd_sc_hd__fill_2 fill_19_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_4 ();
 sky130_fd_sc_hd__fill_2 fill_21_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_4 ();
 sky130_fd_sc_hd__fill_2 fill_23_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_3 ();
 sky130_fd_sc_hd__fill_2 fill_25_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_4 ();
 sky130_fd_sc_hd__fill_2 fill_27_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_4 ();
 sky130_fd_sc_hd__fill_2 fill_29_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_4 ();
 sky130_fd_sc_hd__fill_2 fill_31_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_4 ();
 sky130_fd_sc_hd__fill_2 fill_33_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_4 ();
 sky130_fd_sc_hd__fill_2 fill_35_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_4 ();
 sky130_fd_sc_hd__fill_2 fill_37_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_4 ();
 sky130_fd_sc_hd__fill_2 fill_39_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_4 ();
 sky130_fd_sc_hd__fill_2 fill_41_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_4 ();
 sky130_fd_sc_hd__fill_2 fill_43_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_4 ();
 sky130_fd_sc_hd__fill_2 fill_45_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_4 ();
 sky130_fd_sc_hd__fill_2 fill_47_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_4 ();
 sky130_fd_sc_hd__fill_2 fill_49_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_4 ();
 sky130_fd_sc_hd__fill_2 fill_51_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_4 ();
 sky130_fd_sc_hd__fill_2 fill_53_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_4 ();
 sky130_fd_sc_hd__fill_2 fill_55_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_4 ();
 sky130_fd_sc_hd__fill_2 fill_57_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_4 ();
 sky130_fd_sc_hd__fill_2 fill_59_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_4 ();
 sky130_fd_sc_hd__fill_2 fill_61_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_1 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_7 ();
 sky130_fd_sc_hd__fill_2 fill_1_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_8 ();
 sky130_fd_sc_hd__fill_2 fill_3_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_8 ();
 sky130_fd_sc_hd__fill_2 fill_5_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_8 ();
 sky130_fd_sc_hd__fill_2 fill_7_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_7 ();
 sky130_fd_sc_hd__fill_2 fill_9_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_8 ();
 sky130_fd_sc_hd__fill_2 fill_11_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_8 ();
 sky130_fd_sc_hd__fill_2 fill_13_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_7 ();
 sky130_fd_sc_hd__fill_2 fill_15_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_7 ();
 sky130_fd_sc_hd__fill_2 fill_17_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_8 ();
 sky130_fd_sc_hd__fill_2 fill_19_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_8 ();
 sky130_fd_sc_hd__fill_2 fill_21_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_8 ();
 sky130_fd_sc_hd__fill_2 fill_23_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_7 ();
 sky130_fd_sc_hd__fill_2 fill_25_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_8 ();
 sky130_fd_sc_hd__fill_2 fill_27_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_8 ();
 sky130_fd_sc_hd__fill_2 fill_29_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_8 ();
 sky130_fd_sc_hd__fill_2 fill_31_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_8 ();
 sky130_fd_sc_hd__fill_2 fill_33_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_8 ();
 sky130_fd_sc_hd__fill_2 fill_35_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_8 ();
 sky130_fd_sc_hd__fill_2 fill_37_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_8 ();
 sky130_fd_sc_hd__fill_2 fill_39_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_8 ();
 sky130_fd_sc_hd__fill_2 fill_41_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_8 ();
 sky130_fd_sc_hd__fill_2 fill_43_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_8 ();
 sky130_fd_sc_hd__fill_2 fill_45_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_8 ();
 sky130_fd_sc_hd__fill_2 fill_47_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_8 ();
 sky130_fd_sc_hd__fill_2 fill_49_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_8 ();
 sky130_fd_sc_hd__fill_2 fill_51_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_8 ();
 sky130_fd_sc_hd__fill_2 fill_53_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_8 ();
 sky130_fd_sc_hd__fill_2 fill_55_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_8 ();
 sky130_fd_sc_hd__fill_2 fill_57_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_8 ();
 sky130_fd_sc_hd__fill_2 fill_59_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_8 ();
 sky130_fd_sc_hd__fill_2 fill_61_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_9 ();
 sky130_fd_sc_hd__decap_4 fill_1_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_10 ();
 sky130_fd_sc_hd__decap_4 fill_3_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_10 ();
 sky130_fd_sc_hd__decap_4 fill_5_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_10 ();
 sky130_fd_sc_hd__decap_4 fill_7_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_9 ();
 sky130_fd_sc_hd__decap_4 fill_9_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_10 ();
 sky130_fd_sc_hd__decap_4 fill_11_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_10 ();
 sky130_fd_sc_hd__decap_4 fill_13_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_9 ();
 sky130_fd_sc_hd__decap_4 fill_15_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_9 ();
 sky130_fd_sc_hd__decap_4 fill_17_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_10 ();
 sky130_fd_sc_hd__decap_4 fill_19_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_10 ();
 sky130_fd_sc_hd__decap_4 fill_21_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_10 ();
 sky130_fd_sc_hd__decap_4 fill_23_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_9 ();
 sky130_fd_sc_hd__decap_4 fill_25_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_10 ();
 sky130_fd_sc_hd__decap_4 fill_27_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_10 ();
 sky130_fd_sc_hd__decap_4 fill_29_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_10 ();
 sky130_fd_sc_hd__decap_4 fill_31_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_10 ();
 sky130_fd_sc_hd__decap_4 fill_33_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_10 ();
 sky130_fd_sc_hd__decap_4 fill_35_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_10 ();
 sky130_fd_sc_hd__decap_4 fill_37_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_10 ();
 sky130_fd_sc_hd__decap_4 fill_39_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_10 ();
 sky130_fd_sc_hd__decap_4 fill_41_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_10 ();
 sky130_fd_sc_hd__decap_4 fill_43_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_10 ();
 sky130_fd_sc_hd__decap_4 fill_45_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_10 ();
 sky130_fd_sc_hd__decap_4 fill_47_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_10 ();
 sky130_fd_sc_hd__decap_4 fill_49_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_10 ();
 sky130_fd_sc_hd__decap_4 fill_51_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_10 ();
 sky130_fd_sc_hd__decap_4 fill_53_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_10 ();
 sky130_fd_sc_hd__decap_4 fill_55_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_10 ();
 sky130_fd_sc_hd__decap_4 fill_57_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_10 ();
 sky130_fd_sc_hd__decap_4 fill_59_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_10 ();
 sky130_fd_sc_hd__decap_4 fill_61_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_11 ();
 sky130_fd_sc_hd__fill_2 fill_1_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_12 ();
 sky130_fd_sc_hd__fill_2 fill_3_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_12 ();
 sky130_fd_sc_hd__fill_2 fill_5_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_12 ();
 sky130_fd_sc_hd__fill_2 fill_7_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_11 ();
 sky130_fd_sc_hd__fill_2 fill_9_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_12 ();
 sky130_fd_sc_hd__fill_2 fill_11_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_12 ();
 sky130_fd_sc_hd__fill_2 fill_13_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_11 ();
 sky130_fd_sc_hd__fill_2 fill_15_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_11 ();
 sky130_fd_sc_hd__fill_2 fill_17_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_12 ();
 sky130_fd_sc_hd__fill_2 fill_19_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_12 ();
 sky130_fd_sc_hd__fill_2 fill_21_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_12 ();
 sky130_fd_sc_hd__fill_2 fill_23_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_11 ();
 sky130_fd_sc_hd__fill_2 fill_25_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_12 ();
 sky130_fd_sc_hd__fill_2 fill_27_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_12 ();
 sky130_fd_sc_hd__fill_2 fill_29_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_12 ();
 sky130_fd_sc_hd__fill_2 fill_31_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_12 ();
 sky130_fd_sc_hd__fill_2 fill_33_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_12 ();
 sky130_fd_sc_hd__fill_2 fill_35_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_12 ();
 sky130_fd_sc_hd__fill_2 fill_37_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_12 ();
 sky130_fd_sc_hd__fill_2 fill_39_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_12 ();
 sky130_fd_sc_hd__fill_2 fill_41_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_12 ();
 sky130_fd_sc_hd__fill_2 fill_43_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_12 ();
 sky130_fd_sc_hd__fill_2 fill_45_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_12 ();
 sky130_fd_sc_hd__fill_2 fill_47_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_12 ();
 sky130_fd_sc_hd__fill_2 fill_49_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_12 ();
 sky130_fd_sc_hd__fill_2 fill_51_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_12 ();
 sky130_fd_sc_hd__fill_2 fill_53_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_12 ();
 sky130_fd_sc_hd__fill_2 fill_55_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_12 ();
 sky130_fd_sc_hd__fill_2 fill_57_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_12 ();
 sky130_fd_sc_hd__fill_2 fill_59_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_12 ();
 sky130_fd_sc_hd__fill_2 fill_61_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_13 ();
 sky130_fd_sc_hd__fill_2 fill_1_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_14 ();
 sky130_fd_sc_hd__fill_2 fill_3_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_14 ();
 sky130_fd_sc_hd__fill_2 fill_5_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_14 ();
 sky130_fd_sc_hd__fill_2 fill_7_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_13 ();
 sky130_fd_sc_hd__fill_2 fill_9_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_14 ();
 sky130_fd_sc_hd__fill_2 fill_11_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_14 ();
 sky130_fd_sc_hd__fill_2 fill_13_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_13 ();
 sky130_fd_sc_hd__fill_2 fill_15_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_13 ();
 sky130_fd_sc_hd__fill_2 fill_17_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_14 ();
 sky130_fd_sc_hd__fill_2 fill_19_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_14 ();
 sky130_fd_sc_hd__fill_2 fill_21_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_14 ();
 sky130_fd_sc_hd__fill_2 fill_23_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_13 ();
 sky130_fd_sc_hd__fill_2 fill_25_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_14 ();
 sky130_fd_sc_hd__fill_2 fill_27_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_14 ();
 sky130_fd_sc_hd__fill_2 fill_29_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_14 ();
 sky130_fd_sc_hd__fill_2 fill_31_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_14 ();
 sky130_fd_sc_hd__fill_2 fill_33_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_14 ();
 sky130_fd_sc_hd__fill_2 fill_35_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_14 ();
 sky130_fd_sc_hd__fill_2 fill_37_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_14 ();
 sky130_fd_sc_hd__fill_2 fill_39_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_14 ();
 sky130_fd_sc_hd__fill_2 fill_41_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_14 ();
 sky130_fd_sc_hd__fill_2 fill_43_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_14 ();
 sky130_fd_sc_hd__fill_2 fill_45_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_14 ();
 sky130_fd_sc_hd__fill_2 fill_47_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_14 ();
 sky130_fd_sc_hd__fill_2 fill_49_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_14 ();
 sky130_fd_sc_hd__fill_2 fill_51_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_14 ();
 sky130_fd_sc_hd__fill_2 fill_53_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_14 ();
 sky130_fd_sc_hd__fill_2 fill_55_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_14 ();
 sky130_fd_sc_hd__fill_2 fill_57_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_14 ();
 sky130_fd_sc_hd__fill_2 fill_59_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_14 ();
 sky130_fd_sc_hd__fill_2 fill_61_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_1_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_3_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_5_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_7_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_9_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_11_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_13_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_15_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_17_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_19_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_21_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_23_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_25_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_27_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_29_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_31_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_33_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_35_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_37_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_39_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_41_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_43_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_45_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_47_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_49_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_51_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_53_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_55_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_57_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_59_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_61_2 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_6 ();
 sky130_fd_sc_hd__decap_8 fill_0_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_11 ();
 sky130_fd_sc_hd__decap_12 fill_2_12 ();
 sky130_fd_sc_hd__decap_8 fill_2_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_11 ();
 sky130_fd_sc_hd__decap_12 fill_4_12 ();
 sky130_fd_sc_hd__decap_8 fill_4_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_11 ();
 sky130_fd_sc_hd__decap_12 fill_6_12 ();
 sky130_fd_sc_hd__decap_8 fill_6_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_11 ();
 sky130_fd_sc_hd__decap_12 fill_8_12 ();
 sky130_fd_sc_hd__decap_8 fill_8_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_11 ();
 sky130_fd_sc_hd__decap_12 fill_10_12 ();
 sky130_fd_sc_hd__decap_8 fill_10_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_11 ();
 sky130_fd_sc_hd__decap_12 fill_12_12 ();
 sky130_fd_sc_hd__decap_8 fill_12_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_10 ();
 sky130_fd_sc_hd__decap_12 fill_14_11 ();
 sky130_fd_sc_hd__decap_8 fill_14_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_8 ();
 sky130_fd_sc_hd__decap_12 fill_16_9 ();
 sky130_fd_sc_hd__decap_8 fill_16_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_11 ();
 sky130_fd_sc_hd__decap_12 fill_18_12 ();
 sky130_fd_sc_hd__decap_8 fill_18_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_11 ();
 sky130_fd_sc_hd__decap_12 fill_20_12 ();
 sky130_fd_sc_hd__decap_8 fill_20_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_11 ();
 sky130_fd_sc_hd__decap_12 fill_22_12 ();
 sky130_fd_sc_hd__decap_8 fill_22_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_11 ();
 sky130_fd_sc_hd__decap_12 fill_24_12 ();
 sky130_fd_sc_hd__decap_8 fill_24_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_11 ();
 sky130_fd_sc_hd__decap_12 fill_26_12 ();
 sky130_fd_sc_hd__decap_8 fill_26_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_11 ();
 sky130_fd_sc_hd__decap_12 fill_28_12 ();
 sky130_fd_sc_hd__decap_8 fill_28_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_11 ();
 sky130_fd_sc_hd__decap_12 fill_30_12 ();
 sky130_fd_sc_hd__decap_8 fill_30_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_12 ();
 sky130_fd_sc_hd__decap_12 fill_32_13 ();
 sky130_fd_sc_hd__decap_8 fill_32_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_12 ();
 sky130_fd_sc_hd__decap_12 fill_34_13 ();
 sky130_fd_sc_hd__decap_8 fill_34_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_12 ();
 sky130_fd_sc_hd__decap_12 fill_36_13 ();
 sky130_fd_sc_hd__decap_8 fill_36_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_12 ();
 sky130_fd_sc_hd__decap_12 fill_38_13 ();
 sky130_fd_sc_hd__decap_8 fill_38_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_12 ();
 sky130_fd_sc_hd__decap_12 fill_40_13 ();
 sky130_fd_sc_hd__decap_8 fill_40_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_12 ();
 sky130_fd_sc_hd__decap_12 fill_42_13 ();
 sky130_fd_sc_hd__decap_8 fill_42_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_12 ();
 sky130_fd_sc_hd__decap_12 fill_44_13 ();
 sky130_fd_sc_hd__decap_8 fill_44_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_12 ();
 sky130_fd_sc_hd__decap_12 fill_46_13 ();
 sky130_fd_sc_hd__decap_8 fill_46_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_12 ();
 sky130_fd_sc_hd__decap_12 fill_48_13 ();
 sky130_fd_sc_hd__decap_8 fill_48_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_12 ();
 sky130_fd_sc_hd__decap_12 fill_50_13 ();
 sky130_fd_sc_hd__decap_8 fill_50_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_12 ();
 sky130_fd_sc_hd__decap_12 fill_52_13 ();
 sky130_fd_sc_hd__decap_8 fill_52_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_12 ();
 sky130_fd_sc_hd__decap_12 fill_54_13 ();
 sky130_fd_sc_hd__decap_8 fill_54_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_12 ();
 sky130_fd_sc_hd__decap_12 fill_56_13 ();
 sky130_fd_sc_hd__decap_8 fill_56_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_12 ();
 sky130_fd_sc_hd__decap_12 fill_58_13 ();
 sky130_fd_sc_hd__decap_8 fill_58_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_12 ();
 sky130_fd_sc_hd__decap_12 fill_60_13 ();
 sky130_fd_sc_hd__decap_8 fill_60_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_11 ();
 sky130_fd_sc_hd__decap_12 fill_62_12 ();
 sky130_fd_sc_hd__decap_8 fill_62_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_19 ();
 sky130_fd_sc_hd__fill_2 fill_1_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_20 ();
 sky130_fd_sc_hd__fill_2 fill_3_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_20 ();
 sky130_fd_sc_hd__fill_2 fill_5_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_20 ();
 sky130_fd_sc_hd__fill_2 fill_7_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_19 ();
 sky130_fd_sc_hd__fill_2 fill_9_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_20 ();
 sky130_fd_sc_hd__fill_2 fill_11_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_20 ();
 sky130_fd_sc_hd__fill_2 fill_13_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_19 ();
 sky130_fd_sc_hd__fill_2 fill_15_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_19 ();
 sky130_fd_sc_hd__fill_2 fill_17_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_20 ();
 sky130_fd_sc_hd__fill_2 fill_19_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_20 ();
 sky130_fd_sc_hd__fill_2 fill_21_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_20 ();
 sky130_fd_sc_hd__fill_2 fill_23_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_19 ();
 sky130_fd_sc_hd__fill_2 fill_25_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_20 ();
 sky130_fd_sc_hd__fill_2 fill_27_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_20 ();
 sky130_fd_sc_hd__fill_2 fill_29_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_20 ();
 sky130_fd_sc_hd__fill_2 fill_31_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_20 ();
 sky130_fd_sc_hd__fill_2 fill_33_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_20 ();
 sky130_fd_sc_hd__fill_2 fill_35_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_20 ();
 sky130_fd_sc_hd__fill_2 fill_37_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_20 ();
 sky130_fd_sc_hd__fill_2 fill_39_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_20 ();
 sky130_fd_sc_hd__fill_2 fill_41_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_20 ();
 sky130_fd_sc_hd__fill_2 fill_43_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_20 ();
 sky130_fd_sc_hd__fill_2 fill_45_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_20 ();
 sky130_fd_sc_hd__fill_2 fill_47_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_20 ();
 sky130_fd_sc_hd__fill_2 fill_49_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_20 ();
 sky130_fd_sc_hd__fill_2 fill_51_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_20 ();
 sky130_fd_sc_hd__fill_2 fill_53_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_20 ();
 sky130_fd_sc_hd__fill_2 fill_55_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_20 ();
 sky130_fd_sc_hd__fill_2 fill_57_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_20 ();
 sky130_fd_sc_hd__fill_2 fill_59_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_20 ();
 sky130_fd_sc_hd__fill_2 fill_61_21 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_21 ();
 sky130_fd_sc_hd__fill_2 fill_1_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_22 ();
 sky130_fd_sc_hd__fill_2 fill_3_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_22 ();
 sky130_fd_sc_hd__fill_2 fill_5_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_22 ();
 sky130_fd_sc_hd__fill_2 fill_7_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_21 ();
 sky130_fd_sc_hd__fill_2 fill_9_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_22 ();
 sky130_fd_sc_hd__fill_2 fill_11_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_22 ();
 sky130_fd_sc_hd__fill_2 fill_13_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_21 ();
 sky130_fd_sc_hd__fill_2 fill_15_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_21 ();
 sky130_fd_sc_hd__fill_2 fill_17_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_22 ();
 sky130_fd_sc_hd__fill_2 fill_19_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_22 ();
 sky130_fd_sc_hd__fill_2 fill_21_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_22 ();
 sky130_fd_sc_hd__fill_2 fill_23_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_21 ();
 sky130_fd_sc_hd__fill_2 fill_25_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_22 ();
 sky130_fd_sc_hd__fill_2 fill_27_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_22 ();
 sky130_fd_sc_hd__fill_2 fill_29_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_22 ();
 sky130_fd_sc_hd__fill_2 fill_31_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_22 ();
 sky130_fd_sc_hd__fill_2 fill_33_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_22 ();
 sky130_fd_sc_hd__fill_2 fill_35_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_22 ();
 sky130_fd_sc_hd__fill_2 fill_37_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_22 ();
 sky130_fd_sc_hd__fill_2 fill_39_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_22 ();
 sky130_fd_sc_hd__fill_2 fill_41_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_22 ();
 sky130_fd_sc_hd__fill_2 fill_43_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_22 ();
 sky130_fd_sc_hd__fill_2 fill_45_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_22 ();
 sky130_fd_sc_hd__fill_2 fill_47_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_22 ();
 sky130_fd_sc_hd__fill_2 fill_49_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_22 ();
 sky130_fd_sc_hd__fill_2 fill_51_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_22 ();
 sky130_fd_sc_hd__fill_2 fill_53_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_22 ();
 sky130_fd_sc_hd__fill_2 fill_55_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_22 ();
 sky130_fd_sc_hd__fill_2 fill_57_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_22 ();
 sky130_fd_sc_hd__fill_2 fill_59_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_22 ();
 sky130_fd_sc_hd__fill_2 fill_61_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_23 ();
 sky130_fd_sc_hd__decap_4 fill_1_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_16 ();
 sky130_fd_sc_hd__fill_2 fill_2_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_24 ();
 sky130_fd_sc_hd__decap_4 fill_3_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_16 ();
 sky130_fd_sc_hd__fill_2 fill_4_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_24 ();
 sky130_fd_sc_hd__decap_4 fill_5_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_16 ();
 sky130_fd_sc_hd__fill_2 fill_6_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_24 ();
 sky130_fd_sc_hd__decap_4 fill_7_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_16 ();
 sky130_fd_sc_hd__fill_2 fill_8_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_23 ();
 sky130_fd_sc_hd__decap_4 fill_9_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_16 ();
 sky130_fd_sc_hd__fill_2 fill_10_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_24 ();
 sky130_fd_sc_hd__decap_4 fill_11_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_16 ();
 sky130_fd_sc_hd__fill_2 fill_12_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_24 ();
 sky130_fd_sc_hd__decap_4 fill_13_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_15 ();
 sky130_fd_sc_hd__fill_2 fill_14_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_23 ();
 sky130_fd_sc_hd__decap_4 fill_15_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_13 ();
 sky130_fd_sc_hd__fill_2 fill_16_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_23 ();
 sky130_fd_sc_hd__decap_4 fill_17_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_16 ();
 sky130_fd_sc_hd__fill_2 fill_18_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_24 ();
 sky130_fd_sc_hd__decap_4 fill_19_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_16 ();
 sky130_fd_sc_hd__fill_2 fill_20_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_24 ();
 sky130_fd_sc_hd__decap_4 fill_21_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_16 ();
 sky130_fd_sc_hd__fill_2 fill_22_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_24 ();
 sky130_fd_sc_hd__decap_4 fill_23_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_16 ();
 sky130_fd_sc_hd__fill_2 fill_24_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_23 ();
 sky130_fd_sc_hd__decap_4 fill_25_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_16 ();
 sky130_fd_sc_hd__fill_2 fill_26_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_24 ();
 sky130_fd_sc_hd__decap_4 fill_27_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_16 ();
 sky130_fd_sc_hd__fill_2 fill_28_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_24 ();
 sky130_fd_sc_hd__decap_4 fill_29_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_16 ();
 sky130_fd_sc_hd__fill_2 fill_30_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_24 ();
 sky130_fd_sc_hd__decap_4 fill_31_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_17 ();
 sky130_fd_sc_hd__fill_2 fill_32_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_24 ();
 sky130_fd_sc_hd__decap_4 fill_33_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_17 ();
 sky130_fd_sc_hd__fill_2 fill_34_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_24 ();
 sky130_fd_sc_hd__decap_4 fill_35_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_17 ();
 sky130_fd_sc_hd__fill_2 fill_36_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_24 ();
 sky130_fd_sc_hd__decap_4 fill_37_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_17 ();
 sky130_fd_sc_hd__fill_2 fill_38_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_24 ();
 sky130_fd_sc_hd__decap_4 fill_39_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_17 ();
 sky130_fd_sc_hd__fill_2 fill_40_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_24 ();
 sky130_fd_sc_hd__decap_4 fill_41_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_17 ();
 sky130_fd_sc_hd__fill_2 fill_42_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_24 ();
 sky130_fd_sc_hd__decap_4 fill_43_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_17 ();
 sky130_fd_sc_hd__fill_2 fill_44_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_24 ();
 sky130_fd_sc_hd__decap_4 fill_45_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_17 ();
 sky130_fd_sc_hd__fill_2 fill_46_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_24 ();
 sky130_fd_sc_hd__decap_4 fill_47_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_17 ();
 sky130_fd_sc_hd__fill_2 fill_48_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_24 ();
 sky130_fd_sc_hd__decap_4 fill_49_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_17 ();
 sky130_fd_sc_hd__fill_2 fill_50_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_24 ();
 sky130_fd_sc_hd__decap_4 fill_51_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_17 ();
 sky130_fd_sc_hd__fill_2 fill_52_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_24 ();
 sky130_fd_sc_hd__decap_4 fill_53_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_17 ();
 sky130_fd_sc_hd__fill_2 fill_54_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_24 ();
 sky130_fd_sc_hd__decap_4 fill_55_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_17 ();
 sky130_fd_sc_hd__fill_2 fill_56_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_24 ();
 sky130_fd_sc_hd__decap_4 fill_57_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_17 ();
 sky130_fd_sc_hd__fill_2 fill_58_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_24 ();
 sky130_fd_sc_hd__decap_4 fill_59_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_17 ();
 sky130_fd_sc_hd__fill_2 fill_60_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_24 ();
 sky130_fd_sc_hd__decap_4 fill_61_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_16 ();
 sky130_fd_sc_hd__fill_2 fill_62_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_25 ();
 sky130_fd_sc_hd__fill_2 fill_1_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_26 ();
 sky130_fd_sc_hd__fill_2 fill_3_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_26 ();
 sky130_fd_sc_hd__fill_2 fill_5_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_26 ();
 sky130_fd_sc_hd__fill_2 fill_7_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_25 ();
 sky130_fd_sc_hd__fill_2 fill_9_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_26 ();
 sky130_fd_sc_hd__fill_2 fill_11_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_26 ();
 sky130_fd_sc_hd__fill_2 fill_13_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_25 ();
 sky130_fd_sc_hd__fill_2 fill_15_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_25 ();
 sky130_fd_sc_hd__fill_2 fill_17_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_26 ();
 sky130_fd_sc_hd__fill_2 fill_19_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_26 ();
 sky130_fd_sc_hd__fill_2 fill_21_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_26 ();
 sky130_fd_sc_hd__fill_2 fill_23_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_25 ();
 sky130_fd_sc_hd__fill_2 fill_25_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_26 ();
 sky130_fd_sc_hd__fill_2 fill_27_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_26 ();
 sky130_fd_sc_hd__fill_2 fill_29_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_26 ();
 sky130_fd_sc_hd__fill_2 fill_31_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_26 ();
 sky130_fd_sc_hd__fill_2 fill_33_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_26 ();
 sky130_fd_sc_hd__fill_2 fill_35_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_26 ();
 sky130_fd_sc_hd__fill_2 fill_37_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_26 ();
 sky130_fd_sc_hd__fill_2 fill_39_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_26 ();
 sky130_fd_sc_hd__fill_2 fill_41_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_26 ();
 sky130_fd_sc_hd__fill_2 fill_43_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_26 ();
 sky130_fd_sc_hd__fill_2 fill_45_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_26 ();
 sky130_fd_sc_hd__fill_2 fill_47_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_26 ();
 sky130_fd_sc_hd__fill_2 fill_49_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_26 ();
 sky130_fd_sc_hd__fill_2 fill_51_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_26 ();
 sky130_fd_sc_hd__fill_2 fill_53_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_26 ();
 sky130_fd_sc_hd__fill_2 fill_55_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_26 ();
 sky130_fd_sc_hd__fill_2 fill_57_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_26 ();
 sky130_fd_sc_hd__fill_2 fill_59_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_26 ();
 sky130_fd_sc_hd__fill_2 fill_61_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_27 ();
 sky130_fd_sc_hd__fill_2 fill_1_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_28 ();
 sky130_fd_sc_hd__fill_2 fill_3_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_28 ();
 sky130_fd_sc_hd__fill_2 fill_5_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_28 ();
 sky130_fd_sc_hd__fill_2 fill_7_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_27 ();
 sky130_fd_sc_hd__fill_2 fill_9_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_28 ();
 sky130_fd_sc_hd__fill_2 fill_11_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_28 ();
 sky130_fd_sc_hd__fill_2 fill_13_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_27 ();
 sky130_fd_sc_hd__fill_2 fill_15_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_27 ();
 sky130_fd_sc_hd__fill_2 fill_17_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_28 ();
 sky130_fd_sc_hd__fill_2 fill_19_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_28 ();
 sky130_fd_sc_hd__fill_2 fill_21_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_28 ();
 sky130_fd_sc_hd__fill_2 fill_23_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_27 ();
 sky130_fd_sc_hd__fill_2 fill_25_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_28 ();
 sky130_fd_sc_hd__fill_2 fill_27_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_28 ();
 sky130_fd_sc_hd__fill_2 fill_29_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_28 ();
 sky130_fd_sc_hd__fill_2 fill_31_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_28 ();
 sky130_fd_sc_hd__fill_2 fill_33_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_28 ();
 sky130_fd_sc_hd__fill_2 fill_35_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_28 ();
 sky130_fd_sc_hd__fill_2 fill_37_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_28 ();
 sky130_fd_sc_hd__fill_2 fill_39_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_28 ();
 sky130_fd_sc_hd__fill_2 fill_41_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_28 ();
 sky130_fd_sc_hd__fill_2 fill_43_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_28 ();
 sky130_fd_sc_hd__fill_2 fill_45_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_28 ();
 sky130_fd_sc_hd__fill_2 fill_47_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_28 ();
 sky130_fd_sc_hd__fill_2 fill_49_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_28 ();
 sky130_fd_sc_hd__fill_2 fill_51_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_28 ();
 sky130_fd_sc_hd__fill_2 fill_53_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_28 ();
 sky130_fd_sc_hd__fill_2 fill_55_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_28 ();
 sky130_fd_sc_hd__fill_2 fill_57_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_28 ();
 sky130_fd_sc_hd__fill_2 fill_59_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_28 ();
 sky130_fd_sc_hd__fill_2 fill_61_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_19 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_1_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_3_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_5_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_7_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_9_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_11_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_13_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_15_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_17_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_19_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_21_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_23_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_25_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_27_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_29_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_31_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_33_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_35_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_37_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_39_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_41_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_43_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_45_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_47_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_49_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_51_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_53_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_55_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_57_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_59_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_61_3 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_5 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_8 ();
 sky130_fd_sc_hd__decap_12 fill_0_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_20 ();
 sky130_fd_sc_hd__decap_12 fill_2_21 ();
 sky130_fd_sc_hd__decap_12 fill_2_22 ();
 sky130_fd_sc_hd__fill_2 fill_2_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_20 ();
 sky130_fd_sc_hd__decap_12 fill_4_21 ();
 sky130_fd_sc_hd__decap_12 fill_4_22 ();
 sky130_fd_sc_hd__fill_2 fill_4_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_20 ();
 sky130_fd_sc_hd__decap_12 fill_6_21 ();
 sky130_fd_sc_hd__decap_12 fill_6_22 ();
 sky130_fd_sc_hd__fill_2 fill_6_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_20 ();
 sky130_fd_sc_hd__decap_12 fill_8_21 ();
 sky130_fd_sc_hd__decap_12 fill_8_22 ();
 sky130_fd_sc_hd__fill_2 fill_8_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_20 ();
 sky130_fd_sc_hd__decap_12 fill_10_21 ();
 sky130_fd_sc_hd__decap_12 fill_10_22 ();
 sky130_fd_sc_hd__fill_2 fill_10_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_20 ();
 sky130_fd_sc_hd__decap_12 fill_12_21 ();
 sky130_fd_sc_hd__decap_12 fill_12_22 ();
 sky130_fd_sc_hd__fill_2 fill_12_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_19 ();
 sky130_fd_sc_hd__decap_12 fill_14_20 ();
 sky130_fd_sc_hd__decap_12 fill_14_21 ();
 sky130_fd_sc_hd__fill_2 fill_14_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_17 ();
 sky130_fd_sc_hd__decap_12 fill_16_18 ();
 sky130_fd_sc_hd__decap_12 fill_16_19 ();
 sky130_fd_sc_hd__fill_2 fill_16_20 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_20 ();
 sky130_fd_sc_hd__decap_12 fill_18_21 ();
 sky130_fd_sc_hd__decap_12 fill_18_22 ();
 sky130_fd_sc_hd__fill_2 fill_18_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_20 ();
 sky130_fd_sc_hd__decap_12 fill_20_21 ();
 sky130_fd_sc_hd__decap_12 fill_20_22 ();
 sky130_fd_sc_hd__fill_2 fill_20_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_20 ();
 sky130_fd_sc_hd__decap_12 fill_22_21 ();
 sky130_fd_sc_hd__decap_12 fill_22_22 ();
 sky130_fd_sc_hd__fill_2 fill_22_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_20 ();
 sky130_fd_sc_hd__decap_12 fill_24_21 ();
 sky130_fd_sc_hd__decap_12 fill_24_22 ();
 sky130_fd_sc_hd__fill_2 fill_24_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_20 ();
 sky130_fd_sc_hd__decap_12 fill_26_21 ();
 sky130_fd_sc_hd__decap_12 fill_26_22 ();
 sky130_fd_sc_hd__fill_2 fill_26_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_20 ();
 sky130_fd_sc_hd__decap_12 fill_28_21 ();
 sky130_fd_sc_hd__decap_12 fill_28_22 ();
 sky130_fd_sc_hd__fill_2 fill_28_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_20 ();
 sky130_fd_sc_hd__decap_12 fill_30_21 ();
 sky130_fd_sc_hd__decap_12 fill_30_22 ();
 sky130_fd_sc_hd__fill_2 fill_30_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_21 ();
 sky130_fd_sc_hd__decap_12 fill_32_22 ();
 sky130_fd_sc_hd__decap_12 fill_32_23 ();
 sky130_fd_sc_hd__fill_2 fill_32_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_21 ();
 sky130_fd_sc_hd__decap_12 fill_34_22 ();
 sky130_fd_sc_hd__decap_12 fill_34_23 ();
 sky130_fd_sc_hd__fill_2 fill_34_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_21 ();
 sky130_fd_sc_hd__decap_12 fill_36_22 ();
 sky130_fd_sc_hd__decap_12 fill_36_23 ();
 sky130_fd_sc_hd__fill_2 fill_36_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_21 ();
 sky130_fd_sc_hd__decap_12 fill_38_22 ();
 sky130_fd_sc_hd__decap_12 fill_38_23 ();
 sky130_fd_sc_hd__fill_2 fill_38_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_21 ();
 sky130_fd_sc_hd__decap_12 fill_40_22 ();
 sky130_fd_sc_hd__decap_12 fill_40_23 ();
 sky130_fd_sc_hd__fill_2 fill_40_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_21 ();
 sky130_fd_sc_hd__decap_12 fill_42_22 ();
 sky130_fd_sc_hd__decap_12 fill_42_23 ();
 sky130_fd_sc_hd__fill_2 fill_42_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_21 ();
 sky130_fd_sc_hd__decap_12 fill_44_22 ();
 sky130_fd_sc_hd__decap_12 fill_44_23 ();
 sky130_fd_sc_hd__fill_2 fill_44_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_21 ();
 sky130_fd_sc_hd__decap_12 fill_46_22 ();
 sky130_fd_sc_hd__decap_12 fill_46_23 ();
 sky130_fd_sc_hd__fill_2 fill_46_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_21 ();
 sky130_fd_sc_hd__decap_12 fill_48_22 ();
 sky130_fd_sc_hd__decap_12 fill_48_23 ();
 sky130_fd_sc_hd__fill_2 fill_48_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_21 ();
 sky130_fd_sc_hd__decap_12 fill_50_22 ();
 sky130_fd_sc_hd__decap_12 fill_50_23 ();
 sky130_fd_sc_hd__fill_2 fill_50_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_21 ();
 sky130_fd_sc_hd__decap_12 fill_52_22 ();
 sky130_fd_sc_hd__decap_12 fill_52_23 ();
 sky130_fd_sc_hd__fill_2 fill_52_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_21 ();
 sky130_fd_sc_hd__decap_12 fill_54_22 ();
 sky130_fd_sc_hd__decap_12 fill_54_23 ();
 sky130_fd_sc_hd__fill_2 fill_54_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_21 ();
 sky130_fd_sc_hd__decap_12 fill_56_22 ();
 sky130_fd_sc_hd__decap_12 fill_56_23 ();
 sky130_fd_sc_hd__fill_2 fill_56_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_21 ();
 sky130_fd_sc_hd__decap_12 fill_58_22 ();
 sky130_fd_sc_hd__decap_12 fill_58_23 ();
 sky130_fd_sc_hd__fill_2 fill_58_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_21 ();
 sky130_fd_sc_hd__decap_12 fill_60_22 ();
 sky130_fd_sc_hd__decap_12 fill_60_23 ();
 sky130_fd_sc_hd__fill_2 fill_60_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_20 ();
 sky130_fd_sc_hd__decap_12 fill_62_21 ();
 sky130_fd_sc_hd__decap_12 fill_62_22 ();
 sky130_fd_sc_hd__fill_2 fill_62_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_6 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_31 ();
 sky130_fd_sc_hd__fill_2 fill_1_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_32 ();
 sky130_fd_sc_hd__fill_2 fill_3_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_32 ();
 sky130_fd_sc_hd__fill_2 fill_5_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_32 ();
 sky130_fd_sc_hd__fill_2 fill_7_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_31 ();
 sky130_fd_sc_hd__fill_2 fill_9_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_32 ();
 sky130_fd_sc_hd__fill_2 fill_11_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_32 ();
 sky130_fd_sc_hd__fill_2 fill_13_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_31 ();
 sky130_fd_sc_hd__fill_2 fill_15_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_31 ();
 sky130_fd_sc_hd__fill_2 fill_17_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_32 ();
 sky130_fd_sc_hd__fill_2 fill_19_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_32 ();
 sky130_fd_sc_hd__fill_2 fill_21_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_32 ();
 sky130_fd_sc_hd__fill_2 fill_23_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_31 ();
 sky130_fd_sc_hd__fill_2 fill_25_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_32 ();
 sky130_fd_sc_hd__fill_2 fill_27_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_32 ();
 sky130_fd_sc_hd__fill_2 fill_29_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_32 ();
 sky130_fd_sc_hd__fill_2 fill_31_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_32 ();
 sky130_fd_sc_hd__fill_2 fill_33_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_32 ();
 sky130_fd_sc_hd__fill_2 fill_35_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_32 ();
 sky130_fd_sc_hd__fill_2 fill_37_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_32 ();
 sky130_fd_sc_hd__fill_2 fill_39_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_32 ();
 sky130_fd_sc_hd__fill_2 fill_41_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_32 ();
 sky130_fd_sc_hd__fill_2 fill_43_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_32 ();
 sky130_fd_sc_hd__fill_2 fill_45_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_32 ();
 sky130_fd_sc_hd__fill_2 fill_47_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_32 ();
 sky130_fd_sc_hd__fill_2 fill_49_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_32 ();
 sky130_fd_sc_hd__fill_2 fill_51_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_32 ();
 sky130_fd_sc_hd__fill_2 fill_53_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_32 ();
 sky130_fd_sc_hd__fill_2 fill_55_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_32 ();
 sky130_fd_sc_hd__fill_2 fill_57_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_32 ();
 sky130_fd_sc_hd__fill_2 fill_59_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_32 ();
 sky130_fd_sc_hd__fill_2 fill_61_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_7 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_33 ();
 sky130_fd_sc_hd__fill_2 fill_1_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_34 ();
 sky130_fd_sc_hd__fill_2 fill_3_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_34 ();
 sky130_fd_sc_hd__fill_2 fill_5_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_34 ();
 sky130_fd_sc_hd__fill_2 fill_7_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_33 ();
 sky130_fd_sc_hd__fill_2 fill_9_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_34 ();
 sky130_fd_sc_hd__fill_2 fill_11_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_34 ();
 sky130_fd_sc_hd__fill_2 fill_13_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_33 ();
 sky130_fd_sc_hd__fill_2 fill_15_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_33 ();
 sky130_fd_sc_hd__fill_2 fill_17_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_34 ();
 sky130_fd_sc_hd__fill_2 fill_19_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_34 ();
 sky130_fd_sc_hd__fill_2 fill_21_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_34 ();
 sky130_fd_sc_hd__fill_2 fill_23_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_33 ();
 sky130_fd_sc_hd__fill_2 fill_25_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_34 ();
 sky130_fd_sc_hd__fill_2 fill_27_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_34 ();
 sky130_fd_sc_hd__fill_2 fill_29_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_34 ();
 sky130_fd_sc_hd__fill_2 fill_31_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_34 ();
 sky130_fd_sc_hd__fill_2 fill_33_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_34 ();
 sky130_fd_sc_hd__fill_2 fill_35_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_34 ();
 sky130_fd_sc_hd__fill_2 fill_37_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_34 ();
 sky130_fd_sc_hd__fill_2 fill_39_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_34 ();
 sky130_fd_sc_hd__fill_2 fill_41_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_34 ();
 sky130_fd_sc_hd__fill_2 fill_43_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_34 ();
 sky130_fd_sc_hd__fill_2 fill_45_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_34 ();
 sky130_fd_sc_hd__fill_2 fill_47_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_34 ();
 sky130_fd_sc_hd__fill_2 fill_49_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_34 ();
 sky130_fd_sc_hd__fill_2 fill_51_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_34 ();
 sky130_fd_sc_hd__fill_2 fill_53_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_34 ();
 sky130_fd_sc_hd__fill_2 fill_55_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_34 ();
 sky130_fd_sc_hd__fill_2 fill_57_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_34 ();
 sky130_fd_sc_hd__fill_2 fill_59_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_34 ();
 sky130_fd_sc_hd__fill_2 fill_61_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_8 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_37 ();
 sky130_fd_sc_hd__decap_4 fill_1_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_24 ();
 sky130_fd_sc_hd__fill_2 fill_2_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_38 ();
 sky130_fd_sc_hd__decap_4 fill_3_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_24 ();
 sky130_fd_sc_hd__fill_2 fill_4_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_38 ();
 sky130_fd_sc_hd__decap_4 fill_5_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_24 ();
 sky130_fd_sc_hd__fill_2 fill_6_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_38 ();
 sky130_fd_sc_hd__decap_4 fill_7_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_24 ();
 sky130_fd_sc_hd__fill_2 fill_8_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_37 ();
 sky130_fd_sc_hd__decap_4 fill_9_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_24 ();
 sky130_fd_sc_hd__fill_2 fill_10_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_38 ();
 sky130_fd_sc_hd__decap_4 fill_11_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_24 ();
 sky130_fd_sc_hd__fill_2 fill_12_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_38 ();
 sky130_fd_sc_hd__decap_4 fill_13_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_23 ();
 sky130_fd_sc_hd__fill_2 fill_14_24 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_37 ();
 sky130_fd_sc_hd__decap_4 fill_15_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_21 ();
 sky130_fd_sc_hd__fill_2 fill_16_22 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_37 ();
 sky130_fd_sc_hd__decap_4 fill_17_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_24 ();
 sky130_fd_sc_hd__fill_2 fill_18_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_38 ();
 sky130_fd_sc_hd__decap_4 fill_19_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_24 ();
 sky130_fd_sc_hd__fill_2 fill_20_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_38 ();
 sky130_fd_sc_hd__decap_4 fill_21_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_24 ();
 sky130_fd_sc_hd__fill_2 fill_22_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_38 ();
 sky130_fd_sc_hd__decap_4 fill_23_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_24 ();
 sky130_fd_sc_hd__fill_2 fill_24_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_37 ();
 sky130_fd_sc_hd__decap_4 fill_25_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_24 ();
 sky130_fd_sc_hd__fill_2 fill_26_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_38 ();
 sky130_fd_sc_hd__decap_4 fill_27_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_24 ();
 sky130_fd_sc_hd__fill_2 fill_28_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_38 ();
 sky130_fd_sc_hd__decap_4 fill_29_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_24 ();
 sky130_fd_sc_hd__fill_2 fill_30_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_38 ();
 sky130_fd_sc_hd__decap_4 fill_31_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_25 ();
 sky130_fd_sc_hd__fill_2 fill_32_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_38 ();
 sky130_fd_sc_hd__decap_4 fill_33_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_25 ();
 sky130_fd_sc_hd__fill_2 fill_34_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_38 ();
 sky130_fd_sc_hd__decap_4 fill_35_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_25 ();
 sky130_fd_sc_hd__fill_2 fill_36_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_38 ();
 sky130_fd_sc_hd__decap_4 fill_37_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_25 ();
 sky130_fd_sc_hd__fill_2 fill_38_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_38 ();
 sky130_fd_sc_hd__decap_4 fill_39_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_25 ();
 sky130_fd_sc_hd__fill_2 fill_40_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_38 ();
 sky130_fd_sc_hd__decap_4 fill_41_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_25 ();
 sky130_fd_sc_hd__fill_2 fill_42_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_38 ();
 sky130_fd_sc_hd__decap_4 fill_43_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_25 ();
 sky130_fd_sc_hd__fill_2 fill_44_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_38 ();
 sky130_fd_sc_hd__decap_4 fill_45_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_25 ();
 sky130_fd_sc_hd__fill_2 fill_46_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_38 ();
 sky130_fd_sc_hd__decap_4 fill_47_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_25 ();
 sky130_fd_sc_hd__fill_2 fill_48_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_38 ();
 sky130_fd_sc_hd__decap_4 fill_49_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_25 ();
 sky130_fd_sc_hd__fill_2 fill_50_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_38 ();
 sky130_fd_sc_hd__decap_4 fill_51_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_25 ();
 sky130_fd_sc_hd__fill_2 fill_52_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_38 ();
 sky130_fd_sc_hd__decap_4 fill_53_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_25 ();
 sky130_fd_sc_hd__fill_2 fill_54_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_38 ();
 sky130_fd_sc_hd__decap_4 fill_55_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_25 ();
 sky130_fd_sc_hd__fill_2 fill_56_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_38 ();
 sky130_fd_sc_hd__decap_4 fill_57_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_25 ();
 sky130_fd_sc_hd__fill_2 fill_58_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_38 ();
 sky130_fd_sc_hd__decap_4 fill_59_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_25 ();
 sky130_fd_sc_hd__fill_2 fill_60_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_38 ();
 sky130_fd_sc_hd__decap_4 fill_61_39 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_24 ();
 sky130_fd_sc_hd__fill_2 fill_62_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_40 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_42 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_9 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_42 ();
 sky130_fd_sc_hd__fill_2 fill_1_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_43 ();
 sky130_fd_sc_hd__fill_2 fill_3_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_43 ();
 sky130_fd_sc_hd__fill_2 fill_5_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_43 ();
 sky130_fd_sc_hd__fill_2 fill_7_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_42 ();
 sky130_fd_sc_hd__fill_2 fill_9_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_43 ();
 sky130_fd_sc_hd__fill_2 fill_11_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_43 ();
 sky130_fd_sc_hd__fill_2 fill_13_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_42 ();
 sky130_fd_sc_hd__fill_2 fill_15_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_42 ();
 sky130_fd_sc_hd__fill_2 fill_17_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_43 ();
 sky130_fd_sc_hd__fill_2 fill_19_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_43 ();
 sky130_fd_sc_hd__fill_2 fill_21_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_43 ();
 sky130_fd_sc_hd__fill_2 fill_23_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_42 ();
 sky130_fd_sc_hd__fill_2 fill_25_43 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_43 ();
 sky130_fd_sc_hd__fill_2 fill_27_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_43 ();
 sky130_fd_sc_hd__fill_2 fill_29_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_43 ();
 sky130_fd_sc_hd__fill_2 fill_31_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_43 ();
 sky130_fd_sc_hd__fill_2 fill_33_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_43 ();
 sky130_fd_sc_hd__fill_2 fill_35_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_43 ();
 sky130_fd_sc_hd__fill_2 fill_37_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_43 ();
 sky130_fd_sc_hd__fill_2 fill_39_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_43 ();
 sky130_fd_sc_hd__fill_2 fill_41_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_43 ();
 sky130_fd_sc_hd__fill_2 fill_43_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_43 ();
 sky130_fd_sc_hd__fill_2 fill_45_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_43 ();
 sky130_fd_sc_hd__fill_2 fill_47_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_43 ();
 sky130_fd_sc_hd__fill_2 fill_49_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_43 ();
 sky130_fd_sc_hd__fill_2 fill_51_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_43 ();
 sky130_fd_sc_hd__fill_2 fill_53_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_43 ();
 sky130_fd_sc_hd__fill_2 fill_55_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_43 ();
 sky130_fd_sc_hd__fill_2 fill_57_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_43 ();
 sky130_fd_sc_hd__fill_2 fill_59_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_43 ();
 sky130_fd_sc_hd__fill_2 fill_61_44 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_44 ();
 sky130_fd_sc_hd__fill_2 fill_1_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_45 ();
 sky130_fd_sc_hd__fill_2 fill_3_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_45 ();
 sky130_fd_sc_hd__fill_2 fill_5_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_45 ();
 sky130_fd_sc_hd__fill_2 fill_7_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_44 ();
 sky130_fd_sc_hd__fill_2 fill_9_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_45 ();
 sky130_fd_sc_hd__fill_2 fill_11_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_45 ();
 sky130_fd_sc_hd__fill_2 fill_13_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_25 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_44 ();
 sky130_fd_sc_hd__fill_2 fill_15_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_23 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_44 ();
 sky130_fd_sc_hd__fill_2 fill_17_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_45 ();
 sky130_fd_sc_hd__fill_2 fill_19_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_45 ();
 sky130_fd_sc_hd__fill_2 fill_21_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_45 ();
 sky130_fd_sc_hd__fill_2 fill_23_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_44 ();
 sky130_fd_sc_hd__fill_2 fill_25_45 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_45 ();
 sky130_fd_sc_hd__fill_2 fill_27_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_45 ();
 sky130_fd_sc_hd__fill_2 fill_29_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_45 ();
 sky130_fd_sc_hd__fill_2 fill_31_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_45 ();
 sky130_fd_sc_hd__fill_2 fill_33_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_45 ();
 sky130_fd_sc_hd__fill_2 fill_35_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_45 ();
 sky130_fd_sc_hd__fill_2 fill_37_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_45 ();
 sky130_fd_sc_hd__fill_2 fill_39_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_45 ();
 sky130_fd_sc_hd__fill_2 fill_41_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_45 ();
 sky130_fd_sc_hd__fill_2 fill_43_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_45 ();
 sky130_fd_sc_hd__fill_2 fill_45_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_45 ();
 sky130_fd_sc_hd__fill_2 fill_47_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_45 ();
 sky130_fd_sc_hd__fill_2 fill_49_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_45 ();
 sky130_fd_sc_hd__fill_2 fill_51_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_45 ();
 sky130_fd_sc_hd__fill_2 fill_53_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_45 ();
 sky130_fd_sc_hd__fill_2 fill_55_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_45 ();
 sky130_fd_sc_hd__fill_2 fill_57_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_45 ();
 sky130_fd_sc_hd__fill_2 fill_59_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_45 ();
 sky130_fd_sc_hd__fill_2 fill_61_46 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_26 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_1_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_3_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_5_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_7_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_9_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_11_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_13_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_15_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_17_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_19_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_21_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_23_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_25_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_27_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_29_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_31_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_33_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_35_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_37_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_39_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_41_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_43_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_45_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_47_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_49_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_51_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_53_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_55_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_57_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_59_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_61_4 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_13 ();
 sky130_fd_sc_hd__decap_8 fill_0_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_27 ();
 sky130_fd_sc_hd__decap_12 fill_2_28 ();
 sky130_fd_sc_hd__decap_8 fill_2_29 ();
 sky130_fd_sc_hd__fill_2 fill_2_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_27 ();
 sky130_fd_sc_hd__decap_12 fill_4_28 ();
 sky130_fd_sc_hd__decap_8 fill_4_29 ();
 sky130_fd_sc_hd__fill_2 fill_4_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_27 ();
 sky130_fd_sc_hd__decap_12 fill_6_28 ();
 sky130_fd_sc_hd__decap_8 fill_6_29 ();
 sky130_fd_sc_hd__fill_2 fill_6_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_27 ();
 sky130_fd_sc_hd__decap_12 fill_8_28 ();
 sky130_fd_sc_hd__decap_8 fill_8_29 ();
 sky130_fd_sc_hd__fill_2 fill_8_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_27 ();
 sky130_fd_sc_hd__decap_12 fill_10_28 ();
 sky130_fd_sc_hd__decap_8 fill_10_29 ();
 sky130_fd_sc_hd__fill_2 fill_10_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_27 ();
 sky130_fd_sc_hd__decap_12 fill_12_28 ();
 sky130_fd_sc_hd__decap_8 fill_12_29 ();
 sky130_fd_sc_hd__fill_2 fill_12_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_26 ();
 sky130_fd_sc_hd__decap_12 fill_14_27 ();
 sky130_fd_sc_hd__decap_8 fill_14_28 ();
 sky130_fd_sc_hd__fill_2 fill_14_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_24 ();
 sky130_fd_sc_hd__decap_12 fill_16_25 ();
 sky130_fd_sc_hd__decap_8 fill_16_26 ();
 sky130_fd_sc_hd__fill_2 fill_16_27 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_27 ();
 sky130_fd_sc_hd__decap_12 fill_18_28 ();
 sky130_fd_sc_hd__decap_8 fill_18_29 ();
 sky130_fd_sc_hd__fill_2 fill_18_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_27 ();
 sky130_fd_sc_hd__decap_12 fill_20_28 ();
 sky130_fd_sc_hd__decap_8 fill_20_29 ();
 sky130_fd_sc_hd__fill_2 fill_20_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_27 ();
 sky130_fd_sc_hd__decap_12 fill_22_28 ();
 sky130_fd_sc_hd__decap_8 fill_22_29 ();
 sky130_fd_sc_hd__fill_2 fill_22_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_27 ();
 sky130_fd_sc_hd__decap_12 fill_24_28 ();
 sky130_fd_sc_hd__decap_8 fill_24_29 ();
 sky130_fd_sc_hd__fill_2 fill_24_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_27 ();
 sky130_fd_sc_hd__decap_12 fill_26_28 ();
 sky130_fd_sc_hd__decap_8 fill_26_29 ();
 sky130_fd_sc_hd__fill_2 fill_26_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_27 ();
 sky130_fd_sc_hd__decap_12 fill_28_28 ();
 sky130_fd_sc_hd__decap_8 fill_28_29 ();
 sky130_fd_sc_hd__fill_2 fill_28_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_27 ();
 sky130_fd_sc_hd__decap_12 fill_30_28 ();
 sky130_fd_sc_hd__decap_8 fill_30_29 ();
 sky130_fd_sc_hd__fill_2 fill_30_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_28 ();
 sky130_fd_sc_hd__decap_12 fill_32_29 ();
 sky130_fd_sc_hd__decap_8 fill_32_30 ();
 sky130_fd_sc_hd__fill_2 fill_32_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_28 ();
 sky130_fd_sc_hd__decap_12 fill_34_29 ();
 sky130_fd_sc_hd__decap_8 fill_34_30 ();
 sky130_fd_sc_hd__fill_2 fill_34_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_28 ();
 sky130_fd_sc_hd__decap_12 fill_36_29 ();
 sky130_fd_sc_hd__decap_8 fill_36_30 ();
 sky130_fd_sc_hd__fill_2 fill_36_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_28 ();
 sky130_fd_sc_hd__decap_12 fill_38_29 ();
 sky130_fd_sc_hd__decap_8 fill_38_30 ();
 sky130_fd_sc_hd__fill_2 fill_38_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_28 ();
 sky130_fd_sc_hd__decap_12 fill_40_29 ();
 sky130_fd_sc_hd__decap_8 fill_40_30 ();
 sky130_fd_sc_hd__fill_2 fill_40_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_28 ();
 sky130_fd_sc_hd__decap_12 fill_42_29 ();
 sky130_fd_sc_hd__decap_8 fill_42_30 ();
 sky130_fd_sc_hd__fill_2 fill_42_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_28 ();
 sky130_fd_sc_hd__decap_12 fill_44_29 ();
 sky130_fd_sc_hd__decap_8 fill_44_30 ();
 sky130_fd_sc_hd__fill_2 fill_44_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_28 ();
 sky130_fd_sc_hd__decap_12 fill_46_29 ();
 sky130_fd_sc_hd__decap_8 fill_46_30 ();
 sky130_fd_sc_hd__fill_2 fill_46_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_28 ();
 sky130_fd_sc_hd__decap_12 fill_48_29 ();
 sky130_fd_sc_hd__decap_8 fill_48_30 ();
 sky130_fd_sc_hd__fill_2 fill_48_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_28 ();
 sky130_fd_sc_hd__decap_12 fill_50_29 ();
 sky130_fd_sc_hd__decap_8 fill_50_30 ();
 sky130_fd_sc_hd__fill_2 fill_50_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_28 ();
 sky130_fd_sc_hd__decap_12 fill_52_29 ();
 sky130_fd_sc_hd__decap_8 fill_52_30 ();
 sky130_fd_sc_hd__fill_2 fill_52_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_28 ();
 sky130_fd_sc_hd__decap_12 fill_54_29 ();
 sky130_fd_sc_hd__decap_8 fill_54_30 ();
 sky130_fd_sc_hd__fill_2 fill_54_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_28 ();
 sky130_fd_sc_hd__decap_12 fill_56_29 ();
 sky130_fd_sc_hd__decap_8 fill_56_30 ();
 sky130_fd_sc_hd__fill_2 fill_56_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_28 ();
 sky130_fd_sc_hd__decap_12 fill_58_29 ();
 sky130_fd_sc_hd__decap_8 fill_58_30 ();
 sky130_fd_sc_hd__fill_2 fill_58_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_28 ();
 sky130_fd_sc_hd__decap_12 fill_60_29 ();
 sky130_fd_sc_hd__decap_8 fill_60_30 ();
 sky130_fd_sc_hd__fill_2 fill_60_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_27 ();
 sky130_fd_sc_hd__decap_12 fill_62_28 ();
 sky130_fd_sc_hd__decap_8 fill_62_29 ();
 sky130_fd_sc_hd__fill_2 fill_62_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_10 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_0_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_46 ();
 sky130_fd_sc_hd__fill_2 fill_1_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_47 ();
 sky130_fd_sc_hd__fill_2 fill_3_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_47 ();
 sky130_fd_sc_hd__fill_2 fill_5_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_47 ();
 sky130_fd_sc_hd__fill_2 fill_7_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_46 ();
 sky130_fd_sc_hd__fill_2 fill_9_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_47 ();
 sky130_fd_sc_hd__fill_2 fill_11_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_47 ();
 sky130_fd_sc_hd__fill_2 fill_13_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_46 ();
 sky130_fd_sc_hd__fill_2 fill_15_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_46 ();
 sky130_fd_sc_hd__fill_2 fill_17_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_47 ();
 sky130_fd_sc_hd__fill_2 fill_19_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_47 ();
 sky130_fd_sc_hd__fill_2 fill_21_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_47 ();
 sky130_fd_sc_hd__fill_2 fill_23_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_46 ();
 sky130_fd_sc_hd__fill_2 fill_25_47 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_47 ();
 sky130_fd_sc_hd__fill_2 fill_27_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_47 ();
 sky130_fd_sc_hd__fill_2 fill_29_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_47 ();
 sky130_fd_sc_hd__fill_2 fill_31_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_47 ();
 sky130_fd_sc_hd__fill_2 fill_33_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_47 ();
 sky130_fd_sc_hd__fill_2 fill_35_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_47 ();
 sky130_fd_sc_hd__fill_2 fill_37_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_47 ();
 sky130_fd_sc_hd__fill_2 fill_39_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_47 ();
 sky130_fd_sc_hd__fill_2 fill_41_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_47 ();
 sky130_fd_sc_hd__fill_2 fill_43_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_47 ();
 sky130_fd_sc_hd__fill_2 fill_45_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_47 ();
 sky130_fd_sc_hd__fill_2 fill_47_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_47 ();
 sky130_fd_sc_hd__fill_2 fill_49_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_47 ();
 sky130_fd_sc_hd__fill_2 fill_51_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_47 ();
 sky130_fd_sc_hd__fill_2 fill_53_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_47 ();
 sky130_fd_sc_hd__fill_2 fill_55_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_47 ();
 sky130_fd_sc_hd__fill_2 fill_57_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_47 ();
 sky130_fd_sc_hd__fill_2 fill_59_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_47 ();
 sky130_fd_sc_hd__fill_2 fill_61_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_48 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_49 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_50 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_11 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_50 ();
 sky130_fd_sc_hd__fill_2 fill_1_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_51 ();
 sky130_fd_sc_hd__fill_2 fill_3_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_51 ();
 sky130_fd_sc_hd__fill_2 fill_5_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_51 ();
 sky130_fd_sc_hd__fill_2 fill_7_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_50 ();
 sky130_fd_sc_hd__fill_2 fill_9_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_51 ();
 sky130_fd_sc_hd__fill_2 fill_11_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_51 ();
 sky130_fd_sc_hd__fill_2 fill_13_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_50 ();
 sky130_fd_sc_hd__fill_2 fill_15_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_50 ();
 sky130_fd_sc_hd__fill_2 fill_17_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_51 ();
 sky130_fd_sc_hd__fill_2 fill_19_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_51 ();
 sky130_fd_sc_hd__fill_2 fill_21_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_51 ();
 sky130_fd_sc_hd__fill_2 fill_23_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_50 ();
 sky130_fd_sc_hd__fill_2 fill_25_51 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_51 ();
 sky130_fd_sc_hd__fill_2 fill_27_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_51 ();
 sky130_fd_sc_hd__fill_2 fill_29_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_51 ();
 sky130_fd_sc_hd__fill_2 fill_31_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_51 ();
 sky130_fd_sc_hd__fill_2 fill_33_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_51 ();
 sky130_fd_sc_hd__fill_2 fill_35_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_51 ();
 sky130_fd_sc_hd__fill_2 fill_37_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_51 ();
 sky130_fd_sc_hd__fill_2 fill_39_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_51 ();
 sky130_fd_sc_hd__fill_2 fill_41_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_51 ();
 sky130_fd_sc_hd__fill_2 fill_43_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_51 ();
 sky130_fd_sc_hd__fill_2 fill_45_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_51 ();
 sky130_fd_sc_hd__fill_2 fill_47_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_51 ();
 sky130_fd_sc_hd__fill_2 fill_49_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_51 ();
 sky130_fd_sc_hd__fill_2 fill_51_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_51 ();
 sky130_fd_sc_hd__fill_2 fill_53_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_51 ();
 sky130_fd_sc_hd__fill_2 fill_55_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_51 ();
 sky130_fd_sc_hd__fill_2 fill_57_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_51 ();
 sky130_fd_sc_hd__fill_2 fill_59_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_51 ();
 sky130_fd_sc_hd__fill_2 fill_61_52 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_32_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_34_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_36_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_38_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_40_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_42_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_44_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_46_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_48_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_50_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_52_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_54_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_56_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_58_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_60_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_62_12 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_52 ();
 sky130_fd_sc_hd__decap_4 fill_1_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_53 ();
 sky130_fd_sc_hd__decap_4 fill_3_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_53 ();
 sky130_fd_sc_hd__decap_4 fill_5_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_53 ();
 sky130_fd_sc_hd__decap_4 fill_7_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_52 ();
 sky130_fd_sc_hd__decap_4 fill_9_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_53 ();
 sky130_fd_sc_hd__decap_4 fill_11_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_53 ();
 sky130_fd_sc_hd__decap_4 fill_13_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_52 ();
 sky130_fd_sc_hd__decap_4 fill_15_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_28 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_29 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_52 ();
 sky130_fd_sc_hd__decap_4 fill_17_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_53 ();
 sky130_fd_sc_hd__decap_4 fill_19_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_53 ();
 sky130_fd_sc_hd__decap_4 fill_21_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_53 ();
 sky130_fd_sc_hd__decap_4 fill_23_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_52 ();
 sky130_fd_sc_hd__decap_4 fill_25_53 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_53 ();
 sky130_fd_sc_hd__decap_4 fill_27_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_53 ();
 sky130_fd_sc_hd__decap_4 fill_29_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_53 ();
 sky130_fd_sc_hd__decap_4 fill_31_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_53 ();
 sky130_fd_sc_hd__decap_4 fill_33_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_53 ();
 sky130_fd_sc_hd__decap_4 fill_35_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_53 ();
 sky130_fd_sc_hd__decap_4 fill_37_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_53 ();
 sky130_fd_sc_hd__decap_4 fill_39_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_53 ();
 sky130_fd_sc_hd__decap_4 fill_41_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_53 ();
 sky130_fd_sc_hd__decap_4 fill_43_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_53 ();
 sky130_fd_sc_hd__decap_4 fill_45_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_53 ();
 sky130_fd_sc_hd__decap_4 fill_47_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_53 ();
 sky130_fd_sc_hd__decap_4 fill_49_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_53 ();
 sky130_fd_sc_hd__decap_4 fill_51_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_53 ();
 sky130_fd_sc_hd__decap_4 fill_53_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_53 ();
 sky130_fd_sc_hd__decap_4 fill_55_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_53 ();
 sky130_fd_sc_hd__decap_4 fill_57_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_53 ();
 sky130_fd_sc_hd__decap_4 fill_59_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_53 ();
 sky130_fd_sc_hd__decap_4 fill_61_54 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_15 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_54 ();
 sky130_fd_sc_hd__fill_2 fill_1_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_55 ();
 sky130_fd_sc_hd__fill_2 fill_3_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_55 ();
 sky130_fd_sc_hd__fill_2 fill_5_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_55 ();
 sky130_fd_sc_hd__fill_2 fill_7_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_54 ();
 sky130_fd_sc_hd__fill_2 fill_9_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_55 ();
 sky130_fd_sc_hd__fill_2 fill_11_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_55 ();
 sky130_fd_sc_hd__fill_2 fill_13_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_32 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_54 ();
 sky130_fd_sc_hd__fill_2 fill_15_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_30 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_54 ();
 sky130_fd_sc_hd__fill_2 fill_17_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_55 ();
 sky130_fd_sc_hd__fill_2 fill_19_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_55 ();
 sky130_fd_sc_hd__fill_2 fill_21_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_55 ();
 sky130_fd_sc_hd__fill_2 fill_23_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_54 ();
 sky130_fd_sc_hd__fill_2 fill_25_55 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_55 ();
 sky130_fd_sc_hd__fill_2 fill_27_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_55 ();
 sky130_fd_sc_hd__fill_2 fill_29_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_55 ();
 sky130_fd_sc_hd__fill_2 fill_31_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_55 ();
 sky130_fd_sc_hd__fill_2 fill_33_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_55 ();
 sky130_fd_sc_hd__fill_2 fill_35_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_55 ();
 sky130_fd_sc_hd__fill_2 fill_37_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_55 ();
 sky130_fd_sc_hd__fill_2 fill_39_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_55 ();
 sky130_fd_sc_hd__fill_2 fill_41_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_55 ();
 sky130_fd_sc_hd__fill_2 fill_43_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_55 ();
 sky130_fd_sc_hd__fill_2 fill_45_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_55 ();
 sky130_fd_sc_hd__fill_2 fill_47_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_55 ();
 sky130_fd_sc_hd__fill_2 fill_49_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_55 ();
 sky130_fd_sc_hd__fill_2 fill_51_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_55 ();
 sky130_fd_sc_hd__fill_2 fill_53_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_55 ();
 sky130_fd_sc_hd__fill_2 fill_55_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_55 ();
 sky130_fd_sc_hd__fill_2 fill_57_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_55 ();
 sky130_fd_sc_hd__fill_2 fill_59_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_55 ();
 sky130_fd_sc_hd__fill_2 fill_61_56 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_16 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_56 ();
 sky130_fd_sc_hd__fill_2 fill_1_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_57 ();
 sky130_fd_sc_hd__fill_2 fill_3_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_57 ();
 sky130_fd_sc_hd__fill_2 fill_5_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_57 ();
 sky130_fd_sc_hd__fill_2 fill_7_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_56 ();
 sky130_fd_sc_hd__fill_2 fill_9_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_57 ();
 sky130_fd_sc_hd__fill_2 fill_11_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_57 ();
 sky130_fd_sc_hd__fill_2 fill_13_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_56 ();
 sky130_fd_sc_hd__fill_2 fill_15_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_31 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_56 ();
 sky130_fd_sc_hd__fill_2 fill_17_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_57 ();
 sky130_fd_sc_hd__fill_2 fill_19_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_57 ();
 sky130_fd_sc_hd__fill_2 fill_21_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_57 ();
 sky130_fd_sc_hd__fill_2 fill_23_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_56 ();
 sky130_fd_sc_hd__fill_2 fill_25_57 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_57 ();
 sky130_fd_sc_hd__fill_2 fill_27_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_57 ();
 sky130_fd_sc_hd__fill_2 fill_29_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_57 ();
 sky130_fd_sc_hd__fill_2 fill_31_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_57 ();
 sky130_fd_sc_hd__fill_2 fill_33_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_57 ();
 sky130_fd_sc_hd__fill_2 fill_35_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_57 ();
 sky130_fd_sc_hd__fill_2 fill_37_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_57 ();
 sky130_fd_sc_hd__fill_2 fill_39_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_57 ();
 sky130_fd_sc_hd__fill_2 fill_41_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_57 ();
 sky130_fd_sc_hd__fill_2 fill_43_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_57 ();
 sky130_fd_sc_hd__fill_2 fill_45_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_57 ();
 sky130_fd_sc_hd__fill_2 fill_47_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_57 ();
 sky130_fd_sc_hd__fill_2 fill_49_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_57 ();
 sky130_fd_sc_hd__fill_2 fill_51_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_57 ();
 sky130_fd_sc_hd__fill_2 fill_53_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_57 ();
 sky130_fd_sc_hd__fill_2 fill_55_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_57 ();
 sky130_fd_sc_hd__fill_2 fill_57_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_57 ();
 sky130_fd_sc_hd__fill_2 fill_59_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_35 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_57 ();
 sky130_fd_sc_hd__fill_2 fill_61_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_34 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_58 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_59 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_60 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_17 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_8_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_16_14 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_24_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_4_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_6_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_0_18 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_2_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_10_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_12_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_14_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_18_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_20_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_22_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_26_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_28_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 tap_30_13 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_1_60 ();
 sky130_fd_sc_hd__decap_8 fill_1_61 ();
 sky130_fd_sc_hd__decap_3 fill_1_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_2_35 ();
 sky130_fd_sc_hd__decap_8 fill_2_36 ();
 sky130_fd_sc_hd__fill_2 fill_2_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_61 ();
 sky130_fd_sc_hd__decap_12 fill_3_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_3_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_4_35 ();
 sky130_fd_sc_hd__decap_8 fill_4_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_61 ();
 sky130_fd_sc_hd__decap_12 fill_5_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_5_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_6_35 ();
 sky130_fd_sc_hd__decap_12 fill_6_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_61 ();
 sky130_fd_sc_hd__decap_12 fill_7_62 ();
 sky130_fd_sc_hd__decap_4 fill_7_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_7_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_8_35 ();
 sky130_fd_sc_hd__decap_6 fill_8_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_9_60 ();
 sky130_fd_sc_hd__decap_8 fill_9_61 ();
 sky130_fd_sc_hd__decap_3 fill_9_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_10_35 ();
 sky130_fd_sc_hd__decap_8 fill_10_36 ();
 sky130_fd_sc_hd__fill_2 fill_10_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_61 ();
 sky130_fd_sc_hd__decap_12 fill_11_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_11_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_12_35 ();
 sky130_fd_sc_hd__decap_12 fill_12_36 ();
 sky130_fd_sc_hd__decap_6 fill_12_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_61 ();
 sky130_fd_sc_hd__decap_12 fill_13_62 ();
 sky130_fd_sc_hd__decap_8 fill_13_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_13_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_14_34 ();
 sky130_fd_sc_hd__decap_12 fill_14_35 ();
 sky130_fd_sc_hd__decap_8 fill_14_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_15_60 ();
 sky130_fd_sc_hd__decap_12 fill_15_61 ();
 sky130_fd_sc_hd__decap_8 fill_15_62 ();
 sky130_fd_sc_hd__decap_3 fill_15_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_16_32 ();
 sky130_fd_sc_hd__decap_6 fill_16_33 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_17_60 ();
 sky130_fd_sc_hd__decap_8 fill_17_61 ();
 sky130_fd_sc_hd__decap_3 fill_17_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_18_35 ();
 sky130_fd_sc_hd__decap_8 fill_18_36 ();
 sky130_fd_sc_hd__fill_2 fill_18_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_61 ();
 sky130_fd_sc_hd__decap_12 fill_19_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_19_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_20_35 ();
 sky130_fd_sc_hd__decap_8 fill_20_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_61 ();
 sky130_fd_sc_hd__decap_12 fill_21_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_21_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_22_35 ();
 sky130_fd_sc_hd__decap_12 fill_22_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_61 ();
 sky130_fd_sc_hd__decap_12 fill_23_62 ();
 sky130_fd_sc_hd__decap_4 fill_23_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_23_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_24_35 ();
 sky130_fd_sc_hd__decap_6 fill_24_36 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_25_60 ();
 sky130_fd_sc_hd__decap_8 fill_25_61 ();
 sky130_fd_sc_hd__decap_3 fill_25_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_26_35 ();
 sky130_fd_sc_hd__decap_8 fill_26_36 ();
 sky130_fd_sc_hd__fill_2 fill_26_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_61 ();
 sky130_fd_sc_hd__decap_12 fill_27_62 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_27_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_28_35 ();
 sky130_fd_sc_hd__decap_12 fill_28_36 ();
 sky130_fd_sc_hd__decap_6 fill_28_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_61 ();
 sky130_fd_sc_hd__decap_12 fill_29_62 ();
 sky130_fd_sc_hd__decap_8 fill_29_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_29_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_30_35 ();
 sky130_fd_sc_hd__decap_12 fill_30_36 ();
 sky130_fd_sc_hd__decap_8 fill_30_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_31_61 ();
 sky130_fd_sc_hd__decap_12 fill_31_62 ();
 sky130_fd_sc_hd__decap_8 fill_31_63 ();
 sky130_fd_sc_hd__decap_3 fill_31_64 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_36 ();
 sky130_fd_sc_hd__decap_12 fill_32_37 ();
 sky130_fd_sc_hd__decap_12 fill_32_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_32_39 ();
 sky130_fd_sc_hd__decap_12 fill_32_40 ();
 sky130_fd_sc_hd__fill_2 fill_32_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_61 ();
 sky130_fd_sc_hd__decap_12 fill_33_62 ();
 sky130_fd_sc_hd__decap_12 fill_33_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_33_64 ();
 sky130_fd_sc_hd__decap_12 fill_33_65 ();
 sky130_fd_sc_hd__fill_2 fill_33_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_36 ();
 sky130_fd_sc_hd__decap_12 fill_34_37 ();
 sky130_fd_sc_hd__decap_12 fill_34_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_34_39 ();
 sky130_fd_sc_hd__decap_12 fill_34_40 ();
 sky130_fd_sc_hd__fill_2 fill_34_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_61 ();
 sky130_fd_sc_hd__decap_12 fill_35_62 ();
 sky130_fd_sc_hd__decap_12 fill_35_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_35_64 ();
 sky130_fd_sc_hd__decap_12 fill_35_65 ();
 sky130_fd_sc_hd__fill_2 fill_35_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_36 ();
 sky130_fd_sc_hd__decap_12 fill_36_37 ();
 sky130_fd_sc_hd__decap_12 fill_36_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_36_39 ();
 sky130_fd_sc_hd__decap_12 fill_36_40 ();
 sky130_fd_sc_hd__fill_2 fill_36_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_61 ();
 sky130_fd_sc_hd__decap_12 fill_37_62 ();
 sky130_fd_sc_hd__decap_12 fill_37_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_37_64 ();
 sky130_fd_sc_hd__decap_12 fill_37_65 ();
 sky130_fd_sc_hd__fill_2 fill_37_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_36 ();
 sky130_fd_sc_hd__decap_12 fill_38_37 ();
 sky130_fd_sc_hd__decap_12 fill_38_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_38_39 ();
 sky130_fd_sc_hd__decap_12 fill_38_40 ();
 sky130_fd_sc_hd__fill_2 fill_38_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_61 ();
 sky130_fd_sc_hd__decap_12 fill_39_62 ();
 sky130_fd_sc_hd__decap_12 fill_39_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_39_64 ();
 sky130_fd_sc_hd__decap_12 fill_39_65 ();
 sky130_fd_sc_hd__fill_2 fill_39_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_36 ();
 sky130_fd_sc_hd__decap_12 fill_40_37 ();
 sky130_fd_sc_hd__decap_12 fill_40_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_40_39 ();
 sky130_fd_sc_hd__decap_12 fill_40_40 ();
 sky130_fd_sc_hd__fill_2 fill_40_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_61 ();
 sky130_fd_sc_hd__decap_12 fill_41_62 ();
 sky130_fd_sc_hd__decap_12 fill_41_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_41_64 ();
 sky130_fd_sc_hd__decap_12 fill_41_65 ();
 sky130_fd_sc_hd__fill_2 fill_41_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_36 ();
 sky130_fd_sc_hd__decap_12 fill_42_37 ();
 sky130_fd_sc_hd__decap_12 fill_42_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_42_39 ();
 sky130_fd_sc_hd__decap_12 fill_42_40 ();
 sky130_fd_sc_hd__fill_2 fill_42_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_61 ();
 sky130_fd_sc_hd__decap_12 fill_43_62 ();
 sky130_fd_sc_hd__decap_12 fill_43_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_43_64 ();
 sky130_fd_sc_hd__decap_12 fill_43_65 ();
 sky130_fd_sc_hd__fill_2 fill_43_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_36 ();
 sky130_fd_sc_hd__decap_12 fill_44_37 ();
 sky130_fd_sc_hd__decap_12 fill_44_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_44_39 ();
 sky130_fd_sc_hd__decap_12 fill_44_40 ();
 sky130_fd_sc_hd__fill_2 fill_44_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_61 ();
 sky130_fd_sc_hd__decap_12 fill_45_62 ();
 sky130_fd_sc_hd__decap_12 fill_45_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_45_64 ();
 sky130_fd_sc_hd__decap_12 fill_45_65 ();
 sky130_fd_sc_hd__fill_2 fill_45_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_36 ();
 sky130_fd_sc_hd__decap_12 fill_46_37 ();
 sky130_fd_sc_hd__decap_12 fill_46_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_46_39 ();
 sky130_fd_sc_hd__decap_12 fill_46_40 ();
 sky130_fd_sc_hd__fill_2 fill_46_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_61 ();
 sky130_fd_sc_hd__decap_12 fill_47_62 ();
 sky130_fd_sc_hd__decap_12 fill_47_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_47_64 ();
 sky130_fd_sc_hd__decap_12 fill_47_65 ();
 sky130_fd_sc_hd__fill_2 fill_47_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_36 ();
 sky130_fd_sc_hd__decap_12 fill_48_37 ();
 sky130_fd_sc_hd__decap_12 fill_48_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_48_39 ();
 sky130_fd_sc_hd__decap_12 fill_48_40 ();
 sky130_fd_sc_hd__fill_2 fill_48_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_61 ();
 sky130_fd_sc_hd__decap_12 fill_49_62 ();
 sky130_fd_sc_hd__decap_12 fill_49_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_49_64 ();
 sky130_fd_sc_hd__decap_12 fill_49_65 ();
 sky130_fd_sc_hd__fill_2 fill_49_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_36 ();
 sky130_fd_sc_hd__decap_12 fill_50_37 ();
 sky130_fd_sc_hd__decap_12 fill_50_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_50_39 ();
 sky130_fd_sc_hd__decap_12 fill_50_40 ();
 sky130_fd_sc_hd__fill_2 fill_50_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_61 ();
 sky130_fd_sc_hd__decap_12 fill_51_62 ();
 sky130_fd_sc_hd__decap_12 fill_51_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_51_64 ();
 sky130_fd_sc_hd__decap_12 fill_51_65 ();
 sky130_fd_sc_hd__fill_2 fill_51_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_36 ();
 sky130_fd_sc_hd__decap_12 fill_52_37 ();
 sky130_fd_sc_hd__decap_12 fill_52_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_52_39 ();
 sky130_fd_sc_hd__decap_12 fill_52_40 ();
 sky130_fd_sc_hd__fill_2 fill_52_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_61 ();
 sky130_fd_sc_hd__decap_12 fill_53_62 ();
 sky130_fd_sc_hd__decap_12 fill_53_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_53_64 ();
 sky130_fd_sc_hd__decap_12 fill_53_65 ();
 sky130_fd_sc_hd__fill_2 fill_53_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_36 ();
 sky130_fd_sc_hd__decap_12 fill_54_37 ();
 sky130_fd_sc_hd__decap_12 fill_54_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_54_39 ();
 sky130_fd_sc_hd__decap_12 fill_54_40 ();
 sky130_fd_sc_hd__fill_2 fill_54_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_61 ();
 sky130_fd_sc_hd__decap_12 fill_55_62 ();
 sky130_fd_sc_hd__decap_12 fill_55_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_55_64 ();
 sky130_fd_sc_hd__decap_12 fill_55_65 ();
 sky130_fd_sc_hd__fill_2 fill_55_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_36 ();
 sky130_fd_sc_hd__decap_12 fill_56_37 ();
 sky130_fd_sc_hd__decap_12 fill_56_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_56_39 ();
 sky130_fd_sc_hd__decap_12 fill_56_40 ();
 sky130_fd_sc_hd__fill_2 fill_56_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_61 ();
 sky130_fd_sc_hd__decap_12 fill_57_62 ();
 sky130_fd_sc_hd__decap_12 fill_57_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_57_64 ();
 sky130_fd_sc_hd__decap_12 fill_57_65 ();
 sky130_fd_sc_hd__fill_2 fill_57_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_36 ();
 sky130_fd_sc_hd__decap_12 fill_58_37 ();
 sky130_fd_sc_hd__decap_12 fill_58_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_58_39 ();
 sky130_fd_sc_hd__decap_12 fill_58_40 ();
 sky130_fd_sc_hd__fill_2 fill_58_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_61 ();
 sky130_fd_sc_hd__decap_12 fill_59_62 ();
 sky130_fd_sc_hd__decap_12 fill_59_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_59_64 ();
 sky130_fd_sc_hd__decap_12 fill_59_65 ();
 sky130_fd_sc_hd__fill_2 fill_59_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_36 ();
 sky130_fd_sc_hd__decap_12 fill_60_37 ();
 sky130_fd_sc_hd__decap_12 fill_60_38 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_60_39 ();
 sky130_fd_sc_hd__decap_12 fill_60_40 ();
 sky130_fd_sc_hd__fill_2 fill_60_41 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_61 ();
 sky130_fd_sc_hd__decap_12 fill_61_62 ();
 sky130_fd_sc_hd__decap_12 fill_61_63 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_61_64 ();
 sky130_fd_sc_hd__decap_12 fill_61_65 ();
 sky130_fd_sc_hd__fill_2 fill_61_66 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_35 ();
 sky130_fd_sc_hd__decap_12 fill_62_36 ();
 sky130_fd_sc_hd__decap_12 fill_62_37 ();
 sky130_fd_sc_hd__tapvpwrvgnd_1 fill_62_38 ();
 sky130_fd_sc_hd__decap_12 fill_62_39 ();
 sky130_fd_sc_hd__fill_2 fill_62_40 ();
 assign DA[0] = \REGF[10].RFW.D1[0] ;
 assign DA[10] = \REGF[10].RFW.D1[10] ;
 assign DA[11] = \REGF[10].RFW.D1[11] ;
 assign DA[12] = \REGF[10].RFW.D1[12] ;
 assign DA[13] = \REGF[10].RFW.D1[13] ;
 assign DA[14] = \REGF[10].RFW.D1[14] ;
 assign DA[15] = \REGF[10].RFW.D1[15] ;
 assign DA[16] = \REGF[10].RFW.D1[16] ;
 assign DA[17] = \REGF[10].RFW.D1[17] ;
 assign DA[18] = \REGF[10].RFW.D1[18] ;
 assign DA[19] = \REGF[10].RFW.D1[19] ;
 assign DA[1] = \REGF[10].RFW.D1[1] ;
 assign DA[20] = \REGF[10].RFW.D1[20] ;
 assign DA[21] = \REGF[10].RFW.D1[21] ;
 assign DA[22] = \REGF[10].RFW.D1[22] ;
 assign DA[23] = \REGF[10].RFW.D1[23] ;
 assign DA[24] = \REGF[10].RFW.D1[24] ;
 assign DA[25] = \REGF[10].RFW.D1[25] ;
 assign DA[26] = \REGF[10].RFW.D1[26] ;
 assign DA[27] = \REGF[10].RFW.D1[27] ;
 assign DA[28] = \REGF[10].RFW.D1[28] ;
 assign DA[29] = \REGF[10].RFW.D1[29] ;
 assign DA[2] = \REGF[10].RFW.D1[2] ;
 assign DA[30] = \REGF[10].RFW.D1[30] ;
 assign DA[31] = \REGF[10].RFW.D1[31] ;
 assign DA[3] = \REGF[10].RFW.D1[3] ;
 assign DA[4] = \REGF[10].RFW.D1[4] ;
 assign DA[5] = \REGF[10].RFW.D1[5] ;
 assign DA[6] = \REGF[10].RFW.D1[6] ;
 assign DA[7] = \REGF[10].RFW.D1[7] ;
 assign DA[8] = \REGF[10].RFW.D1[8] ;
 assign DA[9] = \REGF[10].RFW.D1[9] ;
 assign DB[0] = \REGF[10].RFW.D2[0] ;
 assign DB[10] = \REGF[10].RFW.D2[10] ;
 assign DB[11] = \REGF[10].RFW.D2[11] ;
 assign DB[12] = \REGF[10].RFW.D2[12] ;
 assign DB[13] = \REGF[10].RFW.D2[13] ;
 assign DB[14] = \REGF[10].RFW.D2[14] ;
 assign DB[15] = \REGF[10].RFW.D2[15] ;
 assign DB[16] = \REGF[10].RFW.D2[16] ;
 assign DB[17] = \REGF[10].RFW.D2[17] ;
 assign DB[18] = \REGF[10].RFW.D2[18] ;
 assign DB[19] = \REGF[10].RFW.D2[19] ;
 assign DB[1] = \REGF[10].RFW.D2[1] ;
 assign DB[20] = \REGF[10].RFW.D2[20] ;
 assign DB[21] = \REGF[10].RFW.D2[21] ;
 assign DB[22] = \REGF[10].RFW.D2[22] ;
 assign DB[23] = \REGF[10].RFW.D2[23] ;
 assign DB[24] = \REGF[10].RFW.D2[24] ;
 assign DB[25] = \REGF[10].RFW.D2[25] ;
 assign DB[26] = \REGF[10].RFW.D2[26] ;
 assign DB[27] = \REGF[10].RFW.D2[27] ;
 assign DB[28] = \REGF[10].RFW.D2[28] ;
 assign DB[29] = \REGF[10].RFW.D2[29] ;
 assign DB[2] = \REGF[10].RFW.D2[2] ;
 assign DB[30] = \REGF[10].RFW.D2[30] ;
 assign DB[31] = \REGF[10].RFW.D2[31] ;
 assign DB[3] = \REGF[10].RFW.D2[3] ;
 assign DB[4] = \REGF[10].RFW.D2[4] ;
 assign DB[5] = \REGF[10].RFW.D2[5] ;
 assign DB[6] = \REGF[10].RFW.D2[6] ;
 assign DB[7] = \REGF[10].RFW.D2[7] ;
 assign DB[8] = \REGF[10].RFW.D2[8] ;
 assign DB[9] = \REGF[10].RFW.D2[9] ;
endmodule
