# ryo-simple-blog-grav

**NEEDS COMPLETING / TIDYING UP AFTER PROJECT WEB PAGES ARE WRITTEN**

Rollyourown.xyz project repository for a simple blog server using grav.

## How to use

1. Install ansible and git

        sudo apt update
        sudo apt install software-properties-common
        sudo apt-add-repository --yes --update ppa:ansible/ansible
        sudo apt update
        sudo apt install ansible git

2. Create a working directory (e.g. `~/ryo-projects`), enter it and clone the project repository

        mkdir ~/ryo-projects
        cd ~/ryo-projects
        git clone https://git.rollyourown.xyz/ryo-projects/ryo-simple-blog-grav.git

        Temporary, with public key for cloning to test VM
        git clone ssh://gitea@git.rollyourown.xyz:3022/ryo-projects/ryo-simple-blog-grav.git

3. Copy the example project configuration files to a directory outside of the project directory structure, add settings and then add the paths to the configuration files to `~/ryo-projects/ryo-simple-blog-grav/configuration/config_path.yml`

        cp ~/ryo-projects/ryo-simple-blog-grav/configuration/example_local_configuration.yml ~/local_configuration.yml
        cp ~/ryo-projects/ryo-simple-blog-grav/configuration/example_host_configuration.yml ~/host_configuration.yml
        cp ~/ryo-projects/ryo-simple-blog-grav/configuration/example_project_configuration.yml ~/project_configuration.yml
        nano ~/local_configuration.yml
        nano ~/host_configuration.yml
        nano ~/project_configuration.yml
        nano ~/ryo-projects/ryo-simple-blog-grav/configuration/config_path.yml

4. Add the host public IP address to the inventory `~/ryo-projects/ryo-simple-blog-grav/configuration/inventory.ini`

        nano ~/ryo-projects/ryo-simple-blog-grav/configuration/inventory.ini

5. Enter the project directory and run the local setup script

        cd ~/ryo-projects/ryo-simple-blog-grav
        ./local-setup.sh

6. Run the host setup script

        ./host-setup.sh

7. Run the image build script

        ./build-images.sh -v <VERSION> -w <WEBHOOK VERSION, OPTIONAL> -g <GRAV VERSION, OPTIONAL>

8. Run the deployment script

        ./deploy-project.sh -v <VERSION>
