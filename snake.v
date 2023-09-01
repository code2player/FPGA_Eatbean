/*v1.1修改：修改了分频器的定义和实例化中rst直接设为0*/
/*v1.2修改：修改了vga的复位信号初始化和行列的正确位置定义*/
//v1.3修改，修改了控制器的定义和实现，现在状态机可以正确启动并向外部传输非冲突信号了
//v1.4修改，修改了旋转编码器的实现，现在旋转编码器可以正确使用：传出时钟并切换时钟速度了
//v1.41修改，添加状态量led输出观察
//v1.5修改，修改了一些初始化问题和其他问题，边框，状态灯可以正常显示，但逻辑可能有问题
//v1.6修改，修改了长度和分数的错误定义，增加了部分数据位的说明，增加了一些时钟沿和复位信号
//v1.777修改，大型改动，改变了实现方式，不适用二维数组，过程中不对数组下标进行人为修改，否则无法生成电路，电路乱码。
//现在蛇头可以正常显示，可以在撞墙的时候结束游戏。但是还无法吃苹果，蛇身因为未知原因无法显示。
//ps:感谢zdd老师的答疑
//v1.778,修改了生成苹果的复位信号
//vfinal，给了20个可能的生成位置，吃豆人圆满完成，qnmd贪吃蛇，就这样吧。

