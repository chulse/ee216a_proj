
set hdlin_vrlg_std "2001"

remove_design -all
set search_path "$search_path . ./verilog /w/apps2/public.2/tech/synopsys/32-28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm" 
set target_library "saed32rvt_ff1p16vn40c.db saed32rvt_ss0p95v125c.db"
set link_library "* saed32rvt_ff1p16vn40c.db saed32rvt_ss0p95v125c.db dw_foundation.sldb"
set synthetic_library "dw_foundation.sldb"

#define_design_lib WORK -path ./WORK
set alib_library_analysis_path "./alib-52/"

analyze -format verilog {Image_Classifier.v}
analyze -format verilog {Neuron.v}
analyze -format verilog {Max_selector.v}
analyze -format verilog {PipelinedMultAccumulate.v}
analyze -format verilog {FixedPointMultiplier.v}

set DESIGN_NAME Image_Classifier

elaborate $DESIGN_NAME
elaborate Neuron
elaborate Max_selector
elaborate PipelinedMultAccumulate
elaborate FixedPointMultiplier

current_design $DESIGN_NAME

set_operating_conditions -min ff1p16vn40c -max ss0p95v125c
set TCLK 2.0
set TCU 0.1

create_clock -name "clk" -period $TCLK [get_ports "clk"]
set_fix_hold clk
set_dont_touch_network [get_clocks "clk"]
set_clock_uncertainty $TCU [get_clocks "clk"]

set_max_area 0.0
set_max_total_power 0.0

uniquify

compile -only_design_rule
compile -map high
compile -boundary_optimization
compile -only_hold_time


report_timing -path full -delay min -max_paths 10 -nworst 2 > holdtiming-SID
report_timing -path full -delay max -max_paths 10 -nworst 2 > setuptiming-SID
report_area -hierarchy > area-SID
report_power -hier -hier_level 2 > power-SID
report_resources > resources-SID
report_constraint -verbose > constraint-SID
check_design > check-design-SID
check_timing > timing-SID


write -hierarchy -format verilog -output $DESIGN_NAME.vg
write_sdf -version 1.0 -context verilog $DESIGN_NAME.sdf
set_propagated_clock [all_clocks]
write_sdc $DESIGN_NAME.sdc
