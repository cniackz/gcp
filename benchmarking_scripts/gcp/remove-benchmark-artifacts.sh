#!/bin/bash
#
# File: remove-benchmark-artifacts.sh
#
# Purpose: Remove all artifacts from the benchmark test
#
#

source common.sh
source test-configuration.sh


delete_instances

delete_disks

remove_project_filewall_rules

remove_test_network