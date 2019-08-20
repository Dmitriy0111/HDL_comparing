/*
*  File            :   simple_adder_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is simple adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_adder_v
    #(
        parameter                   W = 8
    )(
        // data
        input   wire    [W-1 : 0]   x_0,
        input   wire    [W-1 : 0]   x_1,
        output  wire    [W-1 : 0]   result
    );
    
        assign result = x_0 + x_1;
    
endmodule // simple_adder_v
