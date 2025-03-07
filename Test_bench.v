module TB_Adder();
    reg [31:0] test32_in1;
    reg [31:0] test32_in2;
    reg test32_cin, test_clk;
    wire [31:0] test32_sum;
    wire test32_cout;

    Adder dut32(.TClk(test_clk), .ra(test32_in1), .rb(test32_in2), .cin(test32_cin), .Sum(test32_sum), .Cout(test32_cout));

    initial begin
        test_clk = 0;
        forever #5 test_clk = ~test_clk; // Toggle clock every 5 time units
    end

    initial begin
        repeat (1000) begin
            test32_in1 = $random;
            test32_in2 = $random;
            test32_cin = $random % 2;
            @(posedge test_clk);
            #100; // Wait for result
        end
        #1000 $finish;
    end

    initial begin
        $monitor($time, " IN1: %b, IN2: %b, CIN: %b, SUM: %b, COUT: %b", test32_in1, test32_in2, test32_cin, test32_sum, test32_cout);
        $dumpfile("fulladderN.vcd");
        $dumpvars(0, TB_Adder);
    end
endmodule
