VAGRANT_BOX_NAME="ubuntu_config_scripts_base"

rm -rf ubuntu-config-scripts
mkdir ubuntu-config-scripts
mkdir ubuntu-config-scripts/bin
mkdir ubuntu-config-scripts/tmp

cp -r ../run.sh ubuntu-config-scripts/run.sh
cp -r ../run_in_vagrant.sh ubuntu-config-scripts/run_in_vagrant.sh
cp -r ../bin/* ubuntu-config-scripts/bin/

vagrant destroy -f

vagrant up
vagrant halt
