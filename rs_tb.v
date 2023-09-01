`timescale 1ns / 1ns
module rs_tb;

reg sia;
reg sib;
reg sw;
reg clk;
wire clk_game;

rotation_sensor uut(
.sia(sia),
.sib(sib),
.sw(sw),
.clk(clk),
.clk_game(clk_game)
);

initial
begin
clk=0; //maxhz=2;
forever
begin
#2 clk=1;
#2 clk=0;
end
end

//模拟时钟为实际倍数的1000000分之一
initial
begin

sia=0;sib=0;sw=1;

#20;sia=1;
#10;sib=1;
#40;sia=0;
#10;sib=0;
#400;

#20;sia=1;
#10;sib=1;
#40;sia=0;
#10;sib=0;
#400;

#20;sia=1;
#10;sib=1;
#40;sia=0;
#10;sib=0;
#400;

#20;sia=1;
#10;sib=1;
#40;sia=0;
#10;sib=0;
#400;

#20;sib=1;
#10;sia=1;
#40;sib=0;
#10;sia=0;
#400;

sw=0;
#400;
sw=1;


end



endmodule
