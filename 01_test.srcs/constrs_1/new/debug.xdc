

create_debug_core u_ila_0 ila
set_property ALL_PROBE_SAME_MU true [get_debug_cores u_ila_0]
set_property ALL_PROBE_SAME_MU_CNT 1 [get_debug_cores u_ila_0]
set_property C_ADV_TRIGGER false [get_debug_cores u_ila_0]
set_property C_DATA_DEPTH 1024 [get_debug_cores u_ila_0]
set_property C_EN_STRG_QUAL false [get_debug_cores u_ila_0]
set_property C_INPUT_PIPE_STAGES 0 [get_debug_cores u_ila_0]
set_property C_TRIGIN_EN false [get_debug_cores u_ila_0]
set_property C_TRIGOUT_EN false [get_debug_cores u_ila_0]
set_property port_width 1 [get_debug_ports u_ila_0/clk]
connect_debug_port u_ila_0/clk [get_nets [list hb_gtwiz_reset_clk_freerun_buf_int]]
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe0]
set_property port_width 16 [get_debug_ports u_ila_0/probe0]
connect_debug_port u_ila_0/probe0 [get_nets [list {drp_interface_lane0/errors[0]} {drp_interface_lane0/errors[1]} {drp_interface_lane0/errors[2]} {drp_interface_lane0/errors[3]} {drp_interface_lane0/errors[4]} {drp_interface_lane0/errors[5]} {drp_interface_lane0/errors[6]} {drp_interface_lane0/errors[7]} {drp_interface_lane0/errors[8]} {drp_interface_lane0/errors[9]} {drp_interface_lane0/errors[10]} {drp_interface_lane0/errors[11]} {drp_interface_lane0/errors[12]} {drp_interface_lane0/errors[13]} {drp_interface_lane0/errors[14]} {drp_interface_lane0/errors[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe1]
set_property port_width 16 [get_debug_ports u_ila_0/probe1]
connect_debug_port u_ila_0/probe1 [get_nets [list {drp_interface_lane0/samples[0]} {drp_interface_lane0/samples[1]} {drp_interface_lane0/samples[2]} {drp_interface_lane0/samples[3]} {drp_interface_lane0/samples[4]} {drp_interface_lane0/samples[5]} {drp_interface_lane0/samples[6]} {drp_interface_lane0/samples[7]} {drp_interface_lane0/samples[8]} {drp_interface_lane0/samples[9]} {drp_interface_lane0/samples[10]} {drp_interface_lane0/samples[11]} {drp_interface_lane0/samples[12]} {drp_interface_lane0/samples[13]} {drp_interface_lane0/samples[14]} {drp_interface_lane0/samples[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe2]
set_property port_width 3 [get_debug_ports u_ila_0/probe2]
connect_debug_port u_ila_0/probe2 [get_nets [list {drp_interface_lane0/drp_reg_t[error_cnt][0]} {drp_interface_lane0/drp_reg_t[error_cnt][1]} {drp_interface_lane0/drp_reg_t[error_cnt][2]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe3]
set_property port_width 10 [get_debug_ports u_ila_0/probe3]
connect_debug_port u_ila_0/probe3 [get_nets [list {drpaddr_int[0]} {drpaddr_int[1]} {drpaddr_int[2]} {drpaddr_int[3]} {drpaddr_int[4]} {drpaddr_int[5]} {drpaddr_int[6]} {drpaddr_int[7]} {drpaddr_int[8]} {drpaddr_int[9]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe4]
set_property port_width 16 [get_debug_ports u_ila_0/probe4]
connect_debug_port u_ila_0/probe4 [get_nets [list {drpdi_int[0]} {drpdi_int[1]} {drpdi_int[2]} {drpdi_int[3]} {drpdi_int[4]} {drpdi_int[5]} {drpdi_int[6]} {drpdi_int[7]} {drpdi_int[8]} {drpdi_int[9]} {drpdi_int[10]} {drpdi_int[11]} {drpdi_int[12]} {drpdi_int[13]} {drpdi_int[14]} {drpdi_int[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe5]
set_property port_width 16 [get_debug_ports u_ila_0/probe5]
connect_debug_port u_ila_0/probe5 [get_nets [list {drpdo_int[0]} {drpdo_int[1]} {drpdo_int[2]} {drpdo_int[3]} {drpdo_int[4]} {drpdo_int[5]} {drpdo_int[6]} {drpdo_int[7]} {drpdo_int[8]} {drpdo_int[9]} {drpdo_int[10]} {drpdo_int[11]} {drpdo_int[12]} {drpdo_int[13]} {drpdo_int[14]} {drpdo_int[15]}]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe6]
set_property port_width 1 [get_debug_ports u_ila_0/probe6]
connect_debug_port u_ila_0/probe6 [get_nets [list drpen_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe7]
set_property port_width 1 [get_debug_ports u_ila_0/probe7]
connect_debug_port u_ila_0/probe7 [get_nets [list drprdy_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe8]
set_property port_width 1 [get_debug_ports u_ila_0/probe8]
connect_debug_port u_ila_0/probe8 [get_nets [list drpwe_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe9]
set_property port_width 1 [get_debug_ports u_ila_0/probe9]
connect_debug_port u_ila_0/probe9 [get_nets [list eyescanreset_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe10]
set_property port_width 1 [get_debug_ports u_ila_0/probe10]
connect_debug_port u_ila_0/probe10 [get_nets [list hb_gtwiz_reset_all_int]]
create_debug_port u_ila_0 probe
set_property PROBE_TYPE DATA_AND_TRIGGER [get_debug_ports u_ila_0/probe11]
set_property port_width 1 [get_debug_ports u_ila_0/probe11]
connect_debug_port u_ila_0/probe11 [get_nets [list trigger_int]]
set_property C_CLK_INPUT_FREQ_HZ 300000000 [get_debug_cores dbg_hub]
set_property C_ENABLE_CLK_DIVIDER false [get_debug_cores dbg_hub]
set_property C_USER_SCAN_CHAIN 1 [get_debug_cores dbg_hub]
connect_debug_port dbg_hub/clk [get_nets hb_gtwiz_reset_clk_freerun_buf_int]
