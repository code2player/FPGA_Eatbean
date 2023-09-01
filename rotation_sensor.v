//时钟分频，板卡初是输入为100mhz
//MAX_HZ:时钟分配倍数
//ip核：可以考虑使用
module Divider(
input I_CLK,
input [31:0] MAX_HZ,
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
    
    reg[31:0] MAX_div;
    
    always @(posedge clk or speed)
    begin
        if(speed==0)
        MAX_div<=20;
        else if(speed==1)
        MAX_div<=10;
        else if(speed==2)
        MAX_div<=5;
        else
        MAX_div<=2;
              
    end

    Divider d1(clk,MAX_div,0,clk_game);

endmodule