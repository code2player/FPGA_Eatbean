`timescale 1ns / 1ns
module snake_tb;

reg clk;
reg clrn;
reg rst;
reg game_start_end;
reg turn_up;
reg turn_down;
reg turn_left;
reg turn_right;

reg sia;
reg sib;
reg sw;

wire hs;
wire vs;
wire [3:0]vga_r;
wire [3:0]vga_g;
wire [3:0]vga_b;

wire [6:0]led;

snake uut(
.clk(clk),
.clrn(clrn),
.rst(rst),
.game_start_end(game_start_end),
.turn_up(turn_up),
.turn_down(turn_down),
.turn_left(turn_left),
.turn_right(turn_right),
.sia(sia),
.sib(sib),
.sw(sw),
.hs(hs),
.vs(vs),
.vga_r(vga_r),
.vga_g(vga_g),
.vga_b(vga_b),
.led(led)
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




initial
begin
clrn=0;rst=1;game_start_end=1;turn_up=1;turn_down=0;turn_left=0;turn_right=0;
sia=0;sib=0;sw=1;
#100;
clrn=1;
end

initial
begin






end








endmodule
