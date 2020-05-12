#!/bin/sh
#Setup Configuration Variables First

momhostname=<MoM hostname>
awslbdns=<AWS LoadBalancer DNS Name>
rbactoken=<RBAC Token>

#install Puppet Agent
/bin/curl -k https://${momhostname}:8140/packages/current/install.bash | sudo bash -s main:dns_alt_names=$awslbdns extension_requests:pp_role=awsloadbalancer -- --puppet-service-ensure stopped

#enable startup and shutdown script
cp /home/awsnodemanagement/nodepurge.service /etc/systemd/system/nodepurge.service
systemctl daemon-reload
systemctl enable nodepurge.service
systemctl start nodepurge.service
