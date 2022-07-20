#!/bin/bash
#
# File: clean-project.sh
#
# Purpose: Remove all default project artifacts
#
#

source common.sh
source test-configuration.sh

ask_for_projectid
ask_for_service_account

remove_project_filewall_rules
remove_default_network

gcloud compute images delete minio-image