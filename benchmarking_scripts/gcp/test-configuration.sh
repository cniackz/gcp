#!/bin/bash
#
# File: test-configuration.sh
#
# Purpose: Hold configuration information for tests and clean-up scripts
#
#

TEST_NETWORK=test-network
TEST_SUBNET=test-subnetwork
REGION=us-central1
ZONE=us-central1-a

NAME_PREFIX=min
NAME_SUFFIX_START_NUMBER=1
DISK_NAME_PREFIX=disk 
DISK_SUFFIX_START_NUMBER=1

MINIO_ADMIN_USER=minioadmin
MINIO_ADMIN_PASSWORD=minioadmin

# Select proper IOPS and avoid ERROR while creating disk, for example:
# 16 disks each 100,000 IOPS will hit quota limit.
# Create disk
# ERROR: (gcloud.compute.disks.create) Could not fetch resource:
# - Quota 'PD_EXTREME_TOTAL_PROVISIONED_IOPS' exceeded.  Limit: 900000.0 in region us-central1.
PROVISIONED_IOPS=50000
