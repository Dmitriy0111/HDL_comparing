/*
*  File            :   simple_connect_sv.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   SystemVerilog
*  Description     :   This is simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_connect_sv
(
    input   logic   [7 : 0]     d_in,   // data input
    output  logic   [7 : 0]     d_out   // data output
);

    assign d_out = d_in;

endmodule : simple_connect_sv
