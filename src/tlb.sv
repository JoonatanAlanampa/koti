// tlb.sv — tiny fully-associative sv32 TLB (flop entries, round-robin
// replacement). Uniform 4 KB granularity: megapages fill as the
// specific 4 KB entry they resolved to. Entries carry a FAULT bit so
// invalid/misaligned/A=0 walk results cache as guaranteed page faults
// until the next sfence.vma (the OS always sfences after fixing PTEs).
// Permission bits are checked by the client each lookup — privilege
// and SUM/MXR are dynamic, the entry is not.
module tlb #(
    parameter N = 4
) (
    input  logic        clk, rst, flush,

    input  logic [19:0] vpn,
    output logic        hit,
    output logic [21:0] ppn,
    output logic        p_r, p_w, p_x, p_u, p_d, p_fault,

    input  logic        fill,
    input  logic [19:0] f_vpn,
    input  logic [21:0] f_ppn,
    input  logic        f_r, f_w, f_x, f_u, f_d, f_fault
);
    logic [N-1:0]         valid;
    logic [19:0]          e_vpn [N];
    logic [21:0]          e_ppn [N];
    logic [N-1:0]         e_r, e_w, e_x, e_u, e_d, e_f;
    logic [$clog2(N)-1:0] rr;

    always_comb begin
        hit = 1'b0; ppn = '0;
        p_r = 1'b0; p_w = 1'b0; p_x = 1'b0; p_u = 1'b0;
        p_d = 1'b0; p_fault = 1'b0;
        for (int i = 0; i < N; i++)
            if (valid[i] && e_vpn[i] == vpn) begin
                hit = 1'b1; ppn = e_ppn[i];
                p_r = e_r[i]; p_w = e_w[i]; p_x = e_x[i];
                p_u = e_u[i]; p_d = e_d[i]; p_fault = e_f[i];
            end
    end

    always_ff @(posedge clk)
        if (rst || flush) begin
            valid <= '0; rr <= '0;
        end else if (fill) begin
            valid[rr] <= 1'b1;
            e_vpn[rr] <= f_vpn; e_ppn[rr] <= f_ppn;
            e_r[rr] <= f_r; e_w[rr] <= f_w; e_x[rr] <= f_x;
            e_u[rr] <= f_u; e_d[rr] <= f_d; e_f[rr] <= f_fault;
            rr <= rr + 1'b1;
        end
endmodule
