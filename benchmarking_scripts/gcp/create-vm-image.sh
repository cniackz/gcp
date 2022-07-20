#!/bin/bash
#
# File: create-vm-image.sh
#
# Purpose: Creates the VM image "minio-image" in the current project
#
#

source common.sh

ask_for_projectid

gcloud compute images delete minio-image -q --project=${PROJECT_ID}

gcloud compute images create minio-image \
  --source-image-family=debian-11 \
  --source-image-project=debian-cloud \
  --guest-os-features=GVNIC \
  --project=${PROJECT_ID} \
  -q