//VGA signal generator, 640 * 480, 25MHz
module vga(clk,clrn,d_in,rd_a,rdn,r,g,b,hs,vs,h_count,v_count);
	input clk;//分频器直接输入50mhz
	input clrn;//低电平有效复位信号
	input [11:0] d_in;//rrrr_gggg_bbbb, pixel
	//input [1:0]memory[0:23][0:23];//传入的存储数组
	output [18:0] rd_a;//地址，640*480 (1024*512)
	output [3:0] r,g,b;
	output rdn;//低电平有效读信号
	output hs,vs;
	output [9:0] h_count;
	output [9:0] v_count;
	//internal
	reg vga_clk;
	reg [9:0] h_count;
	reg [9:0] v_count;
	reg [11:0]data_reg;
	reg video_out;

	always @ (posedge clk or negedge clrn)
	begin
		if(clrn==0)
		begin
			vga_clk<=1'b1;
		end
		else
		begin
			vga_clk<=~vga_clk;
		end
	end

	always @ (posedge vga_clk or negedge clrn)
	begin
		if(clrn==0)
		begin
			h_count<=10'h0;
		end
		else if(h_count==10'd799)
		begin
			h_count<=10'h0;
		end
		else
		begin
		h_count<=h_count+10'h1;
		end
	end

	always @ (posedge vga_clk or negedge clrn)
	begin
		if(clrn==0)
		begin
			v_count<=10'h0;
		end
		else if(h_count==10'd799)
		begin
			if(v_count==10'd524)
			begin
				v_count<=10'h0;
			end
			else
			begin
				v_count<=v_count+10'h1;
			end
		end
		else
		begin
			//行未满，不需要任何操作
		end
	end

	always @ (posedge vga_clk or negedge clrn)
	begin
		if(clrn==0)
		begin
			video_out<=1'b0;
			data_reg<=12'h0;
		end
		else
		begin
			video_out<=~rdn;
			data_reg<=d_in;
		end
	end

	assign rdn=~(((h_count>=10'd143)&&(h_count<10'd783))&&
		((v_count>=10'd35)&&(v_count<10'd515)));
	wire [9:0] row=v_count-10'd35;
	wire [9:0] col=h_count-10'd143;
	assign rd_a={row[8:0],col};
	assign hs=(h_count>=10'd96);
	assign vs=(v_count>=10'd2);
	assign r=(video_out)?data_reg[11:8]:4'h0;
	assign g=(video_out)?data_reg[7:4]:4'h0;
	assign b=(video_out)?data_reg[3:0]:4'h0;
endmodule

//临时测试用
module randomx(
input clk,
input rst_n,
output reg[4:0] rand_apple_x=12,
output reg[4:0] rand_apple_y=12
);
    integer i=0;
    
    always @(posedge clk or posedge rst_n)
    begin
    if(rst_n==1)
    begin
    i<=0;
    rand_apple_x<=6;
    rand_apple_y<=6;
    end
    else
    begin
   // rand_apple_x<=8;
   // rand_apple_y<=8;
    
    i<=i+1;
    if(i==0)begin rand_apple_x<=8; rand_apple_y<=8; end
    else if(i==1)begin rand_apple_x<=11; rand_apple_y<=7; end
    else if(i==2)begin rand_apple_x<=3; rand_apple_y<=5; end
    else if(i==3)begin rand_apple_x<=13; rand_apple_y<=17; end
    else if(i==4)begin rand_apple_x<=8; rand_apple_y<=14; end
    else if(i==5)begin rand_apple_x<=5; rand_apple_y<=15; end
    else if(i==6)begin rand_apple_x<=12; rand_apple_y<=11; end
    else if(i==7)begin rand_apple_x<=7; rand_apple_y<=4; end
    else if(i==8)begin rand_apple_x<=18; rand_apple_y<=8; end
    else if(i==9)begin rand_apple_x<=2; rand_apple_y<=2; end
    else if(i==10)begin rand_apple_x<=21; rand_apple_y<=21; end
    else if(i==11)begin rand_apple_x<=2; rand_apple_y<=21; end
    else if(i==12)begin rand_apple_x<=21; rand_apple_y<=2; end
    else if(i==13)begin rand_apple_x<=6; rand_apple_y<=18; end
    else if(i==14)begin rand_apple_x<=14; rand_apple_y<=8; end
    else if(i==15)begin rand_apple_x<=19; rand_apple_y<=3; end
    else if(i==16)begin rand_apple_x<=20; rand_apple_y<=11; end
    else if(i==17)begin rand_apple_x<=13; rand_apple_y<=7; end
    else if(i==18)begin rand_apple_x<=3; rand_apple_y<=17; end
    else if(i==19)begin rand_apple_x<=6; rand_apple_y<=20; end
    else begin  rand_apple_x<=16; rand_apple_y<=10; i<=0; end
    
    end
    
    end


endmodule

//时钟分频，板卡初是输入为100mhz
//MAX_HZ:时钟分配倍数
//ip核：可以考虑使用
module Divider(
input I_CLK,
input [63:0] MAX_HZ,
input rst,
output reg O_CLK
    );
    
 //   parameter MAX_HZ=4;
    
    reg [64:0]i=0;
    initial
    begin
    O_CLK<=0;
    end
    
    always @( posedge I_CLK or posedge rst)
    begin
    
    if(rst==1)
    begin
    i<=0;
    O_CLK<=0;
    end
    
    else if(i>=MAX_HZ/2-1)
    begin
    i<=0;
    O_CLK<=~O_CLK;   
    end
       
    else
    begin
    i<=i+1;
    end

    end

endmodule



/*控制器*/
/*作用：
控制蛇的前进方向：上下左右四个移动方向
确认键/取消键
向外部传输控制信号
控制器不需要传入memory数组，只需要向外传递控制信号
本质是状态机
*/
module control(
input clk2,
//input rst_n,//状态机有效信号，最重要，只有当状态机所决定的一系列操作完成之后才能继续启动状态机，进行下一个状态。
input game_start_end,//确认键


input [1:0]head,//蛇头元素


output reg menu,
output reg first_do,
output reg go_one_step,
output reg eat_apple,
output reg random_growth,
output reg null_out,
output reg game_over


);


    reg [2:0]reg_c=3'b000;//寄存器，记录状态
    
    always @ (posedge clk2)
    begin
    
        if(reg_c==3'b000)//起始位置
        begin
        menu<=1;
        first_do<=0;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=0;
        
            if(game_start_end==1)
            begin 
                reg_c<=3'b001;
            end
            else
                reg_c<=3'b000;
        end

        else if(reg_c==3'b001)//初始化
        begin
        menu<=0;
        first_do<=1;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=0;
        
        reg_c<=3'b011;
        end
        
        else if(reg_c==3'b011)//前进一格，读取前方值
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=1;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=0;
        
           reg_c<=3'b010;
        end
        
        else if(reg_c==3'b010)//判断
        begin
        
            if(head==2'b00)//无
        begin
            reg_c<=3'b110;
        end
        else if(head==2'b01||head==2'b11)//蛇身/墙体
        begin
            reg_c<=3'b111;
        end
        else//苹果
        begin
            reg_c<=3'b101;
        end
        
        end 
        
        else if(reg_c==3'b101)//苹果
            begin
            menu<=0;
            first_do<=0;
            go_one_step<=0;
            eat_apple<=1;
            random_growth<=0;
            null_out<=0;
            game_over<=0;
            
            reg_c=3'b100;
            end  
            
        else if(reg_c==3'b100)//重新生成苹果
            begin
            menu<=0;
            first_do<=0;
            go_one_step<=0;
            eat_apple<=0;
            random_growth<=1;
            null_out<=0;
            game_over<=0;
            
            reg_c=3'b011;
            end  
            
        else if(reg_c==3'b110)//无
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=1;
        game_over<=0;
        
            reg_c=3'b011;
        end  
            
        else if(reg_c==3'b111)//蛇身/墙体
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=1;
            if(game_start_end==0)
                reg_c=3'b111;
            else
                reg_c=3'b000;
        end 
            
        else//冗余
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=0;
        
            reg_c=3'b000;
        end  

    end
endmodule

/*旋转编码器*/
/*选择游戏难度：蛇的移动速度*/
//即修改系统总时钟
//VGA接口刷新频率是固定的，与这个没有关系
//参数档位从旋转编码器获取
//不受控制器控制
module rotation_sensor(
input sia,//顺时针旋转
input sib,//逆时针旋转
input sw,//按下，清零

input clk,//100mhz;10ns
output clk_game//按照旋转的过程
);
    reg [1:0] speed=0;//0-3    
    //速度编码分4档，0.2s, 0.1s, 0.05s, 0.02s
    
    reg [2:0]di=0;//标志位
    
    //实例化divider来实现
    //下降沿有效
    always @(posedge sia or posedge sib or negedge sw) 
    begin
    
    if(sw==0)
    begin
    speed<=0;
    end
    else
    begin
    
        if(sia==1&&sib==0)
        begin
            if(speed!=3)
                speed<=speed+1;
        end
        else if(sia==0&&sib==1)
        begin
            if(speed!=0)
                speed<=speed-1;
        end
        else if(sia==1&&sib==1)
        begin
            
        end
        else
            speed<=0;    
    end 
    end
    
    reg[63:0] MAX_div;
    always @(speed)
    begin
        if(speed==0)
    MAX_div<=50000000;
    else if(speed==1)
    MAX_div<=40000000;
    else if(speed==2)
    MAX_div<=20000000;
    else
    MAX_div<=10000000;
               
    end
    Divider d1(clk,MAX_div,0,clk_game);
endmodule

//检查某个点的种类
module check_type(
input [4:0]y,
input [4:0]x,
input [4:0]snake_body_y0,
input [4:0]snake_body_x0,
input [4:0]apple_y,
input [4:0]apple_x,
output reg [1:0] type_yx
);
    
    always @(y or x)
    begin
        if(y<0||y>23||x<0||x>23)
        type_yx=2'b00;
        
        else
        begin
        if(y==0||y==1||y==22||y==23||x==0||x==1||x==22||x==23)//墙壁
            type_yx=2'b11;
        else if(y==apple_y&&x==apple_x)//苹果
            type_yx=2'b10;
        else if(y==snake_body_y0&&x==snake_body_x0)//蛇身
            type_yx=2'b01;
        else
            type_yx=2'b00;
        end
    end
endmodule

module snake(
input clk,
input clrn,
input rst,
input game_start_end,
input turn_up,
input turn_down,
input turn_left,
input turn_right,

input sia,
input sib,
input sw,

output hs,
output vs,
output [3:0]vga_r,
output [3:0]vga_g,
output [3:0]vga_b,

output [6:0]led//测试用，读取此时位于什么状态

    );

    /* 24*24的界面，分辨率采用640*480，每个单元格为边长20像素的正方形，图形界面大小总共为480*480 */   
    /*坐标数组*/
    /*边上两圈是墙，蛇的位置为20*20*/
    /*编码：无：00；蛇身：01；苹果：10；墙体：11*/
   // reg  [1:0]memory[0:23][0:23];//地图
    
    /*蛇身的对应队列，按顺序*/
    reg [4:0]snake_body_x;
    reg [4:0]snake_body_y;
    
    /*随机生成的苹果,2个墙位置*/
    wire [4:0]apple_x;
    wire [4:0]apple_y;
    
    //状态代码
    wire menu;
    wire first_do;
    wire go_one_step;
    wire null_out;
    wire random_growth;
    wire eat_apple;//可代替上面四个操作
    wire game_over;
    
    //读取状态，led显示
    assign led[0]=menu;
    assign led[1]=first_do;
    assign led[2]=go_one_step;
    assign led[3]=null_out;
    assign led[4]=random_growth;
    assign led[5]=eat_apple;
    assign led[6]=game_over;

    
    integer i;
    integer j;
    integer k;
    wire [1:0]next_head;//传入控制器的下一个到达位置的值
    reg [4:0]next_head_y;
    reg [4:0]next_head_x;
    wire clk1;//vga用，50mhz
    wire clk2;//游戏过程-控制器用，具体值取决于旋转编码器
    wire clk3;//vga传色彩
    
    //vga使用
        wire [9:0] h_count;
        wire [9:0] v_count;
        reg [11:0]d_in;/*16位rgb*/
        wire [18:0]rd_a;
        wire rdn;
    
    //模块实例化部分

        vga VGA1(clk1,clrn,d_in,rd_a,rdn,vga_r,vga_g,vga_b,hs,vs,h_count,v_count);  
        Divider d2(clk,2,0,clk1);//rst=0!!!!!!!!!!
        Divider d3(clk,4,0,clk3);
        randomx rand1(random_growth,rst,apple_x,apple_y);
        rotation_sensor rs1(sia,sib,sw,clk,clk2);
        control con1(clk2,game_start_end,next_head,menu,first_do,go_one_step,eat_apple,random_growth,null_out,game_over);
        check_type c1(next_head_y,next_head_x,snake_body_y,snake_body_x,apple_y,apple_x,next_head);
        
        reg [9:0] row;//当前vga像素行数
        reg [9:0] col;//当前vga像素列数

                always @(posedge clk3)
                begin
                if(v_count>=10'd35&&v_count<10'd515)
                row=v_count-10'd35;
                else
                row=10'd480;//null
                end

                always @(posedge clk3)
                begin
                if(h_count>=10'd143&&h_count<10'd783)
                col=h_count-10'd143;
                else
                col=10'd640;//null
                end
        
        
        always @ (posedge clk3)//vga
        begin
            if((col>=10'd480&&col<10'd640)||col==10'd640||row==10'd480)//状态栏，分数，蛇长等,或无效值（扫描的其他位置）
            begin
        
                d_in<=12'hff0;//注意在此处修改！！！！！！！！！！！！！！
        
            end
            else//图画栏row:0-479; col:0-479         
            begin                
                if(row/20==0||row/20==1||row/20==22||row/20==23||col/20==0||col/20==1||col/20==22||col/20==23)//墙壁
                    d_in<=12'hfff;
                else if(row/20==apple_y&&col/20==apple_x)//苹果
                    d_in<=12'hf00;
                else if(row/20==snake_body_y&&col/20==snake_body_x)//蛇身
                    d_in<=12'h0f0;
                else
                    d_in<=12'h000;
            end
        end

//前进方向：优先编码：按上下左右的顺序，不受时序影响。
//使用一个变量来存储前进方向，在时钟上升沿到来的时候采用这个变量作为前进方向。
    reg [1:0]direction;//初始化，方向向上
    //四个方向编码:上00下01左10右11
    always @(posedge turn_up or posedge turn_down or posedge turn_left or posedge turn_right or posedge rst)
    begin
    if(turn_up==1'b1)
    direction<=2'b00;
    else if(turn_down==1'b1)
    direction<=2'b01;
    else if(turn_left==1'b1)
    direction<=2'b10;
    else if(turn_right==1'b1)
    direction<=2'b11;
    else
    begin
    //rst,默认向右
    direction<=2'b11;
    end
    end
    
    /*游戏过程块*/
    always @(posedge menu or posedge first_do or posedge go_one_step or posedge null_out
     or posedge eat_apple or posedge random_growth or posedge game_over)
    begin

    if(menu==1)
    begin
            snake_body_x<=5'd0;
            snake_body_y<=5'd0;
    end

    else if(first_do==1)
    begin
    next_head_x<=5'd6;
    next_head_y<=5'd6;
    snake_body_x<=5'd12;
    snake_body_y<=5'd11;
    end

    else if(go_one_step==1)
    begin

        if(direction==2'b00)//up
        begin
            next_head_y<=snake_body_y-1;
            next_head_x<=snake_body_x;
        end
        else if(direction==2'b01)//down
        begin
            next_head_y<=snake_body_y+1;
            next_head_x<=snake_body_x;
        end
        else if(direction==2'b10)//left
        begin
            next_head_y<=snake_body_y;
            next_head_x<=snake_body_x-1;
        end
        else//right
        begin
           next_head_y<=snake_body_y;
           next_head_x<=snake_body_x+1;
        end
    end

    else if(null_out==1)
    begin
        snake_body_x<=next_head_x;
        snake_body_y<=next_head_y;
    end

    else if(eat_apple==1)
    begin
        snake_body_x<=next_head_x;
        snake_body_y<=next_head_y;
    end

    else if(random_growth==1)
    begin
       // memory[apple_y][apple_x]<=2'b10;
    end

    else if(game_over==1)
    begin

    end

    else
    begin

    end

    end
  
endmodule