IVERILOG ?= iverilog
VVP ?= vvp
YOSYS ?= yosys
GTKWave ?= gtkwave

.PHONY: sim wave synth clean

sim:
	$(IVERILOG) -g2005 -o alu_sim rtl/alu_4bit.v tb/tb_alu_4bit.v
	$(VVP) alu_sim

wave:
	$(IVERILOG) -g2005 -o alu_sim -s tb_alu_4bit rtl/alu_4bit.v tb/tb_alu_4bit.v
	$(VVP) alu_sim
	$(GTKWave) alu.vcd

synth:
	$(YOSYS) -p "read_verilog rtl/alu_4bit.v; hierarchy -top alu_4bit; proc; opt; techmap; opt; stat"

clean:
	rm -f alu_sim alu.vcd
