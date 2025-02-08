#!/bin/bash

PROJECT_ID=$1
REGION=$2
VERSION=${3:-"latest"}

# API Build and Push
gcloud builds submit --config=cloudbuild.yaml --substitutions=_REGION=$REGION,_PROJECT_ID=$PROJECT_ID,_VERSION=$VERSION