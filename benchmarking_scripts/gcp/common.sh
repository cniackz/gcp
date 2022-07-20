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
		gcloud compute firewall-rules delete $firewall_rule -q 
	done	
	echo "Removed firewall rules from project $PROJECT_ID"
}

# Remove the "default" VPC that is created automatically when GCP projects are created
function remove_default_network() {
	gcloud compute networks delete default -q 
	echo "Removed default network from project $PROJECT_ID"
}

# Remove the custom testing VPC and its subnet
function remove_test_network() {
	gcloud compute networks subnets delete $TEST_SUBNET --region=${REGION} -q 
	gcloud compute networks delete $TEST_NETWORK -q 
	echo "Removed testing network $TEST_NETWORK and subnetwork $TEST_SUBNET from project $PROJECT_ID"

}

# Create a custom VPC network and subnetwork for testing
# NB: Note MTU is set to Jumbo Frames-8896-to see if that increases minio network performance
function create_test_network() {
	gcloud compute networks create $TEST_NETWORK \
		--project=$PROJECT_ID \
		--description=Min.io\ performance\ test\ network \
		--subnet-mode=custom \
		--mtu=8896 \
		--bgp-routing-mode=regional \
		-q 
		#--verbosity=critical
	
	echo "Created network $TEST_NETWORK in project $PROJECT_ID"
	
	gcloud compute networks subnets create $TEST_SUBNET \
		--project=$PROJECT_ID \
		--description=Min.io\ performance\ testing\ subnetwork \
		--range=10.0.0.0/16 \
		--stack-type=IPV4_ONLY \
		--network=$TEST_NETWORK \
		--region=${REGION} \
		-q 
		#--verbosity=critical
	
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
	gcloud compute ssh "$1" --command='$2' --zone=${ZONE}
}

