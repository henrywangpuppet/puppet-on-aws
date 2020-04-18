#!/bin/sh

#install Puppet Agent
/bin/curl -k https://ip-10-0-0-100.ap-southeast-1.compute.internal:8140/packages/current/install.bash | sudo bash -s main:dns_alt_names=HenryPuppetLB-4a8ce5ed797c777c.elb.ap-southeast-1.amazonaws.com extension_requests:pp_role=awsloadbalancer

#run puppet agent again
#sudo -i puppet agent -t

#Refresh MoM puppet agent run
/bin/curl -k -H 'X-Authentication:0CCOlIZsIOr1fb92ER6iYbZ9RZeeMEiWyyX4U-75gQVI' \
https://ip-10-0-0-100.ap-southeast-1.compute.internal:8143/orchestrator/v1/command/deploy \
-X POST -d '{"environment":"production","scope": {"nodes":  ["ip-10-0-0-100.ap-southeast-1.compute.internal"]}}' \
-H "Content-Type: application/json"

#enable shutdown script
cp /home/ec2-user/nodepurge/nodepurge.service /etc/systemd/system/nodepurge.service
systemctl daemon-reload
systemctl enable nodepurge.service
systemctl start nodepurge.service

#Add startup script if CM is rebooted but not being terminated
#/bin/echo "@reboot rm -rf /etc/puppetlabs/puppet/ssl; sudo -i puppet agent -t" >> /var/spool/cron/root
