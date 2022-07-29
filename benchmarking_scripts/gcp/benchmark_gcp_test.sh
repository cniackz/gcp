#!/bin/bash
#
# File: benchmark_gcp_test.sh
#
# Purpose: Drive min.io performance testing and configuration management on GCP
#
#

source common.sh
source test-configuration.sh


ask_for_projectid

ask_for_service_account

DISK_SIZE=1TB
# pd-ssd
# pd-standard
DISK_TYPE=pd-ssd
DISK_DEVICE_NAMES=(sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm)
DISK_MOUNT_POINTS=(disk1 disk2 disk3 disk4 disk5 disk6 disk7 disk8 disk9 disk10 disk11 disk12)

ask_for_number_of_nodes

ask_for_number_of_disks

ask_for_vm_machine_type

TAG_KEY=test
ETC_HOSTS=
KEY_PAIRS=TESTING
COMMAND_RESULT=
SPEEDTEST_RESULT=


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

# TODO: Then we can proceed to start the service

# TODO: Then we can run the speed test
