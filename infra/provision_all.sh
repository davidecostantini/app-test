set -e #-x
DATE=`date +%H:%M:%S_%d/%m/%Y`

PLAN_PATH=tf_plan.tfplan

# S3 TF state file
export TF_VAR_s3_state_bucket=tf-infrastructure-state-file

# RDS
export TF_VAR_db_username=myusername
export TF_VAR_db_password=very-unsecure

echo ""
echo "##################################################"
echo "Executed at: 		$DATE"
echo "Plan path:   		$PLAN_PATH"
echo "##################################################"
echo ""

run_tf() {

	echo "##############"
	echo "## Running Terraform: $1"
	echo "##############"

	cd $1

	rm -rf $PLAN_PATH

	terraform init

	terraform plan -out=$PLAN_PATH

	time terraform apply -state=$STATE_PATH $PLAN_PATH

	rm -rf $PLAN_PATH

	cd ..
}

echo "Running deployment..."

run_tf "00_state"

run_tf "01_networking"

# run_tf "02_rds"

run_tf "03_eks"

run_tf "04_s3"

read -p "Do you want to destroy all? [y/n]" -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
	# to destroy all
	cd 04_s3
	terraform destroy -auto-approve

	cd ../03_eks
	terraform destroy -auto-approve

	cd ../02_rds
	terraform destroy -auto-approve

	cd ../01_networking
	terraform destroy -auto-approve

	cd ../00_state
	terraform destroy -auto-approve
fi
