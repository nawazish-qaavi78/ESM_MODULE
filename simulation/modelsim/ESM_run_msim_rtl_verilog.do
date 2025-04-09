transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/ESM.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/InstructionBuffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/ESM_Core.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/ESM_Core_IDA.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/IRT.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/IDT.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/BufferValidator.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/ESM_Core_IIM.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/CandidateList.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/MappingTable.v}
vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/components/PRNG.v}

vlog -vlog01compat -work work +incdir+C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/.test {C:/Users/nawaz/OneDrive/Desktop/programing/verilog/ESM_MODULE/ESM_MODULE/.test/tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb

add wave *
view structure
view signals
run -all
