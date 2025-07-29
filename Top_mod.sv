module Top_mod #(parameter N=8, k=8)(
    input logic clk,
    input logic rst_n,
    input logic s,

    input logic [N-1 :0] DataIn,
    input logic [$clog2(k)-1 :0 ] RAdd,
    input logic Wrinit,
    input logic Rd,


    output logic done,
    output logic [N-1:0] DataOut

);

    logic EA;  
    logic EB;  
    logic WR;  
    logic Li;  
    logic Lj;  
    logic Ei;  
    logic Ej;  
    logic Csel;
    logic Bout;
    logic Sw_flag;

    logic zi; 
    logic zj;
    logic AgtB; 


    FSM_unit fsm
    (
        .clk(clk),
        .rst_n(rst_n),
        .s(s),

        .zi(zi),
        .zj(zj),
        .AgtB(AgtB),
        .Sw_flag(Sw_flag),

        .EA(EA),
        .EB(EB),
        .WR(WR),
        .Li(Li),
        .Lj(Lj),
        .Ei(Ei),
        .Ej(Ej),
        .Csel(Csel),
        .Bout(Bout),

        .done(done)
    );



    Datapath #(N,k) datapath
    (
        .clk(clk),
        .rst_n(rst_n),
        .s(s),
        .DataIn(DataIn),
        .RAdd(RAdd),
        .Wrinit(Wrinit),

        .EA(EA),
        .EB(EB),
        .WR(WR),
        .Li(Li),
        .Lj(Lj),
        .Ei(Ei),
        .Ej(Ej),
        .Csel(Csel),
        .Bout(Bout),
        .Rd(Rd),

        .DataOut(DataOut),
        .AgtB(AgtB),
        .Sw_flag(Sw_flag),
        .zi(zi),
        .zj(zj)
    );












    
endmodule