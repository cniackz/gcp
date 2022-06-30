#!/bin/bash

source common.sh

NUMBER_OF_NODES=32
INSTANCES=()

# (64-bit Arm)
INSTANCE_TYPE=c6gn.16xlarge
AMI=ami-0b6705f88b1f688c1

TAG_KEY=test

kill_any_previous_instance
