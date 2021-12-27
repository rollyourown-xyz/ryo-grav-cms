#!/bin/bash

# Default project software versions
grav_version="1.7.25"

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
  echo "build-image-project.sh: Use packer to build project images for deployment"
  echo ""
  echo "Help: build-image-project.sh"
  echo "Usage: ./build-image-project.sh -m -n hostname -g grav_version -v version"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host for which to build images"
  echo -e "-v version \t\t(Mandatory) Version stamp to apply to images, e.g. 20210101-1"
  echo -e "-h \t\t\tPrint this help message"
  echo ""
  exit 1
}

errorMessage()
{
  echo "Invalid option or mandatory input variable is missing"
  echo "Use \"./build-image-project.sh -h\" for help"
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

if [ -z "$hostname" ] || [ -z "$version" ]
then
  errorMessage
fi


# Build project images

# Grav webserver
echo ""
echo "Building grav-webserver image on "$hostname""
echo "Executing command: packer build -var \"host_id="$hostname"\" -var \"grav_version=$grav_version\" -var \"version=$version\" "$SCRIPT_DIR"/../image-build/grav-webserver.pkr.hcl"
packer build -var "host_id="$hostname"" -var "grav_version="$grav_version"" -var "version="$version"" "$SCRIPT_DIR"/../image-build/grav-webserver.pkr.hcl
echo "Completed"