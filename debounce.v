module debounce(
    input wire clk,
    input wire btn_in,
    output reg btn_out
);

    reg [3:0] shift_reg;

    always @(posedge clk) begin
        shift_reg <= {shift_reg[2:0], btn_in};
        if (shift_reg == 4'b1111) begin
            btn_out <= 1;
        end else begin
            btn_out <= 0;
        end
    end

endmodule