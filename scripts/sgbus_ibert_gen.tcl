# ----------------------------
# tcl init setting
# ----------------------------
# Startup timestamp (for log management)
set timestamp [clock format [clock seconds] -format "%Y%m%d_%H%M%S"]

# Parameterized input (command line override is supported.)）
if {[info exists ::env(VIVADO_PROJECT_DIR)]} {
    set origin_dir $::env(VIVADO_PROJECT_DIR)
} else {
    set origin_dir [file normalize [file dirname [info script]]]
}
set project_name "sbugs_ibert"
set part_name    "xcvu19p-fsva3824-2-e"  

# Directory structure definition
set src_dir     "$origin_dir/../sources/hdl"
set edf_dir     "$origin_dir/../sources/edif"
set inc_dir     "$origin_dir/../sources/inc"
set ip_dir      "$origin_dir/../sources/ip"
set xdc_dir     "$origin_dir/../constraints"
set sim_dir     "$origin_dir/../sources/sim"
set output_dir  "$origin_dir/output_$timestamp"
set log_file    "$output_dir/build.log"

# ----------------------------
# Environment precheck module
# ----------------------------
# Check the Vivado version
# if {![info exists ::env(VIVADO_VERSION)]} {
#     error "Must pass Vivado Tcl Shell execute this script"
# }

# Create an output directory and empty the history file
file mkdir $output_dir
if {[file exists $log_file]} {file delete -force $log_file}

# # Log redirection (record all outputs)
# redirect -tee -file $log_file { 
#     puts "The start time when the project was created: [clock format [clock seconds]]"
# }

# ----------------------------
# 文件验证模块
# ----------------------------
proc validate_path {path desc} {
    if {![file exists $path]} {
        error "$desc The path does not exist: $path"
    }
    if {![file readable $path]} {
        error "$desc the path does not readable: $path"
    }
}

validate_path $src_dir    "hdl"
validate_path $edf_dir    "edf"
validate_path $inc_dir    "inc"
validate_path $ip_dir     "ip"
validate_path $xdc_dir    "constraints"
validate_path $sim_dir    "sim"

# Collect design files (wildcards supported)
set hdl_files [glob -nocomplain -directory $src_dir *.v *.sv ]
set edf_files [glob -nocomplain -directory $edf_dir *.edf]
set inc_files [glob -nocomplain -directory $inc_dir *.vh *.h *.svh]
set ip_files  [glob -nocomplain -directory $ip_dir *.xci]
set xdc_files [glob -nocomplain -directory $xdc_dir *.xdc]
set sim_files [glob -nocomplain -directory $sim_dir *.v *.sv *.svh]

if {[llength $hdl_files] == 0} {
    error "HDL design file not found"
}

# ----------------------------
# The core process of project creation
# ----------------------------
# Mode selection（Project Mode or Non-Project Mode）
# 0=Non-Project，1=Project
set use_project_mode 1  

if {$use_project_mode} {
    # Project mode action flow
    create_project $project_name $output_dir -part $part_name -force
    set_property target_language Verilog [current_project]

    # Add a header file containing the path
    if {[llength $inc_files] > 0} {
        set_property include_dirs [file normalize $inc_dir] [current_fileset]
        puts "Added header file contains path: $inc_dir"
    }

    #  Add a design file
    add_files -norecurse $hdl_files
    add_files -fileset constrs_1 $xdc_files
    add_files -fileset sim_1 $sim_files

    # Add EDIF file
    read_edif $edf_files

    # IP setting
    set ip_path [file normalize "$origin_dir/../sources/ip/aurora_link.xci"]
    if {[file exists $ip_path]} {
        add_files -norecurse $ip_path
        update_ip_catalog -rebuild
        set_property generate_synth_checkpoint false [get_files $ip_path]
    }

    # Set synthesis and fulfillment strategies
    set_property strategy "Vivado Synthesis Defaults" [get_runs synth_1]
    set_property STEPS.SYNTH_DESIGN.ARGS.KEEP_EQUIVALENT_REGISTERS true [get_runs synth_1]
    set_property strategy "Vivado Implementation Defaults" [get_runs impl_1]
} else {
    # Non-project mode operation flow
    set_part $part_name
    read_verilog $hdl_files
    read_xdc     $xdc_files
    read_edif    $edf_files
    set_property include_dirs [file normalize $inc_dir] [current_design]
}

# ----------------------------
# Design process execution
# ----------------------------
if {$use_project_mode} {
    launch_runs synth_1 -jobs 4
    wait_on_run synth_1
    launch_runs impl_1 -jobs 4
    wait_on_run impl_1
    launch_runs impl_1 -to_step write_bitstream -jobs 4
} else {
    # Non-project mode manual process
    synth_design -top top_module -part $part_name
    opt_design
    place_design
    route_design
    write_bitstream -force "$output_dir/$project_name.bit"
}

# ----------------------------
# Output generation and reporting
# ----------------------------
# Critical report generation
report_timing_summary -file "$output_dir/timing_summary.rpt"
report_utilization -file "$output_dir/utilization.rpt"

# Save Checkpoint (for Debugging)
write_checkpoint -force "$output_dir/post_route.dcp"

# ----------------------------
# End processing
# ----------------------------
puts "The project has been created! Bitstream Path: $output_dir/$project_name.bit"
exit 0
