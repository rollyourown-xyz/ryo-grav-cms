#!/bin/bash

# Script directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

helpMessage()
{
  echo "delete-project-containers.sh: Delete the containers of a rollyourown.xyz project"
  echo ""
  echo "Help: delete-project-containers.sh"
  echo "Usage: ./delete-project-containers.sh -n hostname"
  echo "Flags:"
  echo -e "-n hostname \t\t(Mandatory) Name of the host on which to delete project containers"
  echo -e "-h \t\t\tPrint this help message"
  echo ""
  exit 1
}

errorMessage()
{
  echo "Invalid option or input variables are missing"
  echo "Use \"./delete-project-containers.sh -h\" for help"
  exit 1
}

while getopts n:h flag
do
  case "${flag}" in
    n) hostname=${OPTARG};;
    h) helpMessage ;;
    ?) errorMessage ;;
  esac
done

if [ -z "$hostname" ]
then
  errorMessage
fi

# Deleting project containers
#############################

echo ""
echo "Deleting project container..."

echo "...deleting "$PROJECT_ID"-grav-webserver container"
lxc delete --force "$hostname":"$PROJECT_ID"-grav-webserver
echo ""

echo "Project container deleted"
echo ""
