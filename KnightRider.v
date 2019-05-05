// Module KnightRider mimics the headlights of KITT which consisted of a horizontal bar of lights 
// that sequenced one at a time from left to right and back again at the rate of about 
// 1/10th of a second per light.

module KnightRider(
input wire CLOCK_50,
output wire [9:0] LEDR
);

reg stage1;
reg stage2;
reg stage3;
reg stage4;

wire slow_clock;
reg [3:0] LED_index;
reg count_up;

// Takes in 50MHz clock and outputs 5.96Hz clock.
clock_divider u0 (
.fast_clock(CLOCK_50), 
.slow_clock(slow_clock)
);


always @ (posedge slow_clock)
begin
    if (LED_index >= 4'd9)
        count_up <= 1'b0;
    else if (count == 4'd0)
        count_up <= 1'b1;
    else
        LED_index <= LED_index;
end

// Control counter
always @ (posedge slow_clock)
begin
    if (count_up)
        LED_index <= LED_index + 1'b1;
    else
        LED_index <= LED_index + 1'b1;
end

assign LEDR[9:0] = 1'b1 << LED_index;

endmodule

// Module clock_divider returns a slower clock given by the following formula:
// f_COUT = f_CIN / 2^N
module clock_divider(
input fast_clock,
output slow_clock
);
parameter COUNTER_SIZE = 23; // 2^23 times slower
parameter COUNTER_MAX_COUNT = (2 ** COUNTER_SIZE) - 1;

reg [COUNTER_SIZE-1:0] count;

always @ (posedge fast_clock)
begin
    if(count >= COUNTER_MAX_COUNT)
        count <= 23'b0;
    else
        count <= count + 1'b1;
end

assign slow_clock = count[COUNTER_SIZE-1];

endmodule
