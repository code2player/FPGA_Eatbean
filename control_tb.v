`timescale 1ns / 1ns
module control_tb;

reg clk2;
reg rst_n;
reg game_start_end;

reg [1:0] head;

wire menu;
wire first_do;
wire go_one_step;
wire eat_apple;
wire random_growth;
wire null_out;
wire game_over;

control uut(
.clk2(clk2),
.rst_n(rst_n),
.game_start_end(game_start_end),
.head(head),
.menu(menu),
.first_do(first_do),
.go_one_step(go_one_step),
.eat_apple(eat_apple),
.random_growth(random_growth),
.null_out(null_out),
.game_over(game_over)
);

//clk2上升沿：100n+50
initial
begin
clk2=0; //maxhz=2;
rst_n=1;
forever
begin
#50 clk2=1;
#50 clk2=0;
end
end


//保证七个状态量始终只有一个有效
initial
begin
head=2'b00;
game_start_end=0;
#100;//100，50时menu=1

game_start_end=1;
#100;//200,150时menu=0，first_do=1

game_start_end=0;
#100;//300,250shi first_do=1

game_start_end=1;
#100;//400,350shi first_do=0,go_one_step=1;

#100;//500 450shi go_one_step=0,null_out=1

head=2'b10;
#100;//600 550shi null_out=0,go_one_step=1

#100;//700 650shi go_one_step=0,eat_apple=1

#100;//800 750shi eat_apple=0,random_growth=1

head=2'b11;
#100;//900 850shi random_growth=0,go_one_step=1;

game_start_end=0;
#100;//1000 950shi go_one_step=0,game_over=1;

game_start_end=1;
#100;//1100 1050shi game_over=1;

#100;//1200 1150shi game_over=0,menu=1



end




endmodule
