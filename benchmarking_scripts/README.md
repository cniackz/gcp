# Benchmark script
This script is intended to measure the speed of our MinIO over distributed intances on Amazon.
The way to run it is simple, just launch this line below:
`./benchmark_test.sh`
And the output will look like:
```
cniackz:/Users/cniackz/minio/jobs/00000H/engineering-tools/aws_cli_scripts # ./benchmark_test.sh 

0. kill any previous instance created with our tag test
instances to kill:
nothing to terminate

1. Creating instances
1: instance_id: i-08843dc22c11c0ba9
2: instance_id: i-080b2cf94dafb0e93
3: instance_id: i-0fe9e5578a04219ea
4: instance_id: i-0bc0a3547cf756f24
5: instance_id: i-0b0ea9592c97f050c
6: instance_id: i-0f5f8f0ca2b9bbc08
7: instance_id: i-01fa114d407534761
8: instance_id: i-0e51027e2eb5d2061

2. Check the status of the instances to be running state
instance: i-08843dc22c11c0ba9, state: "running"
instance: i-080b2cf94dafb0e93, state: "running"
instance: i-0fe9e5578a04219ea, state: "running"
instance: i-0bc0a3547cf756f24, state: "running"
instance: i-0b0ea9592c97f050c, state: "running"
instance: i-0f5f8f0ca2b9bbc08, state: null
instance: i-01fa114d407534761, state: null
instance: i-0e51027e2eb5d2061, state: null
instance: i-08843dc22c11c0ba9, state: "running"
instance: i-080b2cf94dafb0e93, state: "running"
instance: i-0fe9e5578a04219ea, state: "running"
instance: i-0bc0a3547cf756f24, state: "running"
instance: i-0b0ea9592c97f050c, state: "running"
instance: i-0f5f8f0ca2b9bbc08, state: "running"
instance: i-01fa114d407534761, state: "running"
instance: i-0e51027e2eb5d2061, state: "running"

3. Creating the /etc/hosts file:
172.31.69.174 host1
172.31.74.217 host2
172.31.78.139 host3
172.31.68.15 host4
172.31.71.254 host5
172.31.76.166 host6
172.31.79.115 host7
172.31.73.133 host8

4. Put /etc/hosts file on each node...
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-44-200-242-37.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-44-200-242-37.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     7.2KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-44-192-117-203.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-44-192-117-203.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     8.0KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-18-204-214-233.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-18-204-214-233.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     6.6KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-100-24-125-220.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-100-24-125-220.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     7.8KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-3-222-192-199.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-3-222-192-199.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     9.4KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-54-236-37-70.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-54-236-37-70.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     7.8KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-3-235-46-248.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-3-235-46-248.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     3.1KB/s   00:00    
Command to run: scp -o StrictHostKeyChecking=no -i TESTING.pem hosts.sh ec2-user@ec2-34-201-47-3.compute-1.amazonaws.com:/home/ec2-user/hosts
Warning: Permanently added 'ec2-34-201-47-3.compute-1.amazonaws.com' (ED25519) to the list of known hosts.
hosts.sh                                                                                                                                                                                                           100%  286     7.9KB/s   00:00    

5. Mount and format disks
running command on instance: i-08843dc22c11c0ba9
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-200-242-37.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-080b2cf94dafb0e93
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-192-117-203.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-0fe9e5578a04219ea
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-18-204-214-233.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-0bc0a3547cf756f24
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-100-24-125-220.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-0b0ea9592c97f050c
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-222-192-199.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-0f5f8f0ca2b9bbc08
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-54-236-37-70.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-01fa114d407534761
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-235-46-248.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 
running command on instance: i-0e51027e2eb5d2061
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-34-201-47-3.compute-1.amazonaws.com "cd && echo IyEvYmluL2Jhc2gKI3NldCAteAoKbW91bnRfZGV2aWNlKCl7CkRFVklDRT0iL2Rldi8kMSIKVk9MVU1FX05BTUU9JDIKTU9VTlRfUE9JTlQ9JDMKCmZvcm1hdF9kZXZpY2UoKSB7CiAgZWNobyAiRm9ybWF0dGluZyAkREVWSUNFIgogIG1rZnMueGZzIC1pbWF4cGN0PTI1IC1mIC1MICRNT1VOVF9QT0lOVCAkREVWSUNFCn0KY2hlY2tfZGV2aWNlKCkgewogIGlmIFsgLWYgIi9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50IiBdOyB0aGVuCiAgICBlY2hvICJEZXZpY2UgJE1PVU5UX1BPSU5UICgkREVWSUNFKSBleGlzdHMiCiAgICBlY2hvICJObyBhY3Rpb25zIHJlcXVpcmVkLi4uIgogIGVsc2UKICAgIGVjaG8gIiRNT1VOVF9QT0lOVC5tb3VudCB3YXMgbm90IGZvdW5kLCBjcmVhdGluZyB2b2x1bWUiCiAgICBmb3JtYXRfZGV2aWNlCiAgZmkKfQpjaGVja19tb3VudCgpIHsKICBpZiBbIC1mICIvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudCIgXTsgdGhlbgogICAgZWNobyAiRm91bmQgJE1PVU5UX1BPSU5ULm1vdW50IGluIC9ldGMvc3lzdGVtZC9zeXN0ZW0vIgogICAgZWNobyAiTm8gYWN0aW9ucyByZXF1aXJlZC4uLiIKICBlbHNlCiAgICBlY2hvICIkTU9VTlRfUE9JTlQubW91bnQgd2FzIG5vdCBmb3VuZCBpbiAvZXRjL3N5c3RlbWQvc3lzdGVtLyBhZGRpbmcgaXQiCiAgICBta2RpciAtcCAvJE1PVU5UX1BPSU5UCiAgICAKICAgIGVjaG8gIltVbml0XSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIkRlc2NyaXB0aW9uPU1vdW50IFN5c3RlbSBCYWNrdXBzIERpcmVjdG9yeSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltNb3VudF0iID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJXaGF0PUxBQkVMPSRNT1VOVF9QT0lOVCIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldoZXJlPS8kTU9VTlRfUE9JTlQiID4+IC9ldGMvc3lzdGVtZC9zeXN0ZW0vJE1PVU5UX1BPSU5ULm1vdW50CiAgICBlY2hvICJUeXBlPXhmcyIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIk9wdGlvbnM9bm9hdGltZSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIiIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIltJbnN0YWxsXSIgPj4gL2V0Yy9zeXN0ZW1kL3N5c3RlbS8kTU9VTlRfUE9JTlQubW91bnQKICAgIGVjaG8gIldhbnRlZEJ5PW11bHRpLXVzZXIudGFyZ2V0IiA+PiAvZXRjL3N5c3RlbWQvc3lzdGVtLyRNT1VOVF9QT0lOVC5tb3VudAoKICAgIHN5c3RlbWN0bCBlbmFibGUgJE1PVU5UX1BPSU5ULm1vdW50CiAgICBzeXN0ZW1jdGwgc3RhcnQgJE1PVU5UX1BPSU5ULm1vdW50CiAgZmkKfQpMQUJFTD0kKGJsa2lkIC1MICRWT0xVTUVfTkFNRSkKY2hlY2tfZGV2aWNlCmNoZWNrX21vdW50CnN5c3RlbWN0bCBkYWVtb24tcmVsb2FkCn0KCmZvciBpIGluIGBsc2JsayAtZCB8IGdyZXAgLXYgTkFNRSB8IGdyZXAgLXYgbnZtZTAgfCBhd2sgJ3twcmludCAkMX0nYDsgZG8KICBtbnRfcG9pbnQ9YGVjaG8gJGkgfCBzZWQgLWUgJ3MvbnZtZS9kaXNrL2cnIC1lICdzL24xLy9nJ2AKICBtb3VudF9kZXZpY2UgJGkgJGkgJG1udF9wb2ludDsKZG9uZQo= | base64 --decode > mount_drives.sh && chmod +x mount_drives.sh && sudo ./mount_drives.sh" 

6. Run MinIO in distributed mode
running command on instance: i-08843dc22c11c0ba9
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-200-242-37.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-080b2cf94dafb0e93
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-192-117-203.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-0fe9e5578a04219ea
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-18-204-214-233.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-0bc0a3547cf756f24
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-100-24-125-220.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-0b0ea9592c97f050c
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-222-192-199.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-0f5f8f0ca2b9bbc08
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-54-236-37-70.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-01fa114d407534761
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-235-46-248.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &
running command on instance: i-0e51027e2eb5d2061
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-34-201-47-3.compute-1.amazonaws.com "sudo minio server http://host{1...8}/disk{1...5}" &

7. Making sure MinIO is running on each node
running command on instance: i-08843dc22c11c0ba9
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-200-242-37.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-080b2cf94dafb0e93
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-192-117-203.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-0fe9e5578a04219ea
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-18-204-214-233.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-0bc0a3547cf756f24
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-100-24-125-220.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-0b0ea9592c97f050c
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-222-192-199.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-0f5f8f0ca2b9bbc08
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-54-236-37-70.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-01fa114d407534761
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-235-46-248.compute-1.amazonaws.com "sudo ps aux | grep minio" 
running command on instance: i-0e51027e2eb5d2061
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-34-201-47-3.compute-1.amazonaws.com "sudo ps aux | grep minio" 
root 2362 0.0 0.0 129680 6776 ? Ss 17:34 0:00 sudo minio server http://host{1...8}/disk{1...5} root 2369 15.1 0.1 1165220 164748 ? Sl 17:34 0:01 minio server http://host{1...8}/disk{1...5} ec2-user 2461 0.0 0.0 113808 2752 ? Ss 17:34 0:00 bash -c sudo ps aux | grep minio ec2-user 2469 0.0 0.0 112900 512 ? S 17:34 0:00 grep minio

8. Set MinIO Client Alias
running command on instance: i-08843dc22c11c0ba9
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-200-242-37.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-080b2cf94dafb0e93
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-192-117-203.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-0fe9e5578a04219ea
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-18-204-214-233.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-0bc0a3547cf756f24
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-100-24-125-220.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-0b0ea9592c97f050c
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-222-192-199.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-0f5f8f0ca2b9bbc08
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-54-236-37-70.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-01fa114d407534761
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-3-235-46-248.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
running command on instance: i-0e51027e2eb5d2061
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-34-201-47-3.compute-1.amazonaws.com "sudo mc alias set myminio http://localhost:9000 minioadmin minioadmin" 
Added `myminio` successfully.

9. Run Speed Test
running command on instance: i-08843dc22c11c0ba9
command to run: ssh -o StrictHostKeyChecking=no -i TESTING.pem ec2-user@ec2-44-200-242-37.compute-1.amazonaws.com "sudo mc admin speedtest myminio --json" 
PUTStats:
{
  "throughputPerSec": 17877801369,
  "objectsPerSec": 266,
  "servers": [
    {
      "endpoint": "http://host1:9000",
      "throughputPerSec": 2167616307,
      "objectsPerSec": 32,
      "err": ""
    },
    {
      "endpoint": "http://host2:9000",
      "throughputPerSec": 2174327193,
      "objectsPerSec": 32,
      "err": ""
    },
    {
      "endpoint": "http://host3:9000",
      "throughputPerSec": 2254857830,
      "objectsPerSec": 33,
      "err": ""
    },
    {
      "endpoint": "http://host4:9000",
      "throughputPerSec": 2254857830,
      "objectsPerSec": 33,
      "err": ""
    },
    {
      "endpoint": "http://host5:9000",
      "throughputPerSec": 2181038080,
      "objectsPerSec": 32,
      "err": ""
    },
    {
      "endpoint": "http://host6:9000",
      "throughputPerSec": 2328677580,
      "objectsPerSec": 34,
      "err": ""
    },
    {
      "endpoint": "http://host7:9000",
      "throughputPerSec": 2221303398,
      "objectsPerSec": 33,
      "err": ""
    },
    {
      "endpoint": "http://host8:9000",
      "throughputPerSec": 2295123148,
      "objectsPerSec": 34,
      "err": ""
    }
  ]
}
GETStats:
{
  "throughputPerSec": 17877801369,
  "objectsPerSec": 266,
  "servers": [
    {
      "endpoint": "http://host1:9000",
      "throughputPerSec": 2167616307,
      "objectsPerSec": 32,
      "err": ""
    },
    {
      "endpoint": "http://host2:9000",
      "throughputPerSec": 2174327193,
      "objectsPerSec": 32,
      "err": ""
    },
    {
      "endpoint": "http://host3:9000",
      "throughputPerSec": 2254857830,
      "objectsPerSec": 33,
      "err": ""
    },
    {
      "endpoint": "http://host4:9000",
      "throughputPerSec": 2254857830,
      "objectsPerSec": 33,
      "err": ""
    },
    {
      "endpoint": "http://host5:9000",
      "throughputPerSec": 2181038080,
      "objectsPerSec": 32,
      "err": ""
    },
    {
      "endpoint": "http://host6:9000",
      "throughputPerSec": 2328677580,
      "objectsPerSec": 34,
      "err": ""
    },
    {
      "endpoint": "http://host7:9000",
      "throughputPerSec": 2221303398,
      "objectsPerSec": 33,
      "err": ""
    },
    {
      "endpoint": "http://host8:9000",
      "throughputPerSec": 2295123148,
      "objectsPerSec": 34,
      "err": ""
    }
  ]
}

10. Saving log to a file: 2022_02_07_12_35_36.log

11. kill any previous instance created with our tag test
instances to kill:
i-0b0ea9592c97f050c
i-01fa114d407534761
i-0e51027e2eb5d2061
i-08843dc22c11c0ba9
i-080b2cf94dafb0e93
i-0f5f8f0ca2b9bbc08
i-0fe9e5578a04219ea
i-0bc0a3547cf756f24
```

Notice there will be log created for each execution under `logs` folder:
```
NUMBER_OF_NODES = 8
INSTANCE_TYPE = c6gn.16xlarge
AMI = ami-0b6705f88b1f688c1
TAG_KEY = test
SECURITY_GROUP = sg-00fcb6381a1a6bf02
KEY_PAIRS = TESTING
...
```

### To run:

```sh
cd ~/engineering-tools/benchmarking_scripts/gcp
./benchmark_gcp_test.sh
```
