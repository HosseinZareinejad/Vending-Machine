module admin_mode(
    input wire clk,
    input wire ready,
    input wire [1:0] pass_idx,
    input wire up,
    input wire down,
    input wire confirm,
    output reg admin_mode,
    output reg back_user,
    output reg [6:0] sseg_idx, // 7 bits for slot number
    output reg [3:0] sseg_count // Seven segment display for item count
);

    // Define internal registers
    reg [3:0] item_count_reg [68:0]; // 69 slots
    reg [1:0] admin_pass = 2'b10; // Admin password is '02'
    reg [31:0] timer; // Timer for automatic logout

    // State machine states
    parameter IDLE = 3'b000,
              CHECK_PASS = 3'b001,
              SET_ITEM = 3'b010,
              ADD_ITEM = 3'b011,
              CONFIRM_ITEM = 3'b100;

    reg [2:0] current_state, next_state;

    // Initialize item counts to 9
    initial begin
        item_count_reg[0] = 4'd9;
        item_count_reg[1] = 4'd9;
        item_count_reg[2] = 4'd9;
        item_count_reg[3] = 4'd9;
        item_count_reg[4] = 4'd9;
        item_count_reg[5] = 4'd9;
        item_count_reg[6] = 4'd9;
        item_count_reg[7] = 4'd9;
        item_count_reg[8] = 4'd9;
        item_count_reg[9] = 4'd9;
        item_count_reg[10] = 4'd9;
        item_count_reg[11] = 4'd9;
        item_count_reg[12] = 4'd9;
        item_count_reg[13] = 4'd9;
        item_count_reg[14] = 4'd9;
        item_count_reg[15] = 4'd9;
        item_count_reg[16] = 4'd9;
        item_count_reg[17] = 4'd9;
        item_count_reg[18] = 4'd9;
        item_count_reg[19] = 4'd9;
        item_count_reg[20] = 4'd9;
        item_count_reg[21] = 4'd9;
        item_count_reg[22] = 4'd9;
        item_count_reg[23] = 4'd9;
        item_count_reg[24] = 4'd9;
        item_count_reg[25] = 4'd9;
        item_count_reg[26] = 4'd9;
        item_count_reg[27] = 4'd9;
        item_count_reg[28] = 4'd9;
        item_count_reg[29] = 4'd9;
        item_count_reg[30] = 4'd9;
        item_count_reg[31] = 4'd9;
        item_count_reg[32] = 4'd9;
        item_count_reg[33] = 4'd9;
        item_count_reg[34] = 4'd9;
        item_count_reg[35] = 4'd9;
        item_count_reg[36] = 4'd9;
        item_count_reg[37] = 4'd9;
        item_count_reg[38] = 4'd9;
        item_count_reg[39] = 4'd9;
        item_count_reg[40] = 4'd9;
        item_count_reg[41] = 4'd9;
        item_count_reg[42] = 4'd9;
        item_count_reg[43] = 4'd9;
        item_count_reg[44] = 4'd9;
        item_count_reg[45] = 4'd9;
        item_count_reg[46] = 4'd9;
        item_count_reg[47] = 4'd9;
        item_count_reg[48] = 4'd9;
        item_count_reg[49] = 4'd9;
        item_count_reg[50] = 4'd9;
        item_count_reg[51] = 4'd9;
        item_count_reg[52] = 4'd9;
        item_count_reg[53] = 4'd9;
        item_count_reg[54] = 4'd9;
        item_count_reg[55] = 4'd9;
        item_count_reg[56] = 4'd9;
        item_count_reg[57] = 4'd9;
        item_count_reg[58] = 4'd9;
        item_count_reg[59] = 4'd9;
        item_count_reg[60] = 4'd9;
        item_count_reg[61] = 4'd9;
        item_count_reg[62] = 4'd9;
        item_count_reg[63] = 4'd9;
        item_count_reg[64] = 4'd9;
        item_count_reg[65] = 4'd9;
        item_count_reg[66] = 4'd9;
        item_count_reg[67] = 4'd9;
        item_count_reg[68] = 4'd9;

        admin_mode = 0;
        back_user = 0;
        sseg_idx = 0;
        sseg_count = 0;
        timer = 0;
    end

    // State transition logic
    always @(posedge clk) begin
        current_state <= next_state;
        if (admin_mode) timer <= timer + 1;
        if (timer >= 32'd2400000) begin // 1 minute at 40 MHz
            next_state <= IDLE;
            back_user <= 1;
            admin_mode <= 0;
        end
    end

    // Next state logic
    always @(posedge clk) begin
        next_state = current_state; // Prevent latches
        case (current_state)
            IDLE: begin
                if (ready) next_state = CHECK_PASS;
            end
            CHECK_PASS: begin
                if (pass_idx == admin_pass) next_state = SET_ITEM;
            end
            SET_ITEM: begin
                if (confirm) next_state = ADD_ITEM;
            end
            ADD_ITEM: begin
                if (confirm) next_state = CONFIRM_ITEM;
            end
            CONFIRM_ITEM: begin
                next_state = IDLE;
            end
        endcase
    end

    // Output logic and state actions
    always @(posedge clk) begin
        case (current_state)
            IDLE: begin
                admin_mode <= 0;
                back_user <= 0;
                sseg_idx <= 0;
                sseg_count <= 0;
            end
            CHECK_PASS: begin
                if (pass_idx == admin_pass) admin_mode <= 1;
            end
            SET_ITEM: begin
                sseg_count <= item_count_reg[sseg_idx];
            end
            ADD_ITEM: begin
                if (up && sseg_count < 4'd9) sseg_count <= sseg_count + 1;
                if (down && sseg_count > 4'd0) sseg_count <= sseg_count - 1;
            end
            CONFIRM_ITEM: begin
                item_count_reg[sseg_idx] <= sseg_count;
            end
        endcase
    end

endmodule