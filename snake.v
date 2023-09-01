/*v1.1�޸ģ��޸��˷�Ƶ���Ķ����ʵ������rstֱ����Ϊ0*/
/*v1.2�޸ģ��޸���vga�ĸ�λ�źų�ʼ�������е���ȷλ�ö���*/
//v1.3�޸ģ��޸��˿������Ķ����ʵ�֣�����״̬��������ȷ���������ⲿ����ǳ�ͻ�ź���
//v1.4�޸ģ��޸�����ת��������ʵ�֣�������ת������������ȷʹ�ã�����ʱ�Ӳ��л�ʱ���ٶ���
//v1.41�޸ģ����״̬��led����۲�
//v1.5�޸ģ��޸���һЩ��ʼ��������������⣬�߿�״̬�ƿ���������ʾ�����߼�����������
//v1.6�޸ģ��޸��˳��Ⱥͷ����Ĵ����壬�����˲�������λ��˵����������һЩʱ���غ͸�λ�ź�
//v1.777�޸ģ����͸Ķ����ı���ʵ�ַ�ʽ�������ö�ά���飬�����в��������±������Ϊ�޸ģ������޷����ɵ�·����·���롣
//������ͷ����������ʾ��������ײǽ��ʱ�������Ϸ�����ǻ��޷���ƻ����������Ϊδ֪ԭ���޷���ʾ��
//ps:��лzdd��ʦ�Ĵ���
//v1.778,�޸�������ƻ���ĸ�λ�ź�
//vfinal������20�����ܵ�����λ�ã��Զ���Բ����ɣ�qnmd̰���ߣ��������ɡ�

//VGA signal generator, 640 * 480, 25MHz
module vga(clk,clrn,d_in,rd_a,rdn,r,g,b,hs,vs,h_count,v_count);
	input clk;//��Ƶ��ֱ������50mhz
	input clrn;//�͵�ƽ��Ч��λ�ź�
	input [11:0] d_in;//rrrr_gggg_bbbb, pixel
	//input [1:0]memory[0:23][0:23];//����Ĵ洢����
	output [18:0] rd_a;//��ַ��640*480 (1024*512)
	output [3:0] r,g,b;
	output rdn;//�͵�ƽ��Ч���ź�
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
			//��δ��������Ҫ�κβ���
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

//��ʱ������
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

//ʱ�ӷ�Ƶ���忨��������Ϊ100mhz
//MAX_HZ:ʱ�ӷ��䱶��
//ip�ˣ����Կ���ʹ��
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



