module Datapath #(parameter N = 8 , k = 8)(
    input logic clk,
    input logic rst_n,
    input logic s,
    input logic [N-1 :0] DataIn,
    input logic [$clog2(k) -1 :0] RAdd,
    input logic Wrinit,

    input logic EA,             //-----|
    input logic EB,             //     |
    input logic WR,             //     | 
    input logic Li,             //     |
    input logic Lj,             //     |------- FSM SIGNALS
    input logic Ei,             //     |
    input logic Ej,             //     |
    input logic Csel,           //     |
    input logic Bout,           //     |   
    input logic Rd,             //-----|


    output logic [N-1: 0] DataOut,
    output logic Sw_flag,
    output logic AgtB,
    output logic zi,
    output logic zj

);
    
    localparam L = $clog2(k);

    logic [N-1 :0] RegA;
    logic [N-1 :0] RegB;
    logic [N-1 :0] ABMux;

    logic [L-1 :0] Regi;
    logic [L-1 :0] Regj;
    logic [L-1 :0] ijMux;




    //////// RAM SIGNALS ////////


    logic [N-1 :0] RAM [k];
    logic [N-1 :0] D_out;
    logic [N-1 :0] D_in;
    logic [L-1 : 0] Addr;


////////////// MUX /////////////////////////////

    always_comb
    begin

    ABMux = (Bout) ? RegB : RegA;
    D_in = (s) ? ABMux : DataIn;
    ijMux = (Csel) ? Regj: Regi;
    Addr = (s) ? ijMux : RAdd ;
    
    end


    // initial
    // begin
    
    //     $readmemh("RAM_VAL.mem", RAM);
    
    // end



    always_ff@(posedge clk, negedge rst_n)
        begin

            if(Wrinit | WR)
                RAM[Addr] <= D_in;


        end


    assign D_out = RAM[Addr];




///////////// REGISTER A /////////////////////


    always_ff@(posedge clk, negedge rst_n)
        begin

            if(~rst_n)
                RegA <= 0;

            else if(EA)
                RegA <= D_out;

        end



///////////// REGISTER B /////////////////////


    always_ff@(posedge clk, negedge rst_n)
        begin

            if(~rst_n)
                RegB <= 0;

            else if(EB)
                RegB <= D_out;

        end


///////////// REGISTER i //////////////////////////////

    always_ff@(posedge clk, negedge rst_n)
        begin

            if(~rst_n)
                Regi <= 0;

            else if(Li && Ei)
                Regi <= 0;
            
            else if(Ei)
                Regi <= Regi + 1;


        end



///////////// REGISTER j //////////////////////////////

    always_ff@(posedge clk, negedge rst_n)
        begin

            if(~rst_n)
                Regj <= 0;

            else if(Lj && Ej)
                Regj <= Regi + 1;

            else if(Ej)
                Regj <= Regj + 1;

        end





////////////// OUTPUT LOGIC  ///////////////////////

    always_comb
        begin

            AgtB = RegA > RegB;
            DataOut = (Rd) ? D_out : 'z ;
            zi  = (Regi == k-2);
            zj  = (Regj == k-1);

        end


//////////////// SWAP FLAG  ////////////////////////
    always_ff@(posedge clk, negedge rst_n)
        begin

            if(~rst_n)
                Sw_flag <=1;

            else if(WR | Ei)
                Sw_flag <= 1;

            else if(Ej && Lj)
                Sw_flag <= 0;


        end





endmodule