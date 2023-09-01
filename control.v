module control(
input clk2,
input rst_n,//状态机有效信号，最重要，只有当状态机所决定的一系列操作完成之后才能继续启动状态机，进行下一个状态。
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
        
            if(head==2'b00)//无
            begin
                reg_c<=3'b101;
            end
            else if(head==2'b01||head==2'b11)//蛇身/墙体
            begin
                reg_c<=3'b110;
            end
            else//苹果
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