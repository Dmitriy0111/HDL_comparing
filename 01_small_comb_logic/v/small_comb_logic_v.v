/*
*  File            :   small_comb_logic_v.v
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Verilog
*  Description     :   This is simple connect with small combination logic
*  Copyright(c)    :   2019 Vlasov D.V.
*/

module small_comb_logic_v
(
    input   wire    [7 : 0]     d_in,   // data input
    output  wire    [7 : 0]     d_out   // data output
);

    assign d_out[0] = d_in[0];
    assign d_out[1] = ~d_in[1];
    assign d_out[2 +: 2] = d_in[0 +: 2] ^ d_in[2 +: 2];
    assign d_out[4 +: 2] = d_in[0 +: 2] + d_in[2 +: 2];
    assign d_out[6] = d_in[6] & d_in[7];
    assign d_out[7] = d_in[6] | d_in[7];

endmodule // small_comb_logic_v
