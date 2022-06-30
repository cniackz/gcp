#!/bin/zsh

function get_date_time(){
	hour=$(date +"%H")
	minute=$(date +"%M")
	second=$(date +"%S")
	time="${hour}_${minute}_${second}"
	date=$(date '+%Y_%m_%d')
	date_time="${date}_${time}"
	echo $date_time
}

function printHeader() {
	echo "#################################################"
	for i in {1..10}
	do
		echo " "
	done
	echo "$1. $2"
	for i in {1..10}
	do
		echo " "
	done
	echo "#################################################"
}

function run_command_on_an_instance() {
	# To run a command a on single instance.
	echo "running command on instance: $1"
	dns_name=$(aws ec2 describe-instances \
		--instance-ids $1 \
		--query "Reservations[*].Instances[*].PublicDnsName" \
		| jq ".[0][0]" | \
		tr -d '"')
	cmd="ssh -o StrictHostKeyChecking=no -i ${KEY_PAIRS}.pem ec2-user@${dns_name} \"$2\" $3"
	echo "command to run: $cmd"
	if [ "$4" = save ]; then
		COMMAND_RESULT=`eval $cmd`
	else	
		eval $cmd > /dev/null 2>&1
	fi
}

function run_command_on_instances() {
	# Helper function to send/run command on a given instance
	COMMAND_RESULT= # Cleaning up
	for instance_id in "${INSTANCES[@]}"
	do
		run_command_on_an_instance $instance_id "$1" "$2" $3
	done
}

function run_speed_test() {
	# Helper function to run speed test
	printHeader $1 "Run Speed Test"
	# To run speed test only once in the first instance:
	run_command_on_an_instance "${INSTANCES[0]}" "sudo mc admin speedtest myminio --json" "" save
	SPEEDTEST_RESULT=($COMMAND_RESULT) # This one split the lines I got while speed test is running
	stringarray=($COMMAND_RESULT) # This one split the lines I got while speed test is running
	for i in "${stringarray[@]}"
	do
		echo ""
		echo "PUTStats:"
		echo $i | jq ".PUTStats"
		echo "GETStats:"
		echo $i | jq ".GETStats"
		echo ""
	done
}

function set_mc_alias() {
	# Helper function to set mc alias
	printHeader $1 "Set MinIO Client Alias"
	run_command_on_instances "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" "" save
	echo $COMMAND_RESULT
}

function mount_and_format_disks() {
	# Helper function provided by Daniel that works really well
	# It will mount and format the disks for MinIO distributed.
	printHeader $1 "Mount and format disks"
	run_command_on_instances "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh"
}

function run_minio_distributed() {
	# Helper function to run minio in distributed mode across the nodes.
	# amperson to run in back ground mode to be able to run all processes in parallel
	printHeader $1 "Run MinIO in distributed mode"
	run_command_on_instances "sudo minio server http://host{1...$NUMBER_OF_NODES}/disk{1...$NUMBER_OF_DISKS}" "&"
}

function put_etc_hosts_file_on_each_node() {
	printHeader $1 "Put /etc/hosts file on each node..."
	counter=$NUMBER_OF_MACHINES
	for instance_id in "${INSTANCES[@]}"
	do
		dns_name=$(aws ec2 describe-instances \
			--instance-ids $instance_id \
			--query "Reservations[*].Instances[*].PublicDnsName" \
			| jq ".[0][0]" | \
			tr -d '"')
		file_from=hosts.sh
		file_to=ec2-user@${dns_name}:/home/ec2-user/hosts
		files="${file_from} ${file_to}"
		cmd="scp -o StrictHostKeyChecking=no -i ${KEY_PAIRS}.pem ${files}"
		echo "Command to run: ${cmd}"
		eval $cmd
	done
}

