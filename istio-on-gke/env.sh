#!/bin/sh

# Source this file to setup env variable from your gcloud profile
export ZONE=$(gcloud config get-value compute/zone)
export GOOGLE_CLOUD_PROJECT=$(gcloud config get-value project)
