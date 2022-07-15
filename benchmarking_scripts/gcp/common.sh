#!/bin/bash

#
# Translated AWS common functions to GCP idioms
#

# Not changed
function get_date_time(){
	hour=$(date +"%H")
	minute=$(date +"%M")
	second=$(date +"%S")
	time="${hour}_${minute}_${second}"
	date=$(date '+%Y_%m_%d')
	date_time="${date}_${time}"
	echo $date_time
}

# Not changed
function printHeader() {
	echo ""
	echo ""
	echo ""
	echo "$1. $2"
}

# Remove GCP project's firewall rules so that we can remove VPCs
function remove_project_filewall_rules() {
	# Remove firewall rules
	for firewall_rule in $(gcloud compute firewall-rules list --format="table[no-heading](name)")
	do
		gcloud compute firewall-rules delete $firewall_rule -q --verbosity=critical
	done	
	echo "Removed firewall rules from project $PROJECT_ID"
}

# Remove the "default" VPC that is created automatically when GCP projects are created
function remove_default_network() {
	gcloud compute networks delete default -q --verbosity=critical
	echo "Removed default network from project $PROJECT_ID"
}

# Remove the custom testing VPC and its subnet
function remove_test_network() {
	gcloud compute networks subnets delete $TEST_SUBNET -q --verbosity=critical
	gcloud compute networks delete $TEST_NETWORK -q --verbosity=critical
	echo "Removed testing network $TEST_NETWORK and subnetwork $TEST_SUBNET from project $PROJECT_ID"

}

# Create a custom VPC network and subnetwork for testing
function create_test_network() {
	gcloud compute networks create $TEST_NETWORK \
		--project=$PROJECT_ID \
		--description=Min.io\ performance\ test\ network \
		--subnet-mode=custom \
		--mtu=1460 \
		--bgp-routing-mode=regional \
		-q --verbosity=critical
	echo "Created network $TEST_NETWORK in project $PROJECT_ID"
	gcloud compute networks subnets create $TEST_SUBNET \
		--project=$PROJECT_ID \
		--description=Min.io\ performance\ testing\ subnetwork \
		--range=10.0.0.0/16 \
		--stack-type=IPV4_ONLY \
		--network=$TEST_NETWORK \
		--region=us-south1 \
		-q --verbosity=critical
	echo "Created subnetwork $TEST_SUBNET in project $PROJECT_ID"
}

# Create minimal set of Project firewall rules to run the tests
function create_firewall_rules() {
	gcloud compute firewall-rules create allow-ssh \
		--project=$PROJECT_ID \
		--direction=INGRESS \
		--priority=1000 \
		--network=$TEST_NETWORK \
		--action=ALLOW \
		--rules=tcp:22 \
		--source-ranges=0.0.0.0/0
	# Gcloud instance should ping another one
	# https://stackoverflow.com/questions/36918142/gcloud-instance-cant-ping-another-one
	gcloud compute firewall-rules create allow-icmp \
		--network=$TEST_NETWORK \
		--allow icmp
	# MinIO Server Requires Communication
	gcloud compute firewall-rules create allow-traffic \
		--project=$PROJECT_ID \
		--description=allow-traffic \
		--direction=INGRESS \
		--priority=1000 \
		--network=$TEST_NETWORK \
		--action=ALLOW \
		--rules=all
}

# Parameters:
#  1: instance identifier
function delete_instance() {
	gcloud compute instances delete $1 -q --verbosity=critical
	echo "Deleted VM $1"
}

# This is an example invocation
# Parameter #1 is instance ID
# Parameter #2 is command
function run_command_on_an_instance() {
	gcloud compute ssh "$1" --command='$2'
}

function create_instances() {
	# Helper function for the PHASE 1 where we create new instances
	printHeader $1 "Creating instances"
	vmcounter=$NAME_SUFFIX_START_NUMBER
	for((i=0;i<$NUMBER_OF_NODES; i++))
	do
    
	echo "Create instance with its boot disk"
	gcloud beta compute instances create "$NAME_PREFIX"-"$vmcounter" \
		--project=$PROJECT_ID \
		--zone=$ZONE \
		--machine-type=$MACHINE_TYPE \
		--network-interface=network-tier=PREMIUM,subnet=$TEST_SUBNET \
		--metadata=startup-script=echo\ \"foo\"$'\n' \
		--maintenance-policy=MIGRATE \
		--provisioning-model=STANDARD \
		--service-account=$SERVICE_ACCOUNT \
		--scopes=https://www.googleapis.com/auth/cloud-platform \
		--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220621,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring \
		--reservation-affinity=any \
		--threads-per-core=2 \
		--visible-core-count=1 \
		-q --verbosity=critical 

	# Wait for the SSHD service to start on the remote VM

	sleep 10

    # Capture /etc/fstab from current VM
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="cat /etc/fstab" > fstab
    

	echo "Create data disks"
	diskcounter=$DISK_SUFFIX_START_NUMBER
	for((j=0;j<$NUMBER_OF_DISKS; j++))
	do
	echo "Create disk"
	gcloud compute disks create "$DISK_NAME_PREFIX"-"$vmcounter"-"$diskcounter" \
		--zone=$ZONE \
		--size $DISK_SIZE \
		--type https://www.googleapis.com/compute/v1/projects/$PROJECT_ID/zones/$ZONE/diskTypes/$DISK_TYPE \
		-q --verbosity=critical

	echo "Attach disk"
	gcloud compute instances attach-disk "$NAME_PREFIX"-"$vmcounter" \
		--disk "$DISK_NAME_PREFIX"-"$vmcounter"-"$diskcounter" \
		--zone $ZONE \
		-q --verbosity=critical

	# Now that disks are created and attached, we need to mount for format them
	sleep 5 # Sometimes, the first disk fails, I have the theory that if we wait some time, then all disks will work below commands:
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/${DISK_DEVICE_NAMES[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mkdir -p /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mount -o discard,defaults /dev/${DISK_DEVICE_NAMES[j]} /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo chmod a+w /mnt/disks/${DISK_MOUNT_POINTS[j]}"

	echo "/dev/${DISK_DEVICE_NAMES[j]}  /mnt/disks/${DISK_MOUNT_POINTS[j]}   ext4   defaults  0 0" >> fstab

	diskcounter=$(( $diskcounter + 1 ))
	done

    gcloud compute scp fstab "$NAME_PREFIX"-"$vmcounter":~/fstab
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mv ~/fstab /etc/fstab"

	vmcounter=$(( $vmcounter + 1 ))
	done

	echo fstab
}

# Deletes all VMs in a Project
function delete_instances() {
	for vm in $(gcloud compute instances  list --format="table[no-heading](name)")
	do
		gcloud compute instances delete ${vm} -q --verbosity=critical
	done	
}

# Removes all disks in Project
function delete_disks() {
	for disk in $(gcloud compute disks  list --format="table[no-heading](name)")
	do
		gcloud compute disks delete ${disk} -q --verbosity=critical
	done	
}
