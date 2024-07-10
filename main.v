module main(
    input wire clk,               // 40 MHz clock
    input wire reset,
    input wire [1:0] user_id,
    input wire [6:0] item_id,
    input wire confirm,
    input wire admin_mode_switch,
    input wire [1:0] admin_pass,
    input wire btn_up,            // Raw up button input
    input wire btn_down,          // Raw down button input
    input wire admin_confirm,
    output wire [15:0] user_balance,
    output wire [3:0] item_count,
    output wire purchase_successful,
    output wire admin_mode_led,
    output wire user_mode_led,
    output wire [3:0] seg_sel,    // Corrected to 4 bits
    output wire [7:0] seg_data
);

    // Define internal wires and registers
    wire admin_mode;
    wire back_user;
    wire [6:0] sseg_idx;
    wire [3:0] sseg_count;
    wire proc_finish;
    wire pass_invalid;
    reg user_mode_reg;  // Internal register for user mode
    wire debounced_up;        // Debounced up button signal
    wire debounced_down;      // Debounced down button signal
    wire clk_1Hz;             // 1 Hz clock
    wire clk_2Hz;             // 2 Hz clock

    // Instantiate frequency divider
    freqDivider freq_div (
        .clk_in(clk),
        .clk_out_1Hz(clk_1Hz),
        .clk_out_2Hz(clk_2Hz)
    );

    // Instantiate debounce modules for up and down buttons
    debounce db_up (
        .clk(clk),
        .btn_in(btn_up),
        .btn_out(debounced_up)
    );

    debounce db_down (
        .clk(clk),
        .btn_in(btn_down),
        .btn_out(debounced_down)
    );

    // Instantiate user_mode module
    user_mode u_mode (
        .clk(clk),
        .choose_user(user_id),
        .user_id(user_id),
        .location(item_id),
        .confirm(confirm),
        .cancel(1'b0), // Cancel input fixed to 0 for simplicity
        .user_mode(), // Removed direct assignment to user_mode_led
        .remaining_balance(user_balance),
        .process_finish(proc_finish),
        .invalid_user_id(pass_invalid)
    );

    // Instantiate admin_mode module
    admin_mode a_mode (
        .clk(clk),
        .ready(admin_mode_switch),
        .pass_idx(admin_pass),
        .up(debounced_up),
        .down(debounced_down),
        .confirm(admin_confirm),
        .admin_mode(admin_mode),
        .back_user(back_user),
        .sseg_idx(sseg_idx),
        .sseg_count(sseg_count)
    );

    // Instantiate seven segment multiplexer module
    SEVEN_SEGMENT_MUX seg_mux (
        .clk(clk_1Hz), // Use 1 Hz clock for display
        .digit1(sseg_idx[6:4]),
        .digit2(sseg_idx[3:0]),
        .digit3(sseg_count),
        .digit4(4'b1111), // Blank digit for simplicity
        .segment_selection(seg_sel),
        .segment_data(seg_data)
    );

    // Control logic for user_mode and admin_mode
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            user_mode_reg <= 1'b0;
        end else begin
            if (admin_mode_switch) begin
                user_mode_reg <= 1'b1; // User mode
            end else begin
                user_mode_reg <= 1'b0; // Admin mode
            end
        end
    end

    // Output assignments
    assign admin_mode_led = ~user_mode_reg; // Invert user_mode_reg for admin_mode_led 
    assign user_mode_led = user_mode_reg;
    assign item_count = sseg_count;
    assign purchase_successful = proc_finish;

endmodule
