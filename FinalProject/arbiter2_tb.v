//Daniel Browne
//EECE 573 Final Project Testbench
//Test arbiter2 module

`define TEST 42'b000101111101100000101011110001001100100011
`define RESULTS 42'b000101101001100000101001010001001000100001

module arbiter2_tb();

    //Input and Output Test Vectors

    reg clk, reset, ra_tv, rb_tv;
    wire Ga_ov, Gb_ov;
    wire [1:0] out;

    reg [41:0] test;
    reg [41:0] results;

    assign out = {Ga_ov, Gb_ov};

    //Instantiate Unit Under Test
    arbiter2 UUT (
        .ra(ra_tv),
        .rb(rb_tv),
        .clk(clk),
        .reset(reset),
        .Ga(Ga_ov),
        .Gb(Gb_ov)
    );

    initial begin
        $timeformat(-9, 2, " ns", 20);
    end

    initial begin
        clk = 0;
        test = `TEST;
        results = `RESULTS;
    end

    always begin
        #5 clk = ~clk;
    end

    initial begin: maintestbench
        integer ra_val, rb_val, i, error_exists, io;
        ra_val = 0;
        rb_val = 0;
        $display("Daniel Browne EECE573");
        $display("Testing all state transitions.");
        reset = 1'b1;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, io[3:2], UUT.state, UUT.next_state, out);
        #6;
        reset = 1'b0;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, io[3:2], UUT.state, UUT.next_state, out);

        for(i=1; i<=21; i=i+1)begin
            case (i[5:0])
                6'd1: io = {test[41:40],results[41:40]};
                6'd2: io = {test[39:38],results[39:38]};
                6'd3: io = {test[37:36],results[37:36]};
                6'd4: io = {test[35:34],results[35:34]};
                6'd5: io = {test[33:32],results[33:32]};
                6'd6: io = {test[31:30],results[31:30]};
                6'd7: io = {test[29:28],results[29:28]};
                6'd8: io = {test[27:26],results[27:26]};
                6'd9: io = {test[25:24],results[25:24]};
                6'd10: io = {test[23:22],results[23:22]};
                6'd11: io = {test[21:20],results[21:20]};
                6'd12: io = {test[19:18],results[19:18]};
                6'd13: io = {test[17:16],results[17:16]};
                6'd14: io = {test[15:14],results[15:14]};
                6'd15: io = {test[13:12],results[13:12]};
                6'd16: io = {test[11:10],results[11:10]};
                6'd17: io = {test[9:8],results[9:8]};
                6'd18: io = {test[7:6],results[7:6]};
                6'd19: io = {test[5:4],results[5:4]};
                6'd20: io = {test[3:2],results[3:2]};
                default: io = {test[1:0],results[1:0]};
            endcase
            ra_tv=io[3];
            rb_tv=io[2];
            #5;
            $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, io[3:2], UUT.state, UUT.next_state, out);
            #5;
            if(out[0] === 1'bx || out[1] === 1'bx) begin   
                $display("fail: Output undefined."); 
                $finish;
            end
            if (io[1:0] !== {Ga_ov,Gb_ov}) begin
                $display("fail: Incorrect output detected. Expected: %2b, Actual %2b", io[1:0], out);
                $finish;
            end
        end

        $display("Testing Reset");

        ra_tv=1'b1;
        rb_tv=1'b1;
        #5
        reset = 1'b1;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, 2'b11, UUT.state, UUT.next_state, out);
        #5;
        reset = 1'b0;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, 2'b11, UUT.state, UUT.next_state, out);
        if (out !== 2'b00) begin
            $display("fail: Synchronous reset appears to fail.");
            $finish;
        end
        #5;
        ra_tv=1'b0;
        rb_tv=1'b1;
        #5;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, 2'b01, UUT.state, UUT.next_state, out);
        #5;
        ra_tv=1'b1;
        rb_tv=1'b0;
        #10;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, 2'b10, UUT.state, UUT.next_state, out);
        #1;
        reset = 1'b1;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, 2'b10, UUT.state, UUT.next_state, out);
        #1;
        reset = 1'b0;
        $display("Time: %3d, Reset: %1d, Input: %2b, State: %1d, Next State: %1d, Output: %2b",$time ,reset, 2'b10, UUT.state, UUT.next_state, out);
        if (out === 2'b00) begin
            $display("fail: Circuit resets asynchronously.");
            $finish;
        end

        $display("pass");
        $finish;
    end
endmodule