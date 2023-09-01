module Divider(
input I_CLK,
input rst,
output reg O_CLK=0
    );
    
    parameter MAX_HZ=20;
    
    integer i=0;

    
    always @( posedge I_CLK )
    begin
    
    if(rst==1)
    begin
    i<=0;
    O_CLK<=0;
    end
    
    else if(i==MAX_HZ/2-1)
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