/*������*/
/*���ã�
�����ߵ�ǰ���������������ĸ��ƶ�����
ȷ�ϼ�/ȡ����
���ⲿ��������ź�
����������Ҫ����memory���飬ֻ��Ҫ���⴫�ݿ����ź�
������״̬��
*/
module control(
input clk2,
//input rst_n,//״̬����Ч�źţ�����Ҫ��ֻ�е�״̬����������һϵ�в������֮����ܼ�������״̬����������һ��״̬��
input game_start_end,//ȷ�ϼ�


input [1:0]head,//��ͷԪ��


output reg menu,
output reg first_do,
output reg go_one_step,
output reg eat_apple,
output reg random_growth,
output reg null_out,
output reg game_over


);


    reg [2:0]reg_c=3'b000;//�Ĵ�������¼״̬
    
    always @ (posedge clk2)
    begin
    
        if(reg_c==3'b000)//��ʼλ��
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

        else if(reg_c==3'b001)//��ʼ��
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
        
        else if(reg_c==3'b011)//ǰ��һ�񣬶�ȡǰ��ֵ
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
        
        else if(reg_c==3'b010)//�ж�
        begin
        
            if(head==2'b00)//��
        begin
            reg_c<=3'b110;
        end
        else if(head==2'b01||head==2'b11)//����/ǽ��
        begin
            reg_c<=3'b111;
        end
        else//ƻ��
        begin
            reg_c<=3'b101;
        end
        
        end 
        
        else if(reg_c==3'b101)//ƻ��
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
            
        else if(reg_c==3'b100)//��������ƻ��
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
            
        else if(reg_c==3'b110)//��
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
            
        else if(reg_c==3'b111)//����/ǽ��
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
            
        else//����
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

/*��ת������*/
/*ѡ����Ϸ�Ѷȣ��ߵ��ƶ��ٶ�*/
//���޸�ϵͳ��ʱ��
//VGA�ӿ�ˢ��Ƶ���ǹ̶��ģ������û�й�ϵ
//������λ����ת��������ȡ
//���ܿ���������
module rotation_sensor(
input sia,//˳ʱ����ת
input sib,//��ʱ����ת
input sw,//���£�����

input clk,//100mhz;10ns
output clk_game//������ת�Ĺ���
);
    reg [1:0] speed=0;//0-3    
    //�ٶȱ����4����0.2s, 0.1s, 0.05s, 0.02s
    
    reg [2:0]di=0;//��־λ
    
    //ʵ����divider��ʵ��
    //�½�����Ч
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

//���ĳ���������
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
        if(y==0||y==1||y==22||y==23||x==0||x==1||x==22||x==23)//ǽ��
            type_yx=2'b11;
        else if(y==apple_y&&x==apple_x)//ƻ��
            type_yx=2'b10;
        else if(y==snake_body_y0&&x==snake_body_x0)//����
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

output [6:0]led//�����ã���ȡ��ʱλ��ʲô״̬

    );

    /* 24*24�Ľ��棬�ֱ��ʲ���640*480��ÿ����Ԫ��Ϊ�߳�20���ص������Σ�ͼ�ν����С�ܹ�Ϊ480*480 */   
    /*��������*/
    /*������Ȧ��ǽ���ߵ�λ��Ϊ20*20*/
    /*���룺�ޣ�00������01��ƻ����10��ǽ�壺11*/
   // reg  [1:0]memory[0:23][0:23];//��ͼ
    
    /*����Ķ�Ӧ���У���˳��*/
    reg [4:0]snake_body_x;
    reg [4:0]snake_body_y;
    
    /*������ɵ�ƻ��,2��ǽλ��*/
    wire [4:0]apple_x;
    wire [4:0]apple_y;
    
    //״̬����
    wire menu;
    wire first_do;
    wire go_one_step;
    wire null_out;
    wire random_growth;
    wire eat_apple;//�ɴ��������ĸ�����
    wire game_over;
    
    //��ȡ״̬��led��ʾ
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
    wire [1:0]next_head;//�������������һ������λ�õ�ֵ
    reg [4:0]next_head_y;
    reg [4:0]next_head_x;
    wire clk1;//vga�ã�50mhz
    wire clk2;//��Ϸ����-�������ã�����ֵȡ������ת������
    wire clk3;//vga��ɫ��
    
    //vgaʹ��
        wire [9:0] h_count;
        wire [9:0] v_count;
        reg [11:0]d_in;/*16λrgb*/
        wire [18:0]rd_a;
        wire rdn;
    
    //ģ��ʵ��������

        vga VGA1(clk1,clrn,d_in,rd_a,rdn,vga_r,vga_g,vga_b,hs,vs,h_count,v_count);  
        Divider d2(clk,2,0,clk1);//rst=0!!!!!!!!!!
        Divider d3(clk,4,0,clk3);
        randomx rand1(random_growth,rst,apple_x,apple_y);
        rotation_sensor rs1(sia,sib,sw,clk,clk2);
        control con1(clk2,game_start_end,next_head,menu,first_do,go_one_step,eat_apple,random_growth,null_out,game_over);
        check_type c1(next_head_y,next_head_x,snake_body_y,snake_body_x,apple_y,apple_x,next_head);
        
        reg [9:0] row;//��ǰvga��������
        reg [9:0] col;//��ǰvga��������

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
            if((col>=10'd480&&col<10'd640)||col==10'd640||row==10'd480)//״̬�����������߳���,����Чֵ��ɨ�������λ�ã�
            begin
        
                d_in<=12'hff0;//ע���ڴ˴��޸ģ���������������������������
        
            end
            else//ͼ����row:0-479; col:0-479         
            begin                
                if(row/20==0||row/20==1||row/20==22||row/20==23||col/20==0||col/20==1||col/20==22||col/20==23)//ǽ��
                    d_in<=12'hfff;
                else if(row/20==apple_y&&col/20==apple_x)//ƻ��
                    d_in<=12'hf00;
                else if(row/20==snake_body_y&&col/20==snake_body_x)//����
                    d_in<=12'h0f0;
                else
                    d_in<=12'h000;
            end
        end

//ǰ���������ȱ��룺���������ҵ�˳�򣬲���ʱ��Ӱ�졣
//ʹ��һ���������洢ǰ��������ʱ�������ص�����ʱ��������������Ϊǰ������
    reg [1:0]direction;//��ʼ������������
    //�ĸ��������:��00��01��10��11
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
    //rst,Ĭ������
    direction<=2'b11;
    end
    end
    
    /*��Ϸ���̿�*/
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