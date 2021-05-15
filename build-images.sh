#!/bin/bash

helpMessage()
{
   echo "build-images.sh: Use packer to build images for deployment"
   echo ""
   echo "Help: build-images.sh"
   echo "Usage: ./build-images.sh -v version -w webhook_version -g grav_version"
   echo "Flags:"
   echo -e "-v version \t\t(Mandatory) Version stamp to apply to images, e.g. 20210101-1"
   echo -e "-w webhook_version \t(Optional) Webhook version to use for the loadbalancer-tls-proxy image, e.g. 2.8.0 (default)"
   echo -e "-c consul_template_version \t(Optional) consul-template version to use for the loadbalancer-tls-proxy image, e.g. 0.25.2 (default)"
   echo -e "-g grav_version \t(Optional) Grav version to use for the webserver image, e.g. 1.7.10 (default)"
   echo -e "-h \t\t\tPrint this help message"
   echo ""
   exit 1
}

errorMessage()
{
   echo "Invalid option or mandatory input variable is missing"
   echo "Use \"./build-images.sh -h\" for help"
   exit 1
}

# Default webhook and grav versions
webhook_version=2.8.0
consul_template_version=0.25.2
grav_version=1.7.14

while getopts v:w:g:h flag
do
    case "${flag}" in
        v) version=${OPTARG};;
        w) webhook_version=${OPTARG};;
        g) grav_version=${OPTARG};;
        h) helpMessage ;;
        ?) errorMessage ;;
    esac
done

if [ -z "$version" ] || [ -z "$webhook_version" ] || [ -z "$consul_template_version" ] || [ -z "$grav_version" ]
then
   errorMessage
fi

echo "Building images with version $version, Webhook version $webhook_version, consul-template version $consul_template_version and Grav version $grav_version"
echo ""
echo "Building Consul image"
echo "Executing command: packer build -var \"version=$version\" modules/ryo-service-registry-kv-store/image-build/consul.pkr.hcl"
echo ""
packer build -var "version=$version" modules/ryo-service-registry-kv-store/image-build/consul.pkr.hcl
echo ""
echo "Building Loadbalancer-TLS-Proxy image"
echo "Executing command: packer build -var \"version=$version\" -var \"webhook_version=$webhook_version\" -var \"consul_template_version=$consul_template_version\" modules/ryo-loadbalancer-tls-proxy/image-build/loadbalancer-tls-proxy.pkr.hcl"
echo ""
packer build -var "version=$version" -var "webhook_version=$webhook_version" -var "consul_template_version=$consul_template_version" modules/ryo-loadbalancer-tls-proxy/image-build/loadbalancer-tls-proxy.pkr.hcl
echo ""
echo "Building grav-webserver image"
echo "Executing command: packer build -var \"version=$version\" -var \"grav_version=$grav_version\" webserver.pkr.hcl"
echo ""
packer build -var "version=$version" -var "grav_version=$grav_version" image-build/grav-webserver.pkr.hcl
echo ""
echo "Completed"
