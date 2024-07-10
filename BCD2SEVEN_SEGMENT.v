module BCD2SEVEN_SEGMENT (
    input [3:0] number,
    output reg [7:0] segment_data
);

    // BCD to seven-segment encoding
    always @(number) begin
        case (number)
            4'd0: segment_data = 8'b11000000; // 0
            4'd1: segment_data = 8'b11111001; // 1
            4'd2: segment_data = 8'b10100100; // 2
            4'd3: segment_data = 8'b10110000; // 3
            4'd4: segment_data = 8'b10011001; // 4
            4'd5: segment_data = 8'b10010010; // 5
            4'd6: segment_data = 8'b10000010; // 6
            4'd7: segment_data = 8'b11111000; // 7
            4'd8: segment_data = 8'b10000000; // 8
            4'd9: segment_data = 8'b10010000; // 9
            default: segment_data = 8'b11111111; // Blank or error
        endcase
    end

endmodule