#!/bin/bash

source ./utils.sh

function clear_with_acl() {
	clear_with_hat
	COMMAND="getfacl $FILENAME"
	ACL_LENGTH=$(eval $COMMAND | wc -l)
	eval $COMMAND | prSection $ACL_LENGTH	
}
