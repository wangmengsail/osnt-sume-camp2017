#
# Copyright (c) 2017 University of Cambridge
# Copyright (c) 2017 Jong Hun Han
# All rights reserved.
#
# This software was developed by University of Cambridge Computer Laboratory
# under the ENDEAVOUR project (grant agreement 644960) as part of
# the European Union's Horizon 2020 research and innovation programme.
#
# @NETFPGA_LICENSE_HEADER_START@
#
# Licensed to NetFPGA Open Systems C.I.C. (NetFPGA) under one or more
# contributor license agreements. See the NOTICE file distributed with this
# work for additional information regarding copyright ownership. NetFPGA
# licenses this file to you under the NetFPGA Hardware-Software License,
# Version 1.0 (the License); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at:
#
# http://www.netfpga-cic.org
#
# Unless required by applicable law or agreed to in writing, Work distributed
# under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
# CONDITIONS OF ANY KIND, either express or implied. See the License for the
# specific language governing permissions and limitations under the License.
#
# @NETFPGA_LICENSE_HEADER_END@


# Set variables.
set design              osnt_sume_extmem_pcap_replay_engine
set ip_version          1.00
set ip_version_display  v1_00

# Call common setting for ips
source ../lib/osnt_ip_set_common.tcl

# Project setting.
create_project -name ${design} -force -dir "./${project_dir}" -part ${device} -ip

set_property source_mgmt_mode All [current_project]  
set_property top ${design} [current_fileset]

create_ip -name axis_dwidth_converter -vendor xilinx.com -library ip -version 1.1 -module_name fifo_conv_256to128_0 -dir ./${project_dir}
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {32} CONFIG.M_TDATA_NUM_BYTES {16} CONFIG.TUSER_BITS_PER_BYTE {8} CONFIG.HAS_TLAST {1} CONFIG.HAS_TKEEP {1}] [get_ips fifo_conv_256to128_0]
generate_target {instantiation_template} [get_files ./${project_dir}/fifo_conv_256to128_0/fifo_conv_256to128_0.xci]
generate_target all [get_files  ./${project_dir}/fifo_conv_256to128_0/fifo_conv_256to128_0.xci]

create_ip -name axis_dwidth_converter -vendor xilinx.com -library ip -version 1.1 -module_name fifo_conv_128to256_0 -dir ./${project_dir}
set_property -dict [list CONFIG.S_TDATA_NUM_BYTES {16} CONFIG.M_TDATA_NUM_BYTES {32} CONFIG.TUSER_BITS_PER_BYTE {8} CONFIG.HAS_TLAST {1} CONFIG.HAS_TKEEP {1}] [get_ips fifo_conv_128to256_0]
generate_target {instantiation_template} [get_files ./${project_dir}/fifo_conv_128to256_0/fifo_conv_128to256_0.xci]
generate_target all [get_files  ./${project_dir}/fifo_conv_128to256_0/fifo_conv_128to256_0.xci]

read_verilog "./hdl/verilog/osnt_sume_extmem_pcap_replay_engine.v"
read_verilog "./hdl/verilog/pre_pcap_mem_store.v"
read_verilog "./hdl/verilog/pcap_mem_store.v"
read_verilog "./hdl/verilog/pcap_mem_replay.v"
read_verilog "./../../../std/cores/osnt_sume_common/hdl/verilog/fallthrough_small_fifo.v"
read_verilog "./../../../std/cores/osnt_sume_common/hdl/verilog/small_fifo.v"

read_verilog "./../../../std/cores/osnt_sume_common/hdl/verilog/axi_lite_regs.v"
read_verilog "./../../../std/cores/osnt_sume_common/hdl/verilog/ipif_regs.v"
read_verilog "./../../../std/cores/osnt_sume_common/hdl/verilog/sume_axi_ipif.v"

update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

ipx::package_project

# Call common properties of ips
source ../lib/osnt_ip_property_common.tcl

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axi -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m0_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m1_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m2_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m3_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s_axis -of_objects [ipx::current_core]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m00_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m01_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m02_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces m03_axis -of_objects [ipx::current_core]]

ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s00_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s01_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s02_axis -of_objects [ipx::current_core]]
ipx::add_bus_parameter FREQ_HZ [ipx::get_bus_interfaces s03_axis -of_objects [ipx::current_core]]

ipx::infer_user_parameters [ipx::current_core]
ipx::check_integrity [ipx::current_core]
ipx::save_core [ipx::current_core]

close_project
exit

