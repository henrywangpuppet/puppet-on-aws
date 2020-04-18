#!/bin/bash
#Purge Node Wheneven it is stopped

/bin/curl -X PUT \
--tlsv1 \
--cacert /home/ec2-user/nodepurge/ca.pem \
--cert /home/ec2-user/nodepurge/aws-lambada.example.com.pem \
--key /home/ec2-user/nodepurge/aws-lambada.example.com.key.pem \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"desired_state":"revoked"}' \
https://ip-10-0-0-100.ap-southeast-1.compute.internal:8140/puppet-ca/v1/certificate_status/$HOSTNAME

/bin/curl -X DELETE \
--tlsv1 \
--cacert /home/ec2-user/nodepurge/ca.pem \
--cert /home/ec2-user/nodepurge/aws-lambada.example.com.pem \
--key /home/ec2-user/nodepurge/aws-lambada.example.com.key.pem \
-H "Accept: application/json" \
https://ip-10-0-0-100.ap-southeast-1.compute.internal:8140/puppet-ca/v1/certificate_status/$HOSTNAME

/bin/curl -X POST \
--tlsv1 \
--cacert /home/ec2-user/nodepurge/ca.pem \
--cert /home/ec2-user/nodepurge/aws-lambada.example.com.pem \
--key /home/ec2-user/nodepurge/aws-lambada.example.com.key.pem \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d "{\"command\":\"deactivate node\",\"version\":3,\"payload\":{\"certname\":\"$HOSTNAME\"}}" \
https://ip-10-0-0-100.ap-southeast-1.compute.internal:8081/pdb/cmd/v1

#trigger a MoM agent run to inform the compiler has been purged
/bin/curl -k -H 'X-Authentication:0CCOlIZsIOr1fb92ER6iYbZ9RZeeMEiWyyX4U-75gQVI' \
https://ip-10-0-0-100.ap-southeast-1.compute.internal:8143/orchestrator/v1/command/deploy \
-X POST -d '{"environment":"production","scope": {"nodes":  ["ip-10-0-0-100.ap-southeast-1.compute.internal"]}}' \
-H "Content-Type: application/json"

#Remove local SSL keys so that agent is runable next time it is booted up.
rm -rf /etc/puppetlabs/puppet/ssl

