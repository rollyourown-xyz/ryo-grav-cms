#!/bin/bash

helpMessage()
{
   echo "build-images.sh: Use packer to build images for deployment"
   echo ""
   echo "Help: build-images.sh"
   echo "Usage: ./build-images.sh -v version -w webhook_version -g grav_version"
   echo "Flags:"
   echo -e "-v version \t\tVersion stamp to apply to images, e.g. 20210101-1"
   echo -e "-w webhook_version \tWebhook version to use when building the haproxy-dmz image, e.g. 2.8.0"
   echo -e "-g grav_version \tGrav version to use when building the webserver image, e.g. 1.7.9"
   echo -e "-h \t\t\tPrint this help message"
   echo ""
   exit 1
}

errorMessage()
{
   echo "Invalid option or input variables are missing"
   echo "Use \"./build-images.sh -h\" for help"
   exit 1
}

while getopts v:g:h flag
do
    case "${flag}" in
        v) version=${OPTARG};;
        w) webhook_version=${OPTARG};;
        g) grav_version=${OPTARG};;
        h) helpMessage ;;
        ?) errorMessage ;;
    esac
done

if [ -z "$version" ] || [ -z "$webhook_version" ] || [ -z "$grav_version" ]
then
   errorMessage
fi

echo "Building images with version=$version and Grav version=$grav_version"
echo ""
echo "Building HAProxy image"
echo "Executing command: packer build -var \"version=$version\" -var \"webhook_version=$webhook_version\" image-build/haproxy-dmz.pkr.hcl"
echo ""
packer build -var "version=$version" image-build/haproxy-dmz.pkr.hcl
echo ""
echo "Building Certbot image"
echo "Executing command: packer build -var \"version=$version\" certbot.pkr.hcl"
echo ""
packer build -var "version=$version" image-build/certbot.pkr.hcl
# echo ""
# echo "Building webserver image"
# echo "Executing command: packer build -var \"version=$version\" -var \"grav_version=$grav_version\" webserver.pkr.hcl"
# echo ""
#packer build -var "version=$version" -var "grav_version=$grav_version" image-build/webserver.pkr.hcl
echo ""
echo "Completed"
