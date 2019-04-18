/*
*  File            :   Simple_connect_tb_spinal.scala
*  Autor           :   Vlasov D.V.
*  Data            :   2019.04.18
*  Language        :   Scala
*  Description     :   This is testbench for simple connect example
*  Copyright(c)    :   2019 Vlasov D.V.
*/

import spinal.core.sim._
import spinal.core._
import spinal.sim._

import scala.util.Random

object Simple_connect_tb_spinal
{
    def main(args: Array[String]): Unit = 
    {
        SimConfig.withWave.compile(new Simple_connect_spinal).
        doSim
                {
                    dut =>
                    var idx = 0
                    while( idx < 10 )
                    {
                        val d_in = Random.nextInt(256)
                        dut.io.d_in #= d_in
                        sleep(10)
                        idx += 1
                    }
                }
    }
} // Simple_connect_tb_spinal
