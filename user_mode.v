module user_mode(
    input wire clk,
    input wire [1:0] choose_user,
    input wire [1:0] user_id,
    input wire [6:0] location,
    input wire confirm,
    input wire cancel,
    output reg user_mode,
    output reg [15:0] remaining_balance,  // 16-bit output
    output reg process_finish,
    output reg invalid_user_id
);

    // Define internal registers
    reg [15:0] user_balance_reg [2:0]; // 16-bit balance for 3 users
    reg [3:0] item_count_reg [68:0]; // 69 slots for items
    reg [15:0] item_price_reg [68:0]; // 16-bit prices for 69 items
    reg [1:0] current_user; // Current user index

    // Initial block to initialize values at the beginning
    initial begin
        // Initialize user balances
        user_balance_reg[0] = 16'd7000; // User 1: 7000 
        user_balance_reg[1] = 16'd5000; // User 2: 5000 
        user_balance_reg[2] = 16'd3000; // User 3: 3000 

        // Initialize item counts
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

        // Initialize item prices
        item_price_reg[0] = 16'd0; // Location 0 (not used)
        item_price_reg[1] = 16'd0; // Location 1 (not used)
        item_price_reg[2] = 16'd0; // Location 2 (not used)
        item_price_reg[3] = 16'd0; // Location 3 (not used)
        item_price_reg[4] = 16'd0; // Location 4 (not used)
        item_price_reg[5] = 16'd0; // Location 5 (not used)
        item_price_reg[6] = 16'd0; // Location 6 (not used)
        item_price_reg[7] = 16'd0; // Location 7 (not used)
        item_price_reg[8] = 16'd0; // Location 8 (not used)
        item_price_reg[9] = 16'd0; // Location 9 (not used)
        item_price_reg[10] = 16'd0; // Location 10 (not used)
        item_price_reg[11] = 16'd8500; // Location 11: 8500
        item_price_reg[12] = 16'd8500; // Location 12: 8500
        item_price_reg[13] = 16'd8500; // Location 13: 8500
        item_price_reg[14] = 16'd8500; // Location 14: 8500
        item_price_reg[15] = 16'd8500; // Location 15: 8500
        item_price_reg[16] = 16'd8500; // Location 16: 8500
        item_price_reg[17] = 16'd8500; // Location 17: 8500
        item_price_reg[18] = 16'd8500; // Location 18: 8500
        item_price_reg[19] = 16'd8500; // Location 19: 8500
        item_price_reg[20] = 16'd6000; // Location 20: 6000
        item_price_reg[21] = 16'd6000; // Location 21: 6000
        item_price_reg[22] = 16'd6000; // Location 22: 6000
        item_price_reg[23] = 16'd6000; // Location 23: 6000
        item_price_reg[24] = 16'd6000; // Location 24: 6000
        item_price_reg[25] = 16'd6000; // Location 25: 6000
        item_price_reg[26] = 16'd6000; // Location 26: 6000
        item_price_reg[27] = 16'd6000; // Location 27: 6000
        item_price_reg[28] = 16'd6000; // Location 28: 6000
        item_price_reg[29] = 16'd6000; // Location 29: 6000
        item_price_reg[30] = 16'd4500; // Location 30: 4500
        item_price_reg[31] = 16'd4500; // Location 31: 4500
        item_price_reg[32] = 16'd4500; // Location 32: 4500
        item_price_reg[33] = 16'd4500; // Location 33: 4500
        item_price_reg[34] = 16'd4500; // Location 34: 4500
        item_price_reg[35] = 16'd4500; // Location 35: 4500
        item_price_reg[36] = 16'd4500; // Location 36: 4500
        item_price_reg[37] = 16'd4500; // Location 37: 4500
        item_price_reg[38] = 16'd4500; // Location 38: 4500
        item_price_reg[39] = 16'd4500; // Location 39: 4500
        item_price_reg[40] = 16'd3000; // Location 40: 3000
        item_price_reg[41] = 16'd3000; // Location 41: 3000
        item_price_reg[42] = 16'd3000; // Location 42: 3000
        item_price_reg[43] = 16'd3000; // Location 43: 3000
        item_price_reg[44] = 16'd3000; // Location 44: 3000
        item_price_reg[45] = 16'd3000; // Location 45: 3000
        item_price_reg[46] = 16'd3000; // Location 46: 3000
        item_price_reg[47] = 16'd3000; // Location 47: 3000
        item_price_reg[48] = 16'd3000; // Location 48: 3000
        item_price_reg[49] = 16'd3000; // Location 49: 3000
        item_price_reg[50] = 16'd2000; // Location 50: 2000
        item_price_reg[51] = 16'd2000; // Location 51: 2000
        item_price_reg[52] = 16'd2000; // Location 52: 2000
        item_price_reg[53] = 16'd2000; // Location 53: 2000
        item_price_reg[54] = 16'd2000; // Location 54: 2000
        item_price_reg[55] = 16'd2000; // Location 55: 2000
        item_price_reg[56] = 16'd2000; // Location 56: 2000
        item_price_reg[57] = 16'd2000; // Location 57: 2000
        item_price_reg[58] = 16'd2000; // Location 58: 2000
        item_price_reg[59] = 16'd2000; // Location 59: 2000
        item_price_reg[60] = 16'd2000; // Location 60: 2000
        item_price_reg[61] = 16'd2000; // Location 61: 2000
        item_price_reg[62] = 16'd2000; // Location 62: 2000
        item_price_reg[63] = 16'd2000; // Location 63: 2000
        item_price_reg[64] = 16'd2000; // Location 64: 2000
        item_price_reg[65] = 16'd2000; // Location 65: 2000
        item_price_reg[66] = 16'd2000; // Location 66: 2000
        item_price_reg[67] = 16'd2000; // Location 67: 2000
        item_price_reg[68] = 16'd2000; // Location 68: 2000

        // Initialize other variables
        current_user = 0;
        user_mode = 0;
        remaining_balance = 0;
        process_finish = 0;
        invalid_user_id = 0;
    end

    // Main logic
    always @(posedge clk) begin
        // Choosing User
        case (choose_user)
            2'b00: begin // User 1
                current_user <= 0;
                remaining_balance <= user_balance_reg[0];
            end
            2'b01: begin // User 2
                current_user <= 1;
                remaining_balance <= user_balance_reg[1];
            end
            2'b10: begin // User 3
                current_user <= 2;
                remaining_balance <= user_balance_reg[2];
            end
            default: begin
                invalid_user_id <= 1;
            end
        endcase

        // Transaction Processing
        if (confirm && item_count_reg[location] > 0 && user_balance_reg[current_user] >= item_price_reg[location]) begin
            user_balance_reg[current_user] <= user_balance_reg[current_user] - item_price_reg[location];
            item_count_reg[location] <= item_count_reg[location] - 1;
            remaining_balance <= user_balance_reg[current_user];
            process_finish <= 1;
        end else if (cancel) begin
            process_finish <= 1;
        end else begin
            process_finish <= 0;
        end

        // Display current balance after each transaction
        $display("Current User Balance: %d", user_balance_reg[current_user]);
    end

    // Invalid user ID logic
    always @(posedge clk) begin
        if (user_id > 2'b10) begin
            invalid_user_id <= 1;
        end else begin
            invalid_user_id <= 0;
        end
    end

endmodule