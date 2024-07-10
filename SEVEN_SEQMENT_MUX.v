module SEVEN_SEGMENT_MUX(
    input wire clk,
    input wire [3:0] digit1,
    input wire [3:0] digit2,
    input wire [3:0] digit3,
    input wire [3:0] digit4,
    output reg [3:0] segment_selection, // Corrected to 4 bits
    output wire [7:0] segment_data
);
    reg [1:0] current_digit;
    reg [19:0] counter;
    reg [3:0] number;

    always @(posedge clk) begin
        if (counter == 20'd40000) begin // 1ms delay
            current_digit <= current_digit + 1;
            counter <= 0;
        end else begin
            counter <= counter + 1;
        end
    end

    always @(current_digit) begin
        case (current_digit)
            2'd0: begin
                segment_selection <= 4'b0001; // Changed to 4 bits
                number <= digit1;
            end
            2'd1: begin
                segment_selection <= 4'b0010; // Changed to 4 bits
                number <= digit2;
            end
            2'd2: begin
                segment_selection <= 4'b0100; // Changed to 4 bits
                number <= digit3;
            end
            2'd3: begin
                segment_selection <= 4'b1000; // Changed to 4 bits
                number <= digit4;
            end
        endcase
    end

    // Instantiate BCD to seven-segment converter
    BCD2SEVEN_SEGMENT bcd2seven_segment (
        .number(number),
        .segment_data(segment_data)
    );

endmodule