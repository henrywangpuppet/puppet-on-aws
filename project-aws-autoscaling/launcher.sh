#!/bin/sh
#Setup Configuration Variables First

momhostname=<MoM hostname>
awslbdns=<AWS LoadBalancer DNS>
rbactoken=<RBAC Token>

#install Puppet Agent
/bin/curl -k https://${momhostname}:8140/packages/current/install.bash | sudo bash -s main:dns_alt_names=$awslbdns extension_requests:pp_role=awsloadbalancer

#Refresh MoM puppet agent run
/bin/curl -k -H "X-Authentication:${rbactoken}" \
https://${momhostname}:8143/orchestrator/v1/command/deploy \
-X POST -d "{\"environment\":\"production\",\"scope\": {\"nodes\":  [\"${momhostname}\"]}}" \
-H "Content-Type: application/json"

#enable shutdown script
cp /home/ec2-user/nodepurge/nodepurge.service /etc/systemd/system/nodepurge.service
systemctl daemon-reload
systemctl enable nodepurge.service
systemctl start nodepurge.service

