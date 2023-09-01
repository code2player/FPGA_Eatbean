module control(
input clk2,
input rst_n,//״̬����Ч�źţ�����Ҫ��ֻ�е�״̬����������һϵ�в������֮����ܼ�������״̬����������һ��״̬��
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
    
        if(reg_c==3'b000)
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

        else if(reg_c==3'b001)
        begin
        menu<=0;
        first_do<=1;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=0;
        
        reg_c<=3'b010;
        end
        
        else if(reg_c==3'b010)
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=1;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=0;
        
            if(head==2'b00)//��
            begin
                reg_c<=3'b101;
            end
            else if(head==2'b01||head==2'b11)//����/ǽ��
            begin
                reg_c<=3'b110;
            end
            else//ƻ��
            begin
                reg_c<=3'b011;
            end
        end
        
        else if(reg_c==3'b011)
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
            
        else if(reg_c==3'b100)
            begin
            menu<=0;
            first_do<=0;
            go_one_step<=0;
            eat_apple<=0;
            random_growth<=1;
            null_out<=0;
            game_over<=0;
            
            reg_c=3'b010;
            end  
            
        else if(reg_c==3'b101)
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=1;
        game_over<=0;
        
            reg_c=3'b010;
        end  
            
        else if(reg_c==3'b110)
        begin
        menu<=0;
        first_do<=0;
        go_one_step<=0;
        eat_apple<=0;
        random_growth<=0;
        null_out<=0;
        game_over<=1
        ;
            if(game_start_end==0)
                reg_c=3'b110;
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