
remove_design -all
set search_path "$search_path . ./verilog /w/apps2/public.2/tech/synopsys/32-28nm/SAED32_EDK/lib/stdcell_rvt/db_nldm" 
set target_library "saed32rvt_ff1p16vn40c.db saed32rvt_ss0p95v125c.db"
set link_library "* saed32rvt_ff1p16vn40c.db saed32rvt_ss0p95v125c.db dw_foundation.sldb"
set synthetic_library "dw_foundation.sldb"

#define_design_lib WORK -path ./WORK
set alib_library_analysis_path "./alib-52/"

analyze -format verilog {Image_Classifier.v}

set DESIGN_NAME Image_Classifier

elaborate $DESIGN_NAME

current_design $DESIGN_NAME
link

set_operating_conditions -min ff1p16vn40c -max ss0p95v125c
set TCLK 2.0
set TCU 0.1
set IN_DEL 0.6
set IN_DEL_MIN 0.3
set OUT_DEL 0.6
set OUT_DEL_MIN 0.3
set ALL_IN_BUT_CLK [remove_from_collection [all_inputs] "clk"]

create_clock -name "clk" -period $TCLK [get_ports "clk"]
set_fix_hold clk
set_dont_touch_network [get_clocks "clk"]
set_clock_uncertainty $TCU [get_clocks "clk"]

set_input_delay $IN_DEL -clock "clk" $ALL_IN_BUT_CLK
set_input_delay -min $IN_DEL_MIN -clock "clk" $ALL_IN_BUT_CLK
set_output_delay $OUT_DEL -clock "clk" [all_outputs]
set_output_delay -min $OUT_DEL_MIN -clock "clk" [all_outputs]

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
