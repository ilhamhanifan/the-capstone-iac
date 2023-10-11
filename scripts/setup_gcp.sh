#!/bin/bash

## Load variables from dot.env
if [[ -f dot.env ]]; then 
  source dot.env
else
  echo "dot.env file not found"
  exit 1
fi

## dot.env
# project_id="your-project-id"
# billing_account="your-billing-account"

create_project(){
  local project_id="$1"
  local project_name="$2"
  local billing_account="$3"
  
  echo "Creating project: ${project_id}"

  gcloud projects create ${project_id} --name="${project_name}"
  gcloud billing projects link ${project_id} --billing-account ${billing_account}
  
  echo "Project ${project_id} created successfully..."

}


enable_gcp_api(){
  local project_id="$1"
  
  echo "Enabling GCP APIs for ${project_id}... (this may take quite a while)"

  gcloud services enable compute.googleapis.com --project="${project_id}"
  gcloud services enable artifactregistry.googleapis.com --project="${project_id}"
  gcloud services enable iamcredentials.googleapis.com --project="${project_id}"
  gcloud services enable iam.googleapis.com --project="${project_id}"
  gcloud services enable cloudresourcemanager.googleapis.com --project="${project_id}"
  gcloud services enable container.googleapis.com --project="${project_id}"
  # add more services here

  echo "GCP APIs enabled for ${project_id}"
}


create_terraform_service_account(){
  local project_id="$1"
  local service_account_name="$2"
  local description="$3"
  local display_name="$3"

  echo "Creating Terraform Service Account: ${project_id}"

  gcloud iam service-accounts create ${service_account_name} \
    --description "${description}" \
    --display-name "${display_name}" \
    --project ${project_id}

  gcloud projects add-iam-policy-binding ${project_id}\
      --member="serviceAccount:${service_account_name}@${project_id}.iam.gserviceaccount.com" \
      --role="roles/owner"

  mkdir -p ./keys

  gcloud iam service-accounts keys create ./keys/${service_account_name}-key.json \
    --iam-account ${service_account_name}@${project_id}.iam.gserviceaccount.com

  echo "Registry Service Account ${service_account_name} for ${project_id} created successfully..."
}


create_bucket(){
  local project_id="$1"
  local bucket_name="$2"

  echo "Creating Bucket: ${bucket_name}"

  gsutil mb -p ${project_id} gs://${bucket_name}

  echo "Bucket ${bucket_name} created successfully..."
}


## Main ##

echo "Script starts..."

## Create the project and link billing accounts
# create_project ${project_id} "theCapstone gcp project" ${billing_account_id}

## LINK BILLING ACCOUNT HERE

## Enable apis for the project
# enable_gcp_api "${project_id}"

## Create terraform IAM service account and the credentials json files
# create_terraform_service_account "${dev_project}" "terraform-sa" "Terraform Service Account"

## Create cloud storage bucket for terraform statefiles
create_bucket "${project_id}" "the-capstone-tfstate"

echo "Script ends..."
