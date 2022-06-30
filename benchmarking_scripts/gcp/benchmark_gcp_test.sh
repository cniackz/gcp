#!/bin/zsh
#
# File: benchmark_gcp_test.sh
#
# Purpose: Drive min.io performance testing and configuration management on GCP
#
#


source common.sh

# TEST_4_NODES
NUMBER_OF_NODES=4
NUMBER_OF_DISKS=4
INSTANCES=()
INSTANCE_TYPE=e2-medium
AMI=ami-0b6705f88b1f688c1 # (64-bit Arm)
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-00fcb6381a1a6bf02
KEY_PAIRS=TESTING
COMMAND_RESULT=
SPEEDTEST_RESULT=

# TEST_8_NODES
# NUMBER_OF_NODES=8
# NUMBER_OF_DISKS=4
# INSTANCES=()
# INSTANCE_TYPE=n2-highcpu-96
# AMI=ami-0b6705f88b1f688c1 # (64-bit Arm)
# TAG_KEY=test
# ETC_HOSTS=
# SECURITY_GROUP=sg-00fcb6381a1a6bf02
# KEY_PAIRS=TESTING
# COMMAND_RESULT=
# SPEEDTEST_RESULT=



# (rsk: 2022-06-30) 
#  A full cleanup of potential left over resources in GCP is left as an enhancement. 
#  For now we will presume the script runs to completion
#


# Step 0

# Remove firewall rules to eliminate network dependencies so we can remove VPCs
remove_project_filewall_rules

# Remove the default network in case it still exists
remove_default_network

# Remove the custom VPC created for testing
remove_test_network



# Step 1

# Create a custom VPC and subnetwork for the tests
create_test_network

# Create minimal set of firewall rules for the test
# (rsk: 2022-06-30)
#  Create SSH connection "allow" firewall rule
#  Others will be required when I understand the TCP / UDP connections between min.io servers and clients
create_firewall_rules


# Create the requested instances and the associated disks
# Disks are created, mounted and formatted to ext4 in this process
create_instances


# Step 0
#kill_previous_gcp_instance 0

# Step 1
#create_gcp_instance 1


# Step 5
#run_minio_distributed_in_gcp_instances 5

# Step 6
#make_sure_minio_is_running_on_each_gcp_node 6

# Step 7
#set_mc_alias_in_gcp_instance 7

# Step 8
#run_speed_test_on_gcp_instance 8

# Step 9
#kill_previous_gcp_instance 9