function put_etc_warp_hosts_file_on_each_node() {
	printHeader $1 "Put /etc/hosts file on each node..."
	counter=$NUMBER_OF_MACHINES
	for instance_id in "${WARP_INSTANCES[@]}"
	do
		dns_name=$(aws ec2 describe-instances \
			--instance-ids $instance_id \
			--query "Reservations[*].Instances[*].PublicDnsName" \
			| jq ".[0][0]" | \
			tr -d '"')
		file_from=warp_hosts.sh
		file_to=ec2-user@${dns_name}:/home/ec2-user/hosts
		files="${file_from} ${file_to}"
		cmd="scp -o StrictHostKeyChecking=no -i ${KEY_PAIRS}.pem ${files}"
		echo "Command to run: ${cmd}"
		eval $cmd
	done
}

function create_etc_hosts_file() {
	# To create the chunk of /etc/hosts file needed to ping nodes between each
	# other
	printHeader $1 "Creating the /etc/hosts file:"
	echo "ETC_HOSTS = ${ETC_HOSTS}"
	stringarray=($ETC_HOSTS)
	counter=1
	echo "" > hosts.sh # to clean the file, and start with clean file
	echo '127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4' >> hosts.sh
	echo '::1         localhost6 localhost6.localdomain6' >> hosts.sh
	for i in "${stringarray[@]}"
	do
		echo "${i} host${counter}"
		echo "${i} host${counter}" >> hosts.sh
		let counter++
	done
}

function get_ips_from_instances() {
	# Helper function to get the IPs from the instances
	ETC_HOSTS=$(aws ec2 describe-instances \
	--filters Name=tag-key,Values=$TAG_KEY Name=instance-state-name,Values=running \
	--query 'Reservations[*].Instances[*].PrivateIpAddress' \
	--output text)
	echo "ETC_HOSTS = ${ETC_HOSTS}"
}

# To get a running gcp instance
# echo null when there are no more instances to retrieve
function get_running_gcp_instance_name() {
	INDEX=$1
	RESULT=$(gcloud compute instances list --format=json | jq '.['$INDEX'].name' | tr -d '"')
	echo $RESULT
}

# To get the zone of the running instance
function get_zone_gcp_instance() {
	INDEX=$1
	RESULT=$(gcloud compute instances list --format=json | jq '.['$INDEX'].zone' | tr -d '"' | awk -F/ '{print $9}')
	echo $RESULT
}

function get_project_gcp_instance() {
	INDEX=$1
	RESULT=$(gcloud compute instances list --format=json | jq '.['$INDEX'].zone' | tr -d '"' | awk -F/ '{print $7}')
	echo $RESULT
}

function get_running_instances_by_tag() {
	# To get all running instance by tag
	aws ec2 describe-instances \
	--filters Name=tag-key,Values=$TAG_KEY Name=instance-state-name,Values=running \
	--query 'Reservations[*].Instances[*].InstanceId' \
	--output text
}

function terminate_instances() {
	# To terminate all instances by id
	msg=$(aws ec2 terminate-instances --instance-ids $@ \
	--query 'TerminatingInstances[*].InstanceId' \
	--output text)
	# To print beautifully the instances to kill
	stringarray=($msg)
	for i in "${stringarray[@]}"
	do
		echo $i
	done
}

function kill_any_previous_instance(){
	# To kill any previous instance and save money after test is done.
	printHeader $1 "kill any previous instance created with our tag ${TAG_KEY}"
	instances=$(get_running_instances_by_tag)
	echo "instances to kill:"
	if [ -z "$instances" ]; then
		echo "nothing to terminate"
	else
		terminate_instances $instances
	fi
}

function kill_any_previous_gcp_process() {
	PID=$(ps aux | grep 'google_metadata_script_runner' | awk -F' ' '{print $2}')
	while IFS= read -r line ;
	do
		echo "PID: $line";
		kill $line
	done <<< "$PID"	
}

function kill_previous_gcp_instance(){
	kill_any_previous_gcp_process
	STEP_NUMBER=$1
	printHeader $STEP_NUMBER "kill_previous_gcp_instance():"
	while true
	do
		INSTANCE_NAME=$(get_running_gcp_instance_name 0)
		ZONE_NAME=$(get_zone_gcp_instance 0)
		echo "instance to kill: $INSTANCE_NAME"
		if [[ $INSTANCE_NAME == null ]]
		then
			echo "nothing to terminate, ending the loop!"
			break
		else
			terminate_gcp_instances $INSTANCE_NAME $ZONE_NAME
		fi
	done
}

