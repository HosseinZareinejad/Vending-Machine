module freqDivider(
    input wire clk_in,      // 40 MHz clock input
    output reg clk_out_1Hz, // 1 Hz clock output
    output reg clk_out_2Hz  // 2 Hz clock output
);
    reg [25:0] counter_1Hz = 0;
    reg [24:0] counter_2Hz = 0;

    always @ (posedge clk_in) begin
        // For 1 Hz clock
        if (counter_1Hz == 20000000 - 1) begin
            counter_1Hz <= 0;
            clk_out_1Hz <= ~clk_out_1Hz;
        end else begin
            counter_1Hz <= counter_1Hz + 1;
        end

        // For 2 Hz clock
        if (counter_2Hz == 10000000 - 1) begin
            counter_2Hz <= 0;
            clk_out_2Hz <= ~clk_out_2Hz;
        end else begin
            counter_2Hz <= counter_2Hz + 1;
        end
    end
endmodule