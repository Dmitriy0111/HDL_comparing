/*
*  File            :   small_comb_logic_spinal.scala
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Scala
*  Description     :   This is simple connect with small combination logic
*  Copyright(c)    :   2019 Vlasov D.V.
*/

import spinal.core._

class small_comb_logic_spinal extends Component
{ 
    val io = new Bundle
    { 
        val d_in    = in    UInt(8 bits)    // data input
        val d_out   = out   UInt(8 bits)    // data input
    } 

    io.d_out(0) \= io.d_in(0)
    io.d_out(1) \= ~io.d_in(1)
    io.d_out(2 to 3) \= io.d_in(1 downto 0) ^ io.d_in(3 downto 2)
    io.d_out(4 to 5) \= io.d_in(1 downto 0) + io.d_in(3 downto 2)
    io.d_out(6) \= io.d_in(6) & io.d_in(7)
    io.d_out(7) \= io.d_in(6) | io.d_in(7)
    
} // small_comb_logic_spinal

object MyMain 
{
    def main(args: Array[String]) 
    {
        SpinalVhdl(new small_comb_logic_spinal()) //Generate a VHDL file
        SpinalVerilog(new small_comb_logic_spinal()) //Generate a VHDL file
    }
}