function terminate_gcp_instances(){
	echo "Terminate Google Cloud Instance"
	INSTANCE_NAME=$1
	ZONE=$2
	gcloud compute instances delete $INSTANCE_NAME --zone $ZONE --quiet
}

function create_instances() {
	# Helper function for the PHASE 1 where we create new instances
	printHeader $1 "Creating instances"
	counter=1
	for (( value = 0; value < $NUMBER_OF_NODES; value++ ));
	do
		instance_id=$(aws ec2 run-instances --image-id $AMI \
			--instance-type $INSTANCE_TYPE --key-name $KEY_PAIRS \
			--block-device-mappings file://$MAPPING_FILE \
			--user-data file://my_script.txt \
			--security-group-ids $SECURITY_GROUP \
			--tag-specifications 'ResourceType=instance,Tags=[{Key=test,Value=benchmark}]' | \
					jq ".Instances[0].InstanceId" | tr -d '"')
		echo "${counter}: instance_id: ${instance_id}"
		let counter++
		INSTANCES+=($instance_id)
	done
}

function create_gcp_instance(){
	printHeader $1 "create_gcp_instance():"
	for (( value = 0; value < $NUMBER_OF_NODES; value++ ));
	do
		gcloud compute instances create cesar-testing-$value \
		--project=minio-benchmarking \
		--zone=us-central1-a --machine-type $INSTANCE_TYPE \
		--network-interface=network-tier=PREMIUM,subnet=default \
		--maintenance-policy=MIGRATE --provisioning-model=STANDARD \
		--service-account=351135329924-compute@developer.gserviceaccount.com \
		--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
		--enable-display-device \
		--create-disk=auto-delete=yes,boot=yes,device-name=cesar-testing-$value,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220621,mode=rw,size=10,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=device-name=disk-1,mode=rw,name=disk-$value-1,size=100,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=device-name=disk-2,mode=rw,name=disk-$value-2,size=100,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=device-name=disk-3,mode=rw,name=disk-$value-3,size=100,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=device-name=disk-4,mode=rw,name=disk-$value-4,size=100,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--no-shielded-secure-boot --shielded-vtpm --shielded-integrity-monitoring \
		--reservation-affinity=any
		echo "${counter}: instance_id: ${instance_id}"
		let counter++
		INSTANCES+=($instance_id)
	done
}

function create_gcp_instance_2(){
	SIZE=2560 # GB because Limit: 81920.0 in region us-central1.
	printHeader $1 "create_gcp_instance():"
	for (( value = 0; value < $NUMBER_OF_NODES; value++ ));
	do
		gcloud compute instances create instance-1-$value \
		--project=minio-benchmarking \
		--zone=us-central1-a \
		--machine-type=t2d-standard-60 \
		--network-interface=network-tier=PREMIUM,nic-type=GVNIC,subnet=default \
		--maintenance-policy=MIGRATE \
		--provisioning-model=STANDARD \
		--service-account=351135329924-compute@developer.gserviceaccount.com \
		--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
		--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220621,mode=rw,size=10,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-1,mode=rw,name=disk-$value-1,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-2,mode=rw,name=disk-$value-2,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-3,mode=rw,name=disk-$value-3,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-4,mode=rw,name=disk-$value-4,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring \
		--reservation-affinity=any
		echo "${counter}: instance_id: ${instance_id}"
		let counter++
		INSTANCES+=($instance_id)
	done
}

