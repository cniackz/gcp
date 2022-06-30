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
		--project=$PROJECT_ID  \
		--direction=INGRESS \
		--priority=1000 \
		--network=$TEST_NETWORK \
		--action=ALLOW \
		--rules=tcp:22 \
		--source-ranges=0.0.0.0/0
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
    
    # Create instance with its boot disk
	gcloud beta compute instances create "$NAME_PREFIX"-"$vmcounter" \
		--project=$PROJECT_ID \
		--zone=us-south1-a \
		--machine-type=$MACHINE_TYPE \
		--network-interface=network-tier=PREMIUM,subnet=$TEST_SUBNET \
		--metadata=startup-script=echo\ \"foo\"$'\n' \
		--maintenance-policy=MIGRATE \
		--provisioning-model=STANDARD \
		--service-account=580716829629-compute@developer.gserviceaccount.com \
		--scopes=https://www.googleapis.com/auth/cloud-platform \
		--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220621,mode=rw,size=10,type=projects/$PROJECT_ID/zones/us-central1-a/diskTypes/pd-balanced \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring \
		--reservation-affinity=any \
		--threads-per-core=2 \
		--visible-core-count=1 \
		-q --verbosity=critical 

    # Create data disks
    diskcounter=$DISK_SUFFIX_START_NUMBER
	for((j=0;j<$NUMBER_OF_DISKS; j++))
	do
	# Create disk
	gcloud compute disks create "$DISK_NAME_PREFIX"-"$vmcounter"-"$diskcounter" \
  		--size $DISK_SIZE \
  		--type https://www.googleapis.com/compute/v1/projects/$PROJECT_ID/zones/$ZONE/diskTypes/$DISK_TYPE \
  		-q --verbosity=critical

	# Attach disk
	gcloud compute instances attach-disk "$NAME_PREFIX"-"$vmcounter" \
  		--disk "$DISK_NAME_PREFIX"-"$vmcounter"-"$diskcounter" \
  		--zone $ZONE \
  		--device-name="sd""$diskcounter" \
  		-q --verbosity=critical

	# Now that disks are created and attached, we need to mount for format them

	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/${DISK_DEVICE_NAMES[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mkdir -p /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo mount -o discard,defaults /dev/${DISK_DEVICE_NAMES[j]} /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter" --command="sudo chmod a+w /mnt/disks/${DISK_MOUNT_POINTS[j]}"

    diskcounter=$(( $diskcounter + 1 ))
	done


    vmcounter=$(( $vmcounter + 1 ))
	done
}




