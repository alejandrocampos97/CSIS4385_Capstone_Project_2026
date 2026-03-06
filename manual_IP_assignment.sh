# I used this steps to manually assign an IP to my Ubuntu servers
sudo nano /etc/netplan/00-installer-config.yaml

# In nano editor:
network:
  ethernets:
    eth0: #Make sure this matches your interface
      dhcp4: false
      addresses: [192.168.1.10/24] # Enter your IP address in brackets and don't forget the subnest mask in CIDR. 
      routes:
        - to: default
          via: 192.168.1.1 # Your gateway address
      nameservers:
        addresses: # Name server addresses separated by comas between brackets. 
  version: 2

# Apply netplan changes: 
sudo netplan apply 