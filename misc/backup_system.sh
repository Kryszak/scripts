
#!/bin/bash
echo "Creating new system snapshot"
sudo timeshift --create
echo "Clearing oldest snapshot"
sudo timeshift --delete --snapshot $(sudo timeshift --list | grep "0    >" | grep -Eo "[0-9]{4}-[0-9]{2}-[0-9]{2}_[0-9]{2}-[0-9]{2}-[0-9]{2}")
