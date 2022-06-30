#!/bin/bash

source common.sh

# TEST_4_NODES
NUMBER_OF_NODES=4
NUMBER_OF_DISKS=5
INSTANCES=()
INSTANCE_TYPE=c6gn.16xlarge # (64-bit Arm)
AMI=ami-0b6705f88b1f688c1 # (64-bit Arm)
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-00fcb6381a1a6bf02
KEY_PAIRS=TESTING
COMMAND_RESULT=
SPEEDTEST_RESULT=

# TEST_8_NODES
NUMBER_OF_NODES=8
NUMBER_OF_DISKS=5
INSTANCES=()
INSTANCE_TYPE=c6gn.16xlarge # (64-bit Arm)
AMI=ami-0b6705f88b1f688c1 # (64-bit Arm)
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-00fcb6381a1a6bf02
KEY_PAIRS=TESTING
COMMAND_RESULT=
SPEEDTEST_RESULT=


# Step 0
kill_any_previous_instance 0

# Step 1
create_instances 1

# Step 2
wait_until_instances_are_ready_state 2

# Step 3
get_ips_from_instances
create_etc_hosts_file 3

# Step 4
put_etc_hosts_file_on_each_node 4

# Step 5
mount_and_format_disks 5

# Step 6
run_minio_distributed 6

# Step 7
make_sure_minio_is_running_on_each_node 7

# Step 8
set_mc_alias 8

# Step 9
run_speed_test 9

# Step 10
save_log_to_a_file 10

# Step 11
kill_any_previous_instance 11
