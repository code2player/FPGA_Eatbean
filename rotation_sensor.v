//ʱ�ӷ�Ƶ���忨��������Ϊ100mhz
//MAX_HZ:ʱ�ӷ��䱶��
//ip�ˣ����Կ���ʹ��
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