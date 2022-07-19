#!/bin/bash
#
# File: benchmark_gcp_test.sh
#
# Purpose: Drive min.io performance testing and configuration management on GCP
#
#

source common.sh

# Each project is different for each organization.
# Let's ask project ID so that user can actually change on the fly when
# running the script
echo "Hello, what is your project id?:"
echo "1. daring-bit-354216"
echo "2. minio-benchmarking"
read response
if [ "$response" == "1" ]
then
	PROJECT_ID=daring-bit-354216
elif [ "$response" == "2" ]
then
	PROJECT_ID=minio-benchmarking
else
	# Default value when not provided
	PROJECT_ID=daring-bit-354216
fi
echo "PROJECT_ID is $PROJECT_ID"

# Each service account is different for each organization
# Let's ask for service account so that user can actually change on the fly
# when running the script
echo "what is your service account:"
echo "1. DoiT International: 580716829629-compute@developer.gserviceaccount.com"
echo "2. MinIO: 351135329924-compute@developer.gserviceaccount.com"
read response
if [ "$response" == "1" ]
then
	SERVICE_ACCOUNT="580716829629-compute@developer.gserviceaccount.com"
elif [ "$response" == "2" ]
then
	SERVICE_ACCOUNT="351135329924-compute@developer.gserviceaccount.com"
else
	# Default value:
	SERVICE_ACCOUNT="580716829629-compute@developer.gserviceaccount.com"
fi
echo "SERVICE_ACCOUNT: $SERVICE_ACCOUNT"

MINIO_ADMIN_USER=minioadmin
MINIO_ADMIN_PASSWORD=minioadmin
TEST_NETWORK=test-network
TEST_SUBNET=test-subnetwork
REGION=us-south1
ZONE=us-south1-a
TAG_KEY=
NAME_PREFIX=min
NAME_SUFFIX_START_NUMBER=1
DISK_NAME_PREFIX=disk 
DISK_SUFFIX_START_NUMBER=1
DISK_SIZE=10GB
# pd-ssd
# pd-standard
DISK_TYPE=pd-standard
DISK_DEVICE_NAMES=(sdb sdc sdd sde sdf sdg sdh sdi sdj sdk sdl sdm)
DISK_MOUNT_POINTS=(disk1 disk2 disk3 disk4 disk5 disk6 disk7 disk8 disk9 disk10 disk11 disk12)

# TEST_X_NODES
echo "How many nodes do you need to test?:"
read NUMBER_OF_NODES
echo "NUMBER_OF_NODES: $NUMBER_OF_NODES"
echo "How many disks do you need to test with?:"
read NUMBER_OF_DISKS
echo "NUMBER_OF_DISKS: $NUMBER_OF_DISKS"
echo "Please select a machine type from list below:"
gcloud compute machine-types list --project=$PROJECT_ID --filter=zone=$ZONE | awk '{ print $1 }'
read MACHINE_TYPE
echo "MACHINE_TYPE: ${MACHINE_TYPE}"
TAG_KEY=test
ETC_HOSTS=
KEY_PAIRS=TESTING
COMMAND_RESULT=
SPEEDTEST_RESULT=

# (rsk: 2022-06-30) 
#  A full cleanup of potential left over resources in GCP is left as an enhancement. 
#  For now we will presume the script runs to completion
# Remove firewall rules to eliminate network dependencies so we can remove VPCs
remove_project_filewall_rules

# Remove the default network in case it still exists
remove_default_network

# Remove the custom VPC created for testing
remove_test_network

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
