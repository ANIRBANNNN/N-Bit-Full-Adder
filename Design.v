module Full_Adder(in1, in2, cin, Sum, cout);
    input in1, in2, cin;
    output Sum, cout;
    wire i_sum;
    wire i_carry1, i_carry2, i_carry3;

    assign #2 i_sum = in1 ^ in2;
    assign #1 i_carry1 = in1 & in2;
    assign #1 i_carry2 = in1 & cin;
    assign #1 i_carry3 = in2 & cin;
    assign #2 cout = i_carry1 | i_carry2 | i_carry3;
    assign #4 Sum = i_sum ^ cin;
endmodule

module Full_Adder_N(ra, rb, cin, Sum, Cout);
    input [7:0] ra;
    input [7:0] rb;
    input cin;
    output [7:0] Sum;
    output Cout;
    wire [8:0] Cinter;
    
    assign Cinter[0] = cin;

    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin
            Full_Adder fa_inst(.in1(ra[i]), .in2(rb[i]), .cin(Cinter[i]), .Sum(Sum[i]), .cout(Cinter[i + 1]));
        end
    endgenerate

    assign Cout = Cinter[8];
endmodule

module Adder(TClk, ra, rb, cin, Sum, Cout);
    input [31:0] ra;
    input [31:0] rb;
    input cin, TClk;
    output [31:0] Sum;
    output Cout;
    
    wire [3:0] c;
    wire [31:0] partial_sum;
    wire [3:0] carry_out;

    // Instantiate 4 Full_Adder_N for each byte
    Full_Adder_N fa_inst0(.ra(ra[7:0]),   .rb(rb[7:0]),   .cin(cin), .Sum(partial_sum[7:0]),   .Cout(c[0]));
    Full_Adder_N fa_inst1(.ra(ra[15:8]),  .rb(rb[15:8]),  .cin(c[0]), .Sum(partial_sum[15:8]),  .Cout(c[1]));
    Full_Adder_N fa_inst2(.ra(ra[23:16]), .rb(rb[23:16]), .cin(c[1]), .Sum(partial_sum[23:16]), .Cout(c[2]));
    Full_Adder_N fa_inst3(.ra(ra[31:24]), .rb(rb[31:24]), .cin(c[2]), .Sum(partial_sum[31:24]), .Cout(c[3]));

    reg [31:0] Sum_reg;
    reg Cout_reg;

    always @(posedge TClk) begin
        Sum_reg <= partial_sum;
        Cout_reg <= c[3];
    end

    assign Sum = Sum_reg;
    assign Cout = Cout_reg;
endmodule
