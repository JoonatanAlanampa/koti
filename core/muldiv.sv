// muldiv.sv — RV32M iterative multiply/divide, one bit per cycle.
// funct3: 000 MUL    low 32 of a*b (sign-agnostic in the low word)
//         001 MULH   high 32, signed x signed
//         010 MULHSU high 32, signed x unsigned
//         011 MULHU  high 32, unsigned x unsigned
//         100 DIV    101 DIVU    110 REM    111 REMU
// Both loops run on absolute values with a sign fixup at the end
// (|INT_MIN| is its own two's complement, which works out unsigned).
// Divide-by-zero and INT_MIN/-1 are resolved at accept per spec and
// skip the loop. CPI is memory-dominated on this chip; 32 cycles here
// costs nothing that matters — area does (PLAN.md).
//
// Handshake: hold `start` with stable a/b/funct3; operands latch when
// the unit is free, `busy` covers the 32 iterations, then `done` rises
// (sticky) with `result` until `ack`.
module muldiv (
    input  logic        clk, rst,
    input  logic        start, ack,
    input  logic [2:0]  funct3,
    input  logic [31:0] a, b,
    output logic [31:0] result,
    output logic        busy, done
);
    logic [2:0]  f3;
    logic        is_div;
    logic        neg_p, neg_q, neg_r;   // negate product / quotient / rem
    logic [31:0] den;                   // |multiplicand| or |divisor|
    logic [63:0] acc;                   // mul: {partial, multiplier}
                                        // div: {remainder, quotient}
    logic [5:0]  cnt;

    // operand conditioning at accept
    wire sgn_div = !funct3[0];                       // DIV/REM vs U forms
    wire sgn_a   = funct3[2] ? sgn_div : (funct3 != 3'b011);
    wire sgn_b   = funct3[2] ? sgn_div : !funct3[1]; // MUL/MULH only
    wire [31:0] ua = (sgn_a && a[31]) ? -a : a;
    wire [31:0] ub = (sgn_b && b[31]) ? -b : b;
    wire div_zero = funct3[2] && (b == 32'd0);
    wire div_ovfl = funct3[2] && sgn_div
                 && (a == 32'h8000_0000) && (b == 32'hFFFF_FFFF);

    // one iteration
    wire [32:0] madd = {1'b0, acc[63:32]} + (acc[0] ? {1'b0, den} : 33'd0);
    wire [32:0] t    = {acc[63:32], acc[31]};        // rem shifted left
    wire        ge   = (t >= {1'b0, den});
    wire [32:0] diff = t - {1'b0, den};
    wire [63:0] acc_mul = {madd, acc[31:1]};
    wire [63:0] acc_div = ge ? {diff[31:0], acc[30:0], 1'b1}
                             : {t[31:0],    acc[30:0], 1'b0};

    // completion fixup
    wire [63:0] prod = neg_p ? -acc : acc;
    wire [31:0] quo  = neg_q ? -acc[31:0]  : acc[31:0];
    wire [31:0] rem  = neg_r ? -acc[63:32] : acc[63:32];
    wire [31:0] fin  = is_div ? (f3[1] ? rem : quo)
                     : (f3 == 3'b000) ? prod[31:0] : prod[63:32];

    always_ff @(posedge clk)
        if (rst) begin
            busy <= 1'b0; done <= 1'b0;
        end else if (!busy && !done) begin
            if (start) begin
                f3     <= funct3;
                is_div <= funct3[2];
                busy   <= 1'b1;
                if (div_zero) begin                  // q = ~0, r = a
                    acc <= {a, 32'hFFFF_FFFF};
                    {neg_p, neg_q, neg_r} <= 3'b000;
                    cnt <= 6'd0;
                end else if (div_ovfl) begin         // q = INT_MIN, r = 0
                    acc <= {32'd0, 32'h8000_0000};
                    {neg_p, neg_q, neg_r} <= 3'b000;
                    cnt <= 6'd0;
                end else begin
                    acc   <= {32'd0, ua};
                    den   <= ub;
                    neg_p <= (sgn_a && a[31]) ^ (sgn_b && b[31]);
                    neg_q <= (sgn_div && a[31]) ^ (sgn_div && b[31]);
                    neg_r <= sgn_div && a[31];
                    cnt   <= 6'd32;
                end
            end
        end else if (busy) begin
            if (cnt == 6'd0) begin
                busy   <= 1'b0;
                done   <= 1'b1;
                result <= fin;
            end else begin
                acc <= is_div ? acc_div : acc_mul;
                cnt <= cnt - 6'd1;
            end
        end else if (ack)
            done <= 1'b0;
endmodule
