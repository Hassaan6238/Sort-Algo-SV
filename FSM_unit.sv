module FSM_unit (
    input logic clk,
    input logic rst_n,
    input logic s,

    input logic zi,
    input logic zj,
    input logic AgtB,
    input logic Sw_flag,

    output logic EA,             
    output logic EB,             
    output logic WR,              
    output logic Li,             
    output logic Lj,   
    output logic Ei,             
    output logic Ej,             
    output logic Csel,           
    output logic Bout,              

    output logic done            
);



localparam STAGES = 8 ;
logic [$clog2(STAGES) -1 : 0 ] P_state;
logic [$clog2(STAGES) -1 : 0 ] N_state;

localparam S0=0;
localparam S1=1;
localparam S2=2;
localparam S3=3;
localparam S4=4;
localparam S5=5;
localparam S6=6;
localparam S7=7;


    always_ff @( posedge clk, negedge rst_n ) begin

        if(~rst_n)
            P_state <= 0;
        
        else
            P_state <= N_state;
        
    end


    always_comb begin

        Ei= ( (P_state == S3 | P_state == S6) && N_state == S1 )? 1 : 0;  
        Ej= ( ( (P_state == S3 | P_state == S6) && N_state == S2 ) | P_state==S1 ) ? 1 : 0;  



    end


    always_comb begin
    
        EA=0;  
        EB=0;  
        WR=0;  
        Li=0;  
        Lj=0;  
        Csel=0;
        Bout=0;
        done = 0;
        N_state = S0;

        case(P_state)


    S0: begin
    
            N_state = (s)? S1:S0;
            Li =1;
            Ei =1;

        end

    S1: begin

            N_state = (~Sw_flag) ? S7 : S2;
            EA = 1;
            Lj =1;

        end
    
    S2: begin

            N_state = S3;
            Csel = 1;
            EB = 1;

        end
   
    S3: begin

            N_state = (AgtB) ? S4 : ( (zj) ? ( (zi) ? S7 : S1 ) : S2 ) ;


        end

    S4: begin

            N_state = S5;
            Bout = 1;
            WR = 1;

        end

    S5: begin

            N_state = S6;
            Csel = 1;
            WR = 1;

        end

    S6: begin

            N_state = (zj) ? ( (zi) ? S7 : S1 ) : S2  ;
            EA = 1;

        end

    S7: begin

            N_state = (s) ? S7: S0;
            done = 1;

        end



        endcase





    end









endmodule