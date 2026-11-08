`timescale 1ns/1ps

module tb_alu_4bit;
    reg  [3:0] a;
    reg  [3:0] b;
    reg  [2:0] alu_sel;
    wire [3:0] result;
    wire       carry_out;
    wire       borrow_out;
    wire       zero;

    integer i;
    integer j;
    integer errors;
    reg [4:0] expected_temp;

    alu_4bit dut (
        .a(a),
        .b(b),
        .alu_sel(alu_sel),
        .result(result),
        .carry_out(carry_out),
        .borrow_out(borrow_out),
        .zero(zero)
    );

    task check_result;
        input [2:0] op;
        input [3:0] operand_a;
        input [3:0] operand_b;
        input [3:0] expected_result;
        input expected_carry;
        input expected_borrow;
        input expected_zero;
        begin
            a = operand_a;
            b = operand_b;
            alu_sel = op;
            #1;

            if ((result !== expected_result) ||
                (carry_out !== expected_carry) ||
                (borrow_out !== expected_borrow) ||
                (zero !== expected_zero)) begin
                $display("FAIL op=%b A=%h B=%h | got R=%h C=%b B=%b Z=%b | expected R=%h C=%b B=%b Z=%b",
                         op, operand_a, operand_b, result, carry_out,
                         borrow_out, zero, expected_result, expected_carry,
                         expected_borrow, expected_zero);
                errors = errors + 1;
            end
        end
    endtask

    initial begin
        $dumpfile("alu.vcd");
        $dumpvars(0, tb_alu_4bit);
        errors = 0;
        a = 0;
        b = 0;
        alu_sel = 0;

        // Exhaustively test all 16 x 16 input combinations.
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                // ADD
                expected_temp = i + j;
                check_result(3'b000, i[3:0], j[3:0],
                             expected_temp[3:0], expected_temp[4], 1'b0,
                             (expected_temp[3:0] == 4'b0000));

                // SUB
                expected_temp = i - j;
                check_result(3'b001, i[3:0], j[3:0],
                             expected_temp[3:0], 1'b0, (i < j),
                             (expected_temp[3:0] == 4'b0000));

                // AND, OR and XOR
                check_result(3'b010, i[3:0], j[3:0], (i & j),
                             1'b0, 1'b0, ((i & j) == 0));
                check_result(3'b011, i[3:0], j[3:0], (i | j),
                             1'b0, 1'b0, ((i | j) == 0));
                check_result(3'b100, i[3:0], j[3:0], (i ^ j),
                             1'b0, 1'b0, ((i ^ j) == 0));

                // NOT A
                check_result(3'b101, i[3:0], j[3:0], (~i),
                             1'b0, 1'b0, ((~i & 4'hF) == 0));
            end
        end

        // Reserved operation codes must return zero with flags cleared.
        check_result(3'b110, 4'hA, 4'h5, 4'h0, 1'b0, 1'b0, 1'b1);
        check_result(3'b111, 4'hF, 4'h1, 4'h0, 1'b0, 1'b0, 1'b1);

        if (errors == 0) begin
            $display("PASS: all ALU tests completed successfully.");
            $finish;
        end else begin
            $fatal(1, "FAIL: %0d test(s) failed.", errors);
        end
    end
endmodule
