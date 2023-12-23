#This script will attach user to groups based on inputs.
#Inputs : $USRNAME $GROUPLIST (separated by comma without spaces between multiple groupnames)
#Usage : ./add_iam_user_to_assume_role_groups.bash testuser G1,G2,G3,G4,,,Gx where G1,G2...Gx are groupnames to which user is required to be added to. 
#The usage of this script here is to add user on capterra-aws-admin account, so that they can assume roles from any of subaccounts: capterra, capterra-crf(dev,stg,prd), capterra-search(dev,staging,prod), capterra-sandbox, capterra-orange-staging, and capterra-wordpress-sandbox AWS accounts.
#Assume Roles on all 10 accounts will be created using Terraform and will be present in them.

#!/bin/bash
USRNAME=$1
GROUPLIST=$2
IFS=',' read -ra ADDR <<< "$GROUPLIST"

for gpname in "${ADDR[@]}";
do
echo "$gpname"
aws iam add-user-to-group --user-name="$USRNAME" --group-name=$gpname
_EXITCODE=$?
	if [ ${_EXITCODE} -eq 0 ]; then
		echo "USER:$USRNAME added to group:$gpname"
	else
  		echo -e "Unable to add USER:$USRNAME added to group:$gpname"
	fi
done