function create_gcp_instance_3(){
	SIZE=2480 # GB because Limit: 81920.0 in region us-central1.
	printHeader $1 "create_gcp_instance():"
	for (( value = 0; value < $NUMBER_OF_NODES; value++ ));
	do
		gcloud compute instances create instance-1-$value \
		--project=minio-benchmarking \
		--zone=us-central1-a \
		--machine-type=t2d-standard-16 \
		--network-interface=network-tier=PREMIUM,nic-type=GVNIC,subnet=default \
		--maintenance-policy=MIGRATE \
		--provisioning-model=STANDARD \
		--service-account=351135329924-compute@developer.gserviceaccount.com \
		--scopes=https://www.googleapis.com/auth/devstorage.read_only,https://www.googleapis.com/auth/logging.write,https://www.googleapis.com/auth/monitoring.write,https://www.googleapis.com/auth/servicecontrol,https://www.googleapis.com/auth/service.management.readonly,https://www.googleapis.com/auth/trace.append \
		--create-disk=auto-delete=yes,boot=yes,device-name=instance-1,image=projects/debian-cloud/global/images/debian-11-bullseye-v20220621,mode=rw,size=10,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-1,mode=rw,name=disk-$value-1,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-2,mode=rw,name=disk-$value-2,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-3,mode=rw,name=disk-$value-3,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--create-disk=auto-delete=yes,device-name=disk-4,mode=rw,name=disk-$value-4,size=$SIZE,type=projects/minio-benchmarking/zones/us-central1-a/diskTypes/pd-balanced \
		--no-shielded-secure-boot \
		--shielded-vtpm \
		--shielded-integrity-monitoring \
		--reservation-affinity=any
		echo "${counter}: instance_id: ${instance_id}"
		let counter++
		INSTANCES+=($instance_id)
	done
}

function wait_until_instances_are_ready_state(){
	# helper function to wait until the instances are ready to be used
	printHeader $1 "Check the status of the instances to be running state"
	counter=$NUMBER_OF_NODES
	while [ $counter -gt 0 ]
	do
		counter=$NUMBER_OF_NODES
		for instance_id in "${INSTANCES[@]}"
		do
			state=$(aws ec2 describe-instance-status \
				--instance-ids $instance_id \
				| jq ".InstanceStatuses[0].InstanceState.Name")
			echo "instance: ${instance_id}, Instance state: ${state}"
			InstanceStatus=$(aws ec2 describe-instance-status \
				--instance-ids $instance_id \
				| jq ".InstanceStatuses[0].InstanceStatus.Status")
			echo "instance: ${instance_id}, Status check: ${InstanceStatus}"
			if [ "$state" = '"running"' ]; then
				if [ "$InstanceStatus" = '"ok"' ]; then
					counter=$(( $counter - 1 ))
				fi
			fi
		done
		sleep 5
	done
}

function make_sure_minio_is_running_on_each_node(){
	# Helper function to see if MinIO Server is running on each node
	printHeader $1 "Making sure MinIO is running on each node"
	run_command_on_instances "sudo ps aux | grep minio" "" save
	echo $COMMAND_RESULT
}

function save_log_to_a_file(){
	# Helper function to save log to a file
	echo "" > speed_test_result.json # to start a new file, don't append here
	echo "NUMBER_OF_NODES = ${NUMBER_OF_NODES}" >> speed_test_result.json
	echo "INSTANCE_TYPE = ${INSTANCE_TYPE}" >> speed_test_result.json
	echo "AMI = ${AMI}" >> speed_test_result.json
	echo "TAG_KEY = ${TAG_KEY}" >> speed_test_result.json
	echo "SECURITY_GROUP = ${SECURITY_GROUP}" >> speed_test_result.json
	echo "KEY_PAIRS = ${KEY_PAIRS}" >> speed_test_result.json
	echo "" >> speed_test_result.json
	echo "Storage Info:" >> speed_test_result.json
	cat mapping.json >> speed_test_result.json
	echo "" >> speed_test_result.json
	echo "Speed test result:" >> speed_test_result.json
	for i in "${SPEEDTEST_RESULT[@]}"
	do
		echo "" >> speed_test_result.json
		echo "PUTStats:" >> speed_test_result.json
		echo $i | jq ".PUTStats" >> speed_test_result.json
		echo "GETStats:" >> speed_test_result.json
		echo $i | jq ".PUTStats" >> speed_test_result.json
		echo "" >> speed_test_result.json
	done
	# Copy the temp file to permanent folder
	file_name=$(get_date_time)
	file_name="${file_name}.log"
	printHeader $1 "Saving log to a file: ${file_name}"
	cp speed_test_result.json logs/$file_name
}

