`timescale 1ns/1ps

// Beginner-friendly 4-bit combinational ALU.
// Supported operations are selected using alu_sel.
module alu_4bit (
    input  wire [3:0] a,
    input  wire [3:0] b,
    input  wire [2:0] alu_sel,
    output reg  [3:0] result,
    output reg        carry_out,
    output reg        borrow_out,
    output wire       zero
);

    reg [4:0] temp;

    always @(*) begin
        // Default values prevent unintended latch inference.
        result    = 4'b0000;
        carry_out = 1'b0;
        borrow_out = 1'b0;
        temp      = 5'b00000;

        case (alu_sel)
            3'b000: begin // Addition: A + B
                temp      = {1'b0, a} + {1'b0, b};
                result    = temp[3:0];
                carry_out = temp[4];
            end

            3'b001: begin // Subtraction: A - B
                temp       = {1'b0, a} - {1'b0, b};
                result     = temp[3:0];
                borrow_out = (a < b);
            end

            3'b010: result = a & b; // Bitwise AND
            3'b011: result = a | b; // Bitwise OR
            3'b100: result = a ^ b; // Bitwise XOR
            3'b101: result = ~a;    // Bitwise NOT of A

            default: result = 4'b0000; // 110 and 111 are reserved
        endcase
    end

    assign zero = (result == 4'b0000);

endmodule