function create_instances() {

	printHeader $1 "Creating instances"
	vmcounter=$NAME_SUFFIX_START_NUMBER
	for((i=0;i<$NUMBER_OF_NODES; i++))
	do
    
	echo "Create instance with its boot disk"
	gcloud beta compute instances create "$NAME_PREFIX"-"$vmcounter" \
		--project=$PROJECT_ID \
		--zone=$ZONE \
		--machine-type=$MACHINE_TYPE \
		--network-interface=network-tier=PREMIUM,nic-type=GVNIC,subnet=$TEST_SUBNET \
		--network-performance-configs=total-egress-bandwidth-tier=TIER_1 \
		--maintenance-policy=MIGRATE \
		--provisioning-model=STANDARD \
		--service-account=$SERVICE_ACCOUNT \
		--scopes=https://www.googleapis.com/auth/cloud-platform \
		--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=minio-image,mode=rw,size=10,type=projects/${PROJECT_ID}/zones/${ZONE}/diskTypes/pd-balanced \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring \
		--reservation-affinity=any \
		-q 
		# --verbosity=critical

#		--threads-per-core=2 \
#		--visible-core-count=1 \

	# Wait for the SSHD service to start on the remote VM

	sleep 10

    # Install utility that allows for the detection of the LAN driver
   	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo apt install lshw -y"

   	# Install utility that support network performance testing between VMs.
   	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo apt install iperf3 -y"


    # Capture /etc/fstab from current VM
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="cat /etc/fstab" > fstab
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo groupadd -r minio-user"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo useradd -M -r -g minio-user minio-user"
    
	echo "Create data disks"
	diskcounter=$DISK_SUFFIX_START_NUMBER
	for((j=0;j<$NUMBER_OF_DISKS; j++))
	do
	echo "Create disk"
	gcloud compute disks create "$DISK_NAME_PREFIX"-"$vmcounter"-"$diskcounter" \
		--zone=${ZONE} \
		--size=${DISK_SIZE} \
		--type=pd-extreme \
		--provisioned-iops=100000 \
		-q 
		#--verbosity=critical

	echo "Attach disk"
	gcloud compute instances attach-disk "$NAME_PREFIX"-"$vmcounter" \
		--disk "$DISK_NAME_PREFIX"-"$vmcounter"-"$diskcounter" \
		--zone $ZONE \
		-q --verbosity=critical

	# Now that disks are created and attached, we need to mount for format them
	sleep 20 # Sometimes, the first disk fails, I have the theory that if we wait some time, then all disks will work below commands:
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo mkfs.ext4 -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/${DISK_DEVICE_NAMES[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo mkdir -p /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo mount -o discard,defaults /dev/${DISK_DEVICE_NAMES[j]} /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo chmod a+w /mnt/disks/${DISK_MOUNT_POINTS[j]}"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo chown minio-user:minio-user /mnt/disks/${DISK_MOUNT_POINTS[j]}"

	echo "/dev/${DISK_DEVICE_NAMES[j]}  /mnt/disks/${DISK_MOUNT_POINTS[j]}   ext4   defaults  0 0" >> fstab

	diskcounter=$(( $diskcounter + 1 ))
	done

		# Install /etc/fstab
    gcloud compute scp  --zone=${ZONE} fstab "$NAME_PREFIX"-"$vmcounter":~/fstab
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo mv ~/fstab /etc/fstab"

	# Minio server configuration file
cat << _end_of_text > minio
MINIO_VOLUMES="http://min-{1...${NUMBER_OF_NODES}}/mnt/disks/disk{1...${NUMBER_OF_DISKS}}"
MINIO_OPTS="--console-address :9001"
MINIO_ROOT_USER=${MINIO_ADMIN_USER}
MINIO_ROOT_PASSWORD=${MINIO_ADMIN_PASSWORD}
MINIO_SERVER_URL="http://localhost:9000"
_end_of_text

	# Install min.io server software
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo apt-get update"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo apt install wget"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="wget https://dl.min.io/server/minio/release/linux-amd64/archive/minio_20220715034422.0.0_amd64.deb -O minio.deb"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo dpkg -i minio.deb"
    gcloud compute scp  --zone=${ZONE} minio "$NAME_PREFIX"-"$vmcounter":~/minio
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo mv ~/minio /etc/default/minio"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="curl https://dl.min.io/client/mc/release/linux-amd64/mc -o mc"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="chmod +x mc"
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo mv ~/mc /usr/local/bin/"


	vmcounter=$(( $vmcounter + 1 ))
	done

	# Now we go back and start minio service on each VM
	echo 'Starting minio service on each VM'
	vmcounter=$NAME_SUFFIX_START_NUMBER
	for((i=0;i<$NUMBER_OF_NODES; i++))
	do
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="sudo systemctl start minio.service"
	vmcounter=$(( $vmcounter + 1 ))
	done

	# Now we go back and set up "mc" for testing
	echo 'Setup mc on each computer with local for testing'
	vmcounter=$NAME_SUFFIX_START_NUMBER
	for((i=0;i<$NUMBER_OF_NODES; i++))
	do
	gcloud compute ssh "$NAME_PREFIX"-"$vmcounter"  --zone=${ZONE} --command="mc alias set local http://localhost:9000 ${MINIO_ADMIN_USER} ${MINIO_ADMIN_PASSWORD}"
	vmcounter=$(( $vmcounter + 1 ))
	done
}

# Deletes all VMs in a Project
function delete_instances() {
	for vm in $(gcloud compute instances  list --format="table[no-heading](name)")
	do
		gcloud compute instances delete ${vm} -q --zone=${ZONE} 
	done
}

# Removes all disks in Project
function delete_disks() {
	for disk in $(gcloud compute disks  list --format="table[no-heading](name)")
	do
		gcloud compute disks delete ${disk} --zone=${ZONE} -q 
	done	
}

# Finds the projectid
function ask_for_projectid() {
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

}

function ask_for_service_account() {

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

}

function ask_for_number_of_nodes() {


# TEST_X_NODES
echo "How many nodes do you need to test?:"
read NUMBER_OF_NODES
echo "NUMBER_OF_NODES: $NUMBER_OF_NODES"

}

function ask_for_number_of_disks() {
	echo "How many disks do you need to test with?:"
	read NUMBER_OF_DISKS
	echo "NUMBER_OF_DISKS: $NUMBER_OF_DISKS"
}

function ask_for_vm_machine_type() {
	echo "Please select a machine type from list below:"
	gcloud compute machine-types list --project=$PROJECT_ID --filter=zone=$ZONE | awk '{ print $1 }'
	read MACHINE_TYPE
	echo "MACHINE_TYPE: ${MACHINE_TYPE}"
}