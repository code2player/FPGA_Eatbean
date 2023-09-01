`timescale 1ns / 1ns
module Divider_tb;

reg i_clk;
reg rst;
wire o_clk;

Divider uut(
.I_CLK(i_clk),
.rst(rst),
.O_CLK(o_clk)
);

initial
begin
i_clk=0; rst=0;
forever
begin
#5 i_clk=1;
#5 i_clk=0;
end
end



endmodule
