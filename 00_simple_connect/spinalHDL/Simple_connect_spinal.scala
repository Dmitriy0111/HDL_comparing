/*
*  File            :   Simple_connect_spinal.scala
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Scala
*  Description     :   This is simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

import spinal.core._

class Simple_connect_spinal extends Component
{ 
    val io = new Bundle
    { 
        val d_in    = in    UInt(8 bits)    // data input
        val d_out   = out   UInt(8 bits)    // data output
    } 

    io.d_out \= d_in
    
} // Simple_connect_spinal

object MyMain 
{
    def main(args: Array[String]) 
    {
        SpinalVhdl(new Simple_connect_spinal())     //Generate a VHDL file
        SpinalVerilog(new Simple_connect_spinal())  //Generate a VHDL file
    }
}
