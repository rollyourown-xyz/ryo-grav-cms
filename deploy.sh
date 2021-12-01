#!/bin/bash

# Project ID
PROJECT_ID="ryo-grav-cms"

# Required modules (space-separated list in the form "module_1 module_2 module_3")
MODULES="ryo-service-proxy"

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
  echo "deploy.sh: Deploy a rollyourown.xyz project"
  echo "Usage: ./deploy.sh -n hostname -v version"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host on which to deploy the project"
  echo -e "-v version \t\t(Mandatory) Version stamp for images to deploy, e.g. 20210101-1"
  echo -e "-h \t\t\tPrint this help message"
  echo ""
  exit 1
}

errorMessage()
{
  echo "Invalid option or input variables are missing"
  echo "Use \"./deploy.sh -h\" for help"
  exit 1
}

while getopts n:v:h flag
do
  case "${flag}" in
    n) hostname=${OPTARG};;
    v) version=${OPTARG};;
    h) helpMessage ;;
    ?) errorMessage ;;
  esac
done

if [ -z "$hostname" ] || [ -z "$version" ]; then
  errorMessage
fi

echo "rollyourown.xyz deployment script for "$PROJECT_ID""

# Update project repository
echo "Refreshing project repository with git pull"
git pull

# Get user input for whether to do module host set up, module image build and module deployment
echo ""
echo -n "Include modules? "
read -e -p "[y/n/Q]:" INCLUDE_MODULES
INCLUDE_MODULES="${INCLUDE_MODULES:-"q"}"
INCLUDE_MODULES="${INCLUDE_MODULES,,}"
if [ "$INCLUDE_MODULES" == "q" ]; then
  echo "Quitting"
  exit 1
elif [ ! "$INCLUDE_MODULES" == "y" ] && [ ! "$INCLUDE_MODULES" == "n" ]; then
  echo "Invalid option "${INCLUDE_MODULES}". Quitting"
  exit 1
elif [ "$INCLUDE_MODULES" == "y" ]; then
  echo "Module host setup, image build and deployment will be done."
else
  echo "Module host setup, image build and deployment will be skipped."
fi


# Modules
#########

if [ "$INCLUDE_MODULES" == "y" ]; then

  # Clone modules or git pull if already cloned
  echo ""
  echo "Cloning/updating modules for "$PROJECT_ID""
  for module in $MODULES
  do
    /bin/bash "$SCRIPT_DIR"/scripts-modules/get-module.sh -m "$module"
  done

  # Run host setup playbooks for modules
  echo ""
  for module in $MODULES
  do
    /bin/bash "$SCRIPT_DIR"/scripts-modules/host-setup-module.sh -n "$hostname" -m "$module"
  done

  # Run packer image build for modules
  echo ""
  for module in $MODULES
  do
    /bin/bash "$SCRIPT_DIR"/scripts-modules/build-image-module.sh -n "$hostname" -v "$version" -m "$module"
  done

  # Deploy modules
  echo ""
  for module in $MODULES
  do
    /bin/bash "$SCRIPT_DIR"/scripts-modules/deploy-module.sh -n "$hostname" -v "$version" -m "$module"
  done

else
  echo ""
  echo "Skipping modules"
fi


# Project components
####################

# Run host setup playbooks for project
echo ""
echo ""
echo "Running project-specific host setup for "$PROJECT_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-project/host-setup-project.sh -n "$hostname"

# Build project images
echo ""
echo "Running image build for "$PROJECT_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-project/build-image-project.sh -n "$hostname" -v "$version"

# Deploy project containers
echo ""
echo "Deploying "$PROJECT_ID" on "$hostname""
/bin/bash "$SCRIPT_DIR"/scripts-project/deploy-project.sh -n "$hostname" -v "$version"
