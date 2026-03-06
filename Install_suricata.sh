# Run this command to add the repository to your system and update the list of available packages: 
sudo add-apt-repository ppa:oisf/suricata-stable

# Install package:
sudo apt install suricata

# Configuring Suricata: 
sudo nano /etc/suricata/suricata.yaml

# Find line 120 which reads # Community Flow ID. 
# If you are using nano type CTRL+_ and then 120 when prompted to enter a line number. 
# Below that line is the community-id key. Set it to true to enable the setting:
       # Community Flow ID
      # Adds a 'community_id' field to EVE records. These are meant to give
      # records a predictable flow ID that can be used to match records to
      # output of other tools such as Zeek (Bro).
      #
      # Takes a 'seed' that needs to be same across sensors and tools
      # to make the id less predictable.

      # enable/disable the community id feature.
      community-id: true

# Determine which network interface to use: 
ip -p -j route show default  #The -p flag formats the output to be more readable, and the -j flag prints the output as JSON.

# Edit the configuration file again to change or verify the interface name:
 # Linux high speed capture support
af-packet:
  - interface: eth0 # Substitute your interface name here. 
    # Number of receive threads. "auto" uses the number of cores
    #threads: auto
    # Default clusterid. AF_PACKET will load balance packets based on flow.
    cluster-id: 99

# add this to the bottom of the configuration file so you can add and edit rules without Suricata restart:
detect-engine:
  - rule-reload: true

# With this setting in place, you will be able to send the SIGUSR2 system signal to the running process, and Suricata will reload any changed rules into memory.
sudo kill -usr2 $(pidof suricata)

# Download up to date ruleset from Suricata server:
sudo suricata-update

# List default ruleset providers :
sudo suricata-update list-sources

# ADD rule set providers:
sudo suricata-update enable-source tgreen/hunting  # Add tgreen/hunting

# Validate configuration:
sudo suricata -T -c /etc/suricata/suricata.yaml -v # Must be succesful, otherwise Suricata is not correctly configured.

# Start Suricata:
sudo systemctl start suricata.service

# Verify Log entries:
grep 2100498 /var/log/suricata/fast.log  # grep for specific test case, use cat to view the contenct of the log file. 

# View JSON log entries using the jq utility (must be installed first):
jq 'select(.alert .signature_id==2100498)' /var/log/suricata/eve.json # 'select(...)' is a filter to extract log entries with specific values. 