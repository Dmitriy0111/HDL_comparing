
help:
	$(info make help           - show this message)
	$(info make clean          - delete synth and simulation folders)
	$(info make sim            - the same as sim_gui)
	$(info make synth          - clean, create the board project and run the synthesis (for default board))
	$(info make open           - the same as synth_gui)
	$(info make load           - the same as synth_load)
	$(info make sim_cmd        - run simulation in Modelsim (console mode))
	$(info make sim_gui        - run simulation in Modelsim (gui mode))
	$(info make synth_create   - create the board project)
	$(info make synth_build_q  - build the board project with quartus)
	$(info make synth_gui_q    - open the board project with quartus)
	$(info make synth_load_q   - program the default FPGA board with quartus)
	$(info make board_all      - run synthesis for all the supported boards)
	$(info Open and read the Makefile for details)
	@true

PWD     := $(shell pwd)

RUN_DIR := $(PWD)/run

########################################################
# common make targets

show_pwd:
	PWD

clean: \
	sim_clean 

sim_all: \
	sim_cmd 

sim: sim_gui

########################################################
# simulation - Modelsim

VSIM_DIR = $(PWD)/sim_modelsim

VLIB_BIN = cd $(VSIM_DIR) && vlib
VLOG_BIN = cd $(VSIM_DIR) && vlog
VSIM_BIN = cd $(VSIM_DIR) && vsim

VSIM_OPT_COMMON += 

VSIM_OPT_CMD     = -c
VSIM_OPT_CMD    += -onfinish exit

VSIM_OPT_GUI     = -gui -onfinish stop

sim_cmd_verilog:
	$(VSIM_BIN) $(VSIM_OPT_COMMON) $(VSIM_OPT_CMD)

sim_gui_verilog:
	$(VSIM_BIN) -do $(RUN_DIR)/script_modelsim_v.tcl -onfinish final $(VSIM_OPT_GUI) &

sim_gui_systemverilog:
	$(VSIM_BIN) -do $(RUN_DIR)/script_modelsim_sv.tcl -onfinish final $(VSIM_OPT_GUI) &

sim_gui_vhdl:
	$(VSIM_BIN) -do $(RUN_DIR)/script_modelsim_vhdl.tcl -onfinish final $(VSIM_OPT_GUI) &
