/*
*  File            :   simple_adder_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.20
*  Language        :   SystemVerilog
*  Description     :   This is simple adder
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_adder_sv
#(
    parameter                   W = 8
)(
    // data
    input   logic   [W-1 : 0]   x_0,
    input   logic   [W-1 : 0]   x_1,
    output  logic   [W-1 : 0]   result
);

    assign result = x_0 + x_1;

endmodule : simple_adder_sv
