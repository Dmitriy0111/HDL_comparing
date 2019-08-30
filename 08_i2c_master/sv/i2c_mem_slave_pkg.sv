/*
*  File            :   i2c_mem_slave_pkg.sv
*  Autor           :   Vlasov D.V.
*  Data            :   2019.08.27
*  Language        :   SystemVerilog
*  Description     :   This is i2c slave memory
*  Copyright(c)    :   2019 Vlasov D.V.
*/

package i2c_mem_slave_pkg;

    class i2c_mem_slave#(parameter chip_addr = 0, depth = 0);
    
        virtual i2c_if      i2c_vif;
    
        logic   [0 : 0]     wr_rd;
        logic   [7 : 0]     int_data;
        logic   [7 : 0]     mem_addr;
        logic   [7 : 0]     mem_data[];

        enum                { WRITE_OP, READ_OP } op;
        
        int                 cycle;
    
        int                 bit_c;
        int                 sda_c;
        int                 scl_c;
    
        enum    { IDLE_s, PARS_CA_s, PARS_MA_s, PARS_WD_s, PARS_RD_s } state;
    
        function new(virtual i2c_if i2c_vif);
            mem_addr = '0;
            wr_rd = '0;
            this.i2c_vif = i2c_vif;
            op = WRITE_OP;
            cycle = '0;
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
            cycle++;
        endtask : rec_data

        task find_start();
            forever
            begin
                @(negedge i2c_vif.sda);
                    if( i2c_vif.scl == '1 )
                    begin
                        $display("I2C start detected at %tns", $time());
                        state = PARS_CA_s;
                    end
            end
        endtask : find_start

        task find_stop();
            forever
            begin
                @(posedge i2c_vif.sda);
                    if( i2c_vif.scl == '1 )
                        $display("I2C stop detected at %tns", $time());
            end
        endtask : find_stop

        task pars_chip_addr();
            forever
            begin
                wait(state == PARS_CA_s);
                rec_data();
                $display("Chip addr = 0x%h, wr_rd = %b", int_data, wr_rd);
                @(posedge i2c_vif.scl);
                if( ( int_data & 8'hFE ) == chip_addr )
                begin
                    state = PARS_MA_s;
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
        endtask : pars_chip_addr
            
        task pars_mem_addr();
            forever
            begin
                wait(state == PARS_MA_s);
                rec_data();
                $display("Mem addr = 0x%h, wr_rd = %b", int_data, wr_rd);
                @(posedge i2c_vif.scl);
                if( ( int_data & 8'hFE ) == chip_addr )
                begin
                    state = IDLE_s;
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
        endtask : pars_mem_addr
    
        task run();
            i2c_vif.sda_drv = 'z;
            @(posedge i2c_vif.resetn);
            fork
                find_start();
                pars_chip_addr();
                pars_mem_addr();
                find_stop();
            join_none
        endtask : run
    
    endclass : i2c_mem_slave

endpackage : i2c_mem_slave_pkg
