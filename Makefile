# go-gcp-bill-saver
###################################
PROJECT_NAME=go-gcp-bill-saver
AUTH_PATH=/home/joseramon/Downloads/go-gcp-bill-saver-325714-13e1f45164ee.json
ACCOUNT=cicd-server@go-gcp-bill-saver-325714.iam.gserviceaccount.com
###################################

setup: init auth
	gcloud services list --available
	gcloud services enable google-storage-bucket

init:
	gcloud config set account $(ACCOUNT)
	gcloud config set project $(PROJECT_NAME)

auth: init auth
	gcloud auth activate-service-account $(ACCOUNT) --key-file=$(AUTH_PATH) --project=$(PROJECT_NAME)

tf-init:
	cd ./infra/list \
	&& terraform init \
	&& cd ../../

tf-plan:
	cd ./infra/list \
	&& terraform plan

tf-refresh:
	cd ./infra/list \
	&& terraform refresh

tf-apply:
	cd ./infra/list \
	&& terraform apply -auto-approve

tf-destroy:
	cd ./infra/list \
	&& terraform destroy -auto-approve

tf-all: tf-init tf-plan tf-refresh tf-apply

tf-recreate: tf-destroy tf-init tf-plan tf-refresh tf-apply