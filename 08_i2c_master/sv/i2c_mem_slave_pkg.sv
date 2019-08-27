/*
*  File            :   i2c_mem_slave_pkg.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.27
*  Language        :   SystemVerilog
*  Description     :   This i2c slave memory
*  Copyright(c)    :   2019 Vlasov D.V.
*/

package i2c_mem_slave_pkg;

    class i2c_mem_slave#(parameter chip_addr = 0, depth = 0);
    
        virtual i2c_if      i2c_vif;
    
        logic   [0 : 0]     wr_rd;
        logic   [7 : 0]     int_data;
        logic   [7 : 0]     mem_addr;
        logic   [7 : 0]     mem_data[];
    
        int                 bit_c;
        int                 sda_c;
        int                 scl_c;
    
        enum    { IDLE_s, PARS_CHIP_ADDR_s, PARS_MEM_ADDR_s, PARS_WRITE_DATA_s, START_s, START_R_s, DATA_s, STOP_s } state;
    
        function new(virtual i2c_if i2c_vif);
            mem_addr = '0;
            wr_rd = '0;
            this.i2c_vif = i2c_vif;
            mem_data = new[depth];
        endfunction : new
        
        task rec_data();
            i2c_vif.sda_drv = 'z;
            int_data = '0;
            wr_rd = '0;
            repeat(8)
            begin
                @(posedge i2c_vif.scl);
                do
                begin
                    @(posedge i2c_vif.clk);
                    sda_c += i2c_vif.sda_mon;
                    scl_c++;
                end
                while( i2c_vif.scl == '1 );
                if( ( sda_c ) > scl_c / 2 )
                    int_data = int_data | ( 1'b1 << ( 7 - bit_c ) );
                sda_c = '0;
                scl_c = '0;
                bit_c++;
            end
            bit_c = 0;
        endtask : rec_data
    
        task run();
            i2c_vif.sda_drv = 'z;
            @(posedge i2c_vif.resetn);
            forever
            begin
                case( state )
                    IDLE_s  :
                        begin
                            @(negedge i2c_vif.sda_mon);
                            if( i2c_vif.scl == '1 )
                            begin
                                state = PARS_CHIP_ADDR_s;
                                $display("");
                            end
                        end
                    PARS_CHIP_ADDR_s :
                        begin
                            rec_data();
                            $display("Chip addr = 0x%h, wr_rd = %b", int_data, wr_rd);
                            @(posedge i2c_vif.scl);
                            if( ( int_data & 8'hFE ) == chip_addr )
                            begin
                                state = PARS_MEM_ADDR_s;
                                i2c_vif.sda_drv = '0;
                            end
                            else
                            begin
                                state = IDLE_s;
                                i2c_vif.sda_drv = '1;
                            end
                            @(negedge i2c_vif.scl);
                            i2c_vif.sda_drv = 'z;
                        end
                    PARS_MEM_ADDR_s :
                        begin
                            rec_data();
                            $display("Memory addr = 0x%h, wr_rd = %b", int_data, wr_rd);
                            mem_addr = int_data;
                            @(posedge i2c_vif.scl);
                            if( int_data < depth )
                            begin
                                state = PARS_WRITE_DATA_s;
                                i2c_vif.sda_drv = '0;
                            end
                            else
                            begin
                                state = IDLE_s;
                                i2c_vif.sda_drv = '1;
                            end
                            @(negedge i2c_vif.scl);
                            i2c_vif.sda_drv = 'z;
                        end
                    PARS_WRITE_DATA_s :
                        begin
                            rec_data();
                            $display("Write data = 0x%h, wr_rd = %b", int_data, wr_rd);
                            mem_data[mem_addr] = int_data;
                            @(posedge i2c_vif.scl);
                            state = IDLE_s;
                            i2c_vif.sda_drv = '0;
                            @(negedge i2c_vif.scl);
                            i2c_vif.sda_drv = 'z;
                        end
                endcase
            end
        endtask : run
    
    endclass : i2c_mem_slave

endpackage : i2c_mem_slave_pkg
