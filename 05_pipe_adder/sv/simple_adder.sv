/*
*  File            :   simple_adder_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is simple adder with carry
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_adder_sv
#(
    parameter                   W = 32
)(
    input   logic   [0   : 0]   c_in,
    input   logic   [W-1 : 0]   x_0,
    input   logic   [W-1 : 0]   x_1,
    output  logic   [W-1 : 0]   y,
    output  logic   [0   : 0]   c_out
);

    assign { c_out , y } = x_1 + x_0 + c_in;

endmodule : simple_adder_sv
    