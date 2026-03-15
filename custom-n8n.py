
#!/usr/bin/env python3
import sys
import json
import requests
from requests.auth import HTTPBasicAuth

# Read configuration parameters
alert_file = open(sys.argv[1])
hook_url = sys.argv[3]

# Read the alert file
alert_json = json.loads(alert_file.read())
alert_file.close()

# Extract issue fields
alert_level = alert_json['rule']['level']
ruleid = alert_json['rule']['id']
description = alert_json['rule']['description']
agentname = alert_json['agent']['name']
agentip = alert_json['agent']['ip']
source_ip = alert_json['data']['src_ip']
dest_ip = alert_json['data']['dest_ip']
alert_category = alert_json['data']['alert']['category']

# Generate request
headers = {'content-type': 'application/json'}
issue_data = {"alert_level": alert_level,"rule_id": ruleid,"description": description,"alert_category": alert_category,"agent": {"name": agentname,"ip": agentip},"network": {"source_ip": source_ip,"destination_ip": dest_ip}}

# Send the request
response = requests.post(hook_url, data=json.dumps(issue_data), headers=headers)

sys.exit(0)