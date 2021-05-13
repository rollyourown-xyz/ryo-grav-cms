#!/bin/sh

echo "Getting modules from repositories"
echo ""

## Common to all projects - generic host setup repository
echo "Executing 'git submodule add' for ryo-host-setup-generic repository"
git submodule add https://github.com/rollyourown-xyz/ryo-host-setup-generic modules/ryo-host-setup-generic

## Project specific submodules
#echo "Executing 'git submodule add' for <PROJECT MODULE> repository"
#git submodule add https://github.com/rollyourown-xyz/<PROJECT MODULE> modules/<PROJECT MODULE>

#echo "Executing 'git submodule add' for <PROJECT MODULE> repository"
#git submodule add https://github.com/rollyourown-xyz/<PROJECT MODULE> modules/<PROJECT MODULE>