function create_warp_instances() {
	# Helper function for the PHASE 2 where we create wrap instances
	printHeader $1 "Creating wrap instances"
	counter=1
	for (( value=0; value < $NUMBER_OF_NODES; value++ ));
	do
		instance_id=$(aws ec2 run-instances --image-id $AMI \
			--instance-type $INSTANCE_TYPE --key-name $KEY_PAIRS \
			--user-data file://my_warp.txt \
			--security-group-ids $SECURITY_GROUP \
			--tag-specifications 'ResourceType=instance,Tags=[{Key=warp,Value=benchmark}]' | \
					jq ".Instances[0].InstanceId" | tr -d '"')
		echo "${counter}: instance_id: ${instance_id}"
		let counter++
		WARP_INSTANCES+=($instance_id)
	done
}

function get_ips_from_warp_instances() {
	# Helper function to get the IPs from the instances
	ETC_WARP_HOSTS=$(aws ec2 describe-instances \
	--filters Name=tag-key,Values=warp Name=instance-state-name,Values=running \
	--query 'Reservations[*].Instances[*].PrivateIpAddress' \
	--output text)
	echo "ETC_WARP_HOSTS = ${ETC_WARP_HOSTS}"
}

function create_warp_etc_hosts_file() {
	printHeader $1 "Creating the /etc/hosts file:"
	echo "ETC_HOSTS = ${ETC_HOSTS}"
	stringarray=($ETC_HOSTS)
	counter=1
	echo "" > warp_hosts.sh # to clean the file, and start with clean file
	echo '127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4' >> warp_hosts.sh
	echo '::1         localhost6 localhost6.localdomain6' >> warp_hosts.sh
	for i in "${stringarray[@]}"
	do
		echo "${i} host${counter}"
		echo "${i} host${counter}" >> warp_hosts.sh
		let counter++
	done
	stringarray=($ETC_WARP_HOSTS)
	counter=1
	for i in "${stringarray[@]}"
	do
		echo "${i} warp${counter}"
		echo "${i} warp${counter}" >> warp_hosts.sh
		let counter++
	done
}

function get_warp_running_instances_by_tag() {
	# To get all running instance by tag
	aws ec2 describe-instances \
	--filters Name=tag-key,Values=warp Name=instance-state-name,Values=running \
	--query 'Reservations[*].Instances[*].InstanceId' \
	--output text
}

function kill_previous_warp_instances() {
	# To kill any previous instance and save money after test is done.
	printHeader $1 "kill any previous wrap instance"
	instances=$(get_warp_running_instances_by_tag)
	echo "instances to kill:"
	if [ -z "$instances" ]; then
		echo "nothing to terminate"
	else
		terminate_instances $instances
	fi
}

function run_warp_server() {
	printHeader $1 "Run WARP Server"
	command="export WARP_ACCESS_KEY=minioadmin; export WARP_SECRET_KEY=minioadmin; warp mixed --warp-client warp{1...$NUMBER_OF_NODES}:7761 --host host{1...$NUMBER_OF_NODES}:9000 --duration 120s --obj.size 64M --concurrent 64"
	COMMAND_RESULT= # Cleaning up	
	run_command_on_an_instance "${WARP_INSTANCES[0]}" "$command" "" save
	echo $COMMAND_RESULT
	echo $COMMAND_RESULT > wrap_result.log
}

function wait_until_gcp_instances_are_ready_state() {
	printHeader $1 "wait_until_gcp_instances_are_ready_state():"
	COUNTER=0
	NUMBER_OF_INSTANCES_MINUS_ONE=$(expr $NUMBER_OF_NODES - 1)
	while true
	do
		for i in {0..$NUMBER_OF_INSTANCES_MINUS_ONE}
		do
			RESULT=$(gcloud compute instances list --format="json" | jq '.['$i'].status' | tr -d '"')
			if [[ "$RESULT" == "RUNNING" ]]
			then
				COUNTER=$(expr $COUNTER + 1)
				echo "Machine $COUNTER is running"
			fi
		done
		if [[ $COUNTER == $NUMBER_OF_NODES ]]
		then
			echo "Breaking loop all machines are ready"
			break
		fi
	done
}

