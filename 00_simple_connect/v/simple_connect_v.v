/*
*  File            :   simple_connect_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Verilog
*  Description     :   This is simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module simple_connect_v
(
    input   wire    [7 : 0]     d_in,   // data input
    output  wire    [7 : 0]     d_out   // data output
);

    assign d_out = d_in;

endmodule // simple_connect_v
