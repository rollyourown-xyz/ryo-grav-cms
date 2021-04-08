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

3. Add settings to the project's configuration file

        nano ~/ryo-projects/ryo-simple-blog-grav/configuration/configuration.yml

4. Add the host public IP address to the inventory `~/ryo-projects/ryo-simple-blog-grav/configuration/inventory.ini`

        nano ~/ryo-projects/ryo-simple-blog-grav/configuration/inventory.ini

5. Change the path to the configuration file in config_path.yml **if** you have moved the configuration file **or** are not using the working directory `ryo-projects` as above

6. Run the local setup script from the project directory

        cd ~/ryo-projects/ryo-simple-blog-grav
        ./local-setup.sh

7. Run the host setup script from the project directory

        cd ~/ryo-projects/ryo-simple-blog-grav
        ./host-setup.sh

8. Run the image build script from the project directory

        cd ~/ryo-projects/ryo-simple-blog-grav
        ./build-images.sh -v <VERSION> -w <WEBHOOK VERSION, OPTIONAL> -g <GRAV VERSION, OPTIONAL>

9. Run the deployment script from the project directory

        cd ~/ryo-projects/ryo-simple-blog-grav
        ./deploy-project.sh -v <VERSION>