function get_ips_from_gcp_instances() {
	INDEX=$1
	RESULT=$(gcloud compute instances list --format="json" | jq '.['$INDEX'].networkInterfaces[0].networkIP' | tr -d '"')
	echo $RESULT
}

function add_etc_hosts_line_for_gcp_instances() {
	ZONE=$1       # Example: ZONE="us-central1-a"
	INSTANCE=$2   # Example: INSTANCE="cesar-testing-0"
	PROJECT=$3    # Example: PROJECT="minio-benchmarking"
	IP_ADDRESS=$4 # Example: IP_ADDRESS=10.128.0.42
	HOSTNAME=$5   # Example: HOSTNAME=host1
	gcloud compute ssh --zone $ZONE $INSTANCE --project $PROJECT -- 'sudo sed -i "2i'$IP_ADDRESS'  '$HOSTNAME'" /etc/hosts'
}

function gcp_add_hosts_to_etc() {
	printHeader $1 "gcp_add_hosts_to_etc():"
	for (( x = 0; x < $NUMBER_OF_NODES; x++ ));
	do
		INSTANCE=$(get_running_gcp_instance_name $x)
		echo "INSTANCE: $INSTANCE"
		ZONE=$(get_zone_gcp_instance $x)
		echo "ZONE: $ZONE"
		PROJECT=$(get_project_gcp_instance $x)
		echo "PROJECT: $PROJECT"
		for (( y = 0; y < $NUMBER_OF_NODES; y++ ));
		do	
			IP_ADDRESS=$(get_ips_from_gcp_instances $y)
			HOST_NUMBER=$(expr $y + 1)
			HOSTNAME=host$HOST_NUMBER
			echo "    $IP_ADDRESS $HOSTNAME"
			add_etc_hosts_line_for_gcp_instances $ZONE $INSTANCE $PROJECT $IP_ADDRESS $HOSTNAME
		done
		echo " "
		echo " "
		echo " "
	done
}

# run_command_on_gcp_instance "us-central1-a" "cesar-testing-0" "minio-benchmarking" ls
function run_command_on_gcp_instance() {
	ZONE=$1       # Example: ZONE="us-central1-a"
	echo "run_command_on_gcp_instance(): ZONE: $ZONE"
	INSTANCE=$2   # Example: INSTANCE="cesar-testing-0"
	echo "run_command_on_gcp_instance(): INSTANCE: $INSTANCE"
	PROJECT=$3    # Example: PROJECT="minio-benchmarking"
	echo "run_command_on_gcp_instance(): PROJECT: $PROJECT"
	COMMAND=$4    # Example: cd
	echo "run_command_on_gcp_instance(): COMMAND: $COMMAND"
	# gcloud compute ssh --zone "us-central1-a" "cesar-testing-0" --project "minio-benchmarking" -- 'ls'
	gcloud compute ssh --zone $ZONE $INSTANCE --project $PROJECT -- ''$COMMAND''
}

function gcp_create_disk_folders() {
	# create_disk_folder "us-central1-a" "cesar-testing-0" "minio-benchmarking"
	ZONE=$1       # Example: ZONE="us-central1-a"
	INSTANCE=$2   # Example: INSTANCE="cesar-testing-0"
	PROJECT=$3    # Example: PROJECT="minio-benchmarking"
	for (( x = 1; x <= $NUMBER_OF_DISKS; x++ ));
	do
		# run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo mkdir -p /disk0"
		run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo mkdir -p /disk$x"
	done
}

function gcp_create_disk_folders_in_all_nodes() {
	for (( node_index = 0; node_index < $NUMBER_OF_NODES; node_index++ ));
	do
		INSTANCE=$(get_running_gcp_instance_name $node_index)
		echo "INSTANCE: $INSTANCE"
		ZONE=$(get_zone_gcp_instance $node_index)
		echo "ZONE: $ZONE"
		PROJECT=$(get_project_gcp_instance $node_index)
		echo "PROJECT: $PROJECT"
		gcp_create_disk_folders $ZONE $INSTANCE $PROJECT
		echo "End of disk creation on instance $node_index"
		echo ' '
	done
}

