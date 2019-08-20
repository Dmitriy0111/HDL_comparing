/*
*  File            :   simple_adder_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   Verilog
*  Description     :   This is simple adder with carry
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_adder_v
#(
    parameter                   W = 32
)(
    input   wire    [0   : 0]   c_in,
    input   wire    [W-1 : 0]   x_0,
    input   wire    [W-1 : 0]   x_1,
    output  wire    [W-1 : 0]   y,
    output  wire    [0   : 0]   c_out
);

    assign { c_out , y } = x_1 + x_0 + c_in;

endmodule // simple_adder_v
    