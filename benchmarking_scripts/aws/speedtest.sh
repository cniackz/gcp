#!/bin/bash

source common.sh

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

# TEST_16_NODES_x4
NUMBER_OF_NODES=16
NUMBER_OF_DISKS=4
INSTANCES=()
INSTANCE_TYPE=c6gn.16xlarge # (64-bit Arm)
AMI=ami-0b6705f88b1f688c1 # (64-bit Arm)
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-00fcb6381a1a6bf02
KEY_PAIRS=TESTING
COMMAND_RESULT=
SPEEDTEST_RESULT=

# 4 NODES WITH 16 DISKS
# 16TiB of space or size per disk of sc1 type
# the max throughput is 250 MiB for those disks, let's start testing with
# automation and see if this test works.
# but first, let's see the UI to see if I got the proper specifications right.
# IOPS does not apply, removing that from the mapping
# Throughput is fixed, cant be specified.
NUMBER_OF_NODES=4
NUMBER_OF_DISKS=16
INSTANCES=()
INSTANCE_TYPE=c6gn.16xlarge # (64-bit Arm)
AMI=ami-0d3907809e0f70e5d # (64-bit Arm) oregon region where the quota was increased.
aws configure set region us-west-2
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-016cc74378a9c0d40 # oregon region
KEY_PAIRS=TESTING_oregon
COMMAND_RESULT=
SPEEDTEST_RESULT=
MAPPING_FILE=mapping_16_sc1.json

# PENDING - 8 nodos, 16 discos por nodo, 16TiB por disco, sc1 disks - 250 MB/s throughput (IOPS N/A)
# 8 NODES WITH 16 DISKS
# 16TiB of space or size per disk of sc1 type
# the max throughput is 250 MiB for those disks, let's start testing with
# automation and see if this test works.
# but first, let's see the UI to see if I got the proper specifications right.
# IOPS does not apply, removing that from the mapping
# Throughput is fixed, cant be specified.
NUMBER_OF_NODES=8
NUMBER_OF_DISKS=16
INSTANCES=()
INSTANCE_TYPE=c6gn.16xlarge # (64-bit Arm)
AMI=ami-0d3907809e0f70e5d # (64-bit Arm) oregon region where the quota was increased.
aws configure set region us-west-2
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-016cc74378a9c0d40 # oregon region
KEY_PAIRS=TESTING_oregon
COMMAND_RESULT=
SPEEDTEST_RESULT=
MAPPING_FILE=mapping_16_sc1.json

# TEST_4_NODES WITH 5 disks
NUMBER_OF_NODES=4
NUMBER_OF_DISKS=5
INSTANCES=()
INSTANCE_TYPE=c6gn.16xlarge # (64-bit Arm)
AMI=ami-0b6705f88b1f688c1 # (64-bit Arm)
AMI=ami-0d3907809e0f70e5d # (64-bit Arm) oregon region where the quota was increased.
TAG_KEY=test
ETC_HOSTS=
SECURITY_GROUP=sg-00fcb6381a1a6bf02
SECURITY_GROUP=sg-016cc74378a9c0d40 # oregon region
KEY_PAIRS=TESTING
KEY_PAIRS=TESTING_oregon
COMMAND_RESULT=
SPEEDTEST_RESULT=
MAPPING_FILE=mapping_5_gp3.json

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

exit

# Step 11
kill_any_previous_instance 11
