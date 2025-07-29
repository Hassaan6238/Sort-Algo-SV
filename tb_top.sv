`timescale 1ns/1ps

module Top_mod_tb;

  localparam N = 8;
  localparam k = 8;
  localparam CLK_PERIOD = 10;
  localparam debug = 1; // set to 1 to print Dataout values




///////// TB Initial Memory /////////////
  logic [N-1 : 0] init_mem[8];



///////// TOP Module SIGNALS ////////////
  logic clk;
  logic rst_n;
  logic s;
  logic [N-1:0] DataIn;
  logic [$clog2(k)-1:0] RAdd;
  logic Wrinit;

  logic done;



  //////// Debug Signals ////////////
  logic Rd;
  logic [N-1:0] DataOut;



  always #(CLK_PERIOD/2) clk = ~clk;


    initial begin

        $readmemh("RAM_VAL.mem", init_mem);

    end


  Top_mod #(N, k) dut (
    .clk(clk),
    .rst_n(rst_n),
    .s(s),
    .DataIn(DataIn),
    .RAdd(RAdd),
    .Wrinit(Wrinit),
    .Rd(Rd),

    .done(done),
    .DataOut(DataOut)
  );









    task write_memory();


        @(negedge clk);

        Wrinit = 1;
        
        for(int i =0; i< 8 ; ++i)
        
        begin

        
            DataIn = init_mem[i];
            RAdd = i;
            @(negedge clk);


        end

        @(posedge clk);

        Wrinit = 0;

    
    endtask




/////////////// DEBUG BLOCK ////////////////////////
    generate
        if(debug)
        begin
        
            assign Rd =1;

                initial begin


                    $monitor("[%t] Data out value: %d " ,$time , DataOut);

                end


        end

        else
            assign Rd =0;    

    endgenerate





  initial begin
    clk = 0;
    rst_n = 0;
    s = 0;
    DataIn = 8'h00;
    RAdd = 0;
    Wrinit = 0; 

    #20;
    rst_n = 1;


    write_memory(); // initial memory write

    $display("Initial Array : %p" , dut.datapath.RAM);

    s=1;
    wait(done);
    s=0;

    $display("Test complete. Done signal: %b", done);
    $display("Final Array : %p" , dut.datapath.RAM);


    $finish;


  end





endmodule