# format_gpc_disks_on_an_instance "us-central1-a" "cesar-testing-0" "minio-benchmarking"
function format_gpc_disks_on_an_instance() {
	ZONE=$1       # Example: ZONE="us-central1-a"
	INSTANCE=$2   # Example: INSTANCE="cesar-testing-0"
	PROJECT=$3    # Example: PROJECT="minio-benchmarking"
	counter=1
	for disk_termination in {b..z}
	do
		run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo mkfs.ext4 -F -m 0 -E lazy_itable_init=0,lazy_journal_init=0,discard /dev/sd$disk_termination"
		echo "counter: $counter"
		if [[ $counter == $NUMBER_OF_DISKS ]];
		then
			echo "All disks has been formatted"
			break
		fi
		counter=$(expr $counter + 1);
	done
}

function format_gcp_disks_on_all_instances() {
	for (( node_index = 0; node_index < $NUMBER_OF_NODES; node_index++ ));
	do
		echo "Formatting disks on all instances..."
		INSTANCE=$(get_running_gcp_instance_name $node_index)
		echo "INSTANCE: $INSTANCE"
		ZONE=$(get_zone_gcp_instance $node_index)
		echo "ZONE: $ZONE"
		PROJECT=$(get_project_gcp_instance $node_index)
		echo "PROJECT: $PROJECT"
		format_gpc_disks_on_an_instance $ZONE $INSTANCE $PROJECT
		echo "End of formatting on instance $node_index"
		echo ' '
	done
}

function mount_gcp_disks() {
	ZONE=$1       # Example: ZONE="us-central1-a"
	INSTANCE=$2   # Example: INSTANCE="cesar-testing-0"
	PROJECT=$3    # Example: PROJECT="minio-benchmarking"
	counter=1
	for disk_termination in {b..z}
	do
		run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo mount /dev/sd$disk_termination /disk$counter"
		echo "counter: $counter"
		if [[ $counter == $NUMBER_OF_DISKS ]];
		then
			echo "All disks has been mounted"
			break
		fi
		counter=$(expr $counter + 1);
	done
}

function mount_all_gcp_disks() {
	for (( node_index = 0; node_index < $NUMBER_OF_NODES; node_index++ ));
	do
		echo "Formatting disks on all instances..."
		INSTANCE=$(get_running_gcp_instance_name $node_index)
		echo "INSTANCE: $INSTANCE"
		ZONE=$(get_zone_gcp_instance $node_index)
		echo "ZONE: $ZONE"
		PROJECT=$(get_project_gcp_instance $node_index)
		echo "PROJECT: $PROJECT"
		mount_gcp_disks $ZONE $INSTANCE $PROJECT
		echo "End of formatting on instance $node_index"
		echo ' '
	done
}

function mount_and_format_gcp_disks() {
	printHeader $1 "mount_and_format_gcp_disks():"
	gcp_create_disk_folders_in_all_nodes
	format_gcp_disks_on_all_instances
	mount_all_gcp_disks
}

function run_minio_distributed_in_gcp_instance() {
	ZONE=$1       # Example: ZONE="us-central1-a"
	INSTANCE=$2   # Example: INSTANCE="cesar-testing-0"
	PROJECT=$3    # Example: PROJECT="minio-benchmarking"
	gcp_passing_a_linux_startup_script_from_a_local_file $INSTANCE "/Users/cniackz/engineering-tools/benchmarking_scripts/startup_script.sh"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-1" "minio-benchmarking" "sudo apt-get install wget"
	# run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo apt-get install wget"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-1" "minio-benchmarking" "wget https://dl.min.io/server/minio/release/linux-amd64/minio"
	# run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "wget https://dl.min.io/server/minio/release/linux-amd64/minio"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-1" "minio-benchmarking" "chmod +x minio"
	# run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "chmod +x minio"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-1" "minio-benchmarking" "sudo mv minio /usr/local/bin/minio"
	# run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo mv minio /usr/local/bin/minio"
	# sudo minio server http://host{1...4}/disk{1...4} &
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-0" "minio-benchmarking" "sudo minio server http://host{1...4}/disk{1...4}"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-1" "minio-benchmarking" "sudo minio server http://host{1...4}/disk{1...4}"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-2" "minio-benchmarking" "sudo minio server http://host{1...4}/disk{1...4}"
	# run_command_on_gcp_instance "us-central1-a" "cesar-testing-3" "minio-benchmarking" "sudo minio server http://host{1...4}/disk{1...4}"
	# run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo minio server http://host{1...$NUMBER_OF_NODES}/disk{1...$NUMBER_OF_DISKS} &"
	# https://stackoverflow.com/questions/19302913/exit-zsh-but-leave-running-jobs-open
	# The &! is a zsh-specific shortcut to both background and disown the process, such that exiting the shell will leave it running.
	run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT "sudo google_metadata_script_runner startup" &!
}

function run_minio_distributed_in_gcp_instances() {
	printHeader $1 "run_minio_distributed_in_gcp_instances():"
	for (( node_index = 0; node_index < $NUMBER_OF_NODES; node_index++ ));
	do
		INSTANCE=$(get_running_gcp_instance_name $node_index)
		echo "INSTANCE: $INSTANCE"
		ZONE=$(get_zone_gcp_instance $node_index)
		echo "ZONE: $ZONE"
		PROJECT=$(get_project_gcp_instance $node_index)
		echo "PROJECT: $PROJECT"
		run_minio_distributed_in_gcp_instance $ZONE $INSTANCE $PROJECT
		echo "run_minio_distributed_in_gcp_instances(): End of running minio on instance $node_index"
	done
	echo "run_minio_distributed_in_gcp_instances(): Finished"
	echo " "
}

# gcp_passing_a_linux_startup_script_from_a_local_file "cesar-testing-0" "/Users/cniackz/engineering-tools/benchmarking_scripts/startup_script.sh"
function gcp_passing_a_linux_startup_script_from_a_local_file() {
	# VM_NAME="cesar-testing-0"
	# FILE_PATH="/Users/cniackz/engineering-tools/benchmarking_scripts/startup_script.sh"
	VM_NAME=$1
	FILE_PATH=$2
	gcloud compute instances add-metadata $VM_NAME \
	--metadata-from-file startup-script=$FILE_PATH
}

function run_command_on_gcp_instances() {
	COMMAND=$1
	for (( node_index = 0; node_index < $NUMBER_OF_NODES; node_index++ ));
	do
		INSTANCE=$(get_running_gcp_instance_name $node_index)
		ZONE=$(get_zone_gcp_instance $node_index)
		PROJECT=$(get_project_gcp_instance $node_index)
		run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT $COMMAND
	done
}

function make_sure_minio_is_running_on_each_gcp_node(){
	sleep 60 # wait for MinIO to get ready in all servers.
	printHeader $1 "make_sure_minio_is_running_on_each_gcp_node():"
	run_command_on_gcp_instances "sudo ps aux | grep minio"
}

function run_command_on_gcp_instance_0() {
	COMMAND=$1
	INSTANCE=$(get_running_gcp_instance_name 0)
	ZONE=$(get_zone_gcp_instance 0)
	PROJECT=$(get_project_gcp_instance 0)
	run_command_on_gcp_instance $ZONE $INSTANCE $PROJECT $COMMAND
}

function set_mc_alias_in_gcp_instance() {
	printHeader $1 "set_mc_alias_in_gcp_instance():"
	COMMAND="sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin"
	run_command_on_gcp_instance_0 $COMMAND
}

function run_speed_test_on_gcp_instance() {
	printHeader $1 "run_speed_test_on_gcp_instance():"
	COMMAND="sudo mc support perf object myminio/"
	run_command_on_gcp_instance_0 $COMMAND
}
