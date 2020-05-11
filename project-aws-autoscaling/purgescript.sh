#!/bin/bash
#Purge Node Wheneven it is stopped
#Setup Configuration Variables First

momhostname=<MoM Hostname>
rbactoken=<RBAC Token>
cerfile=<certfile name>
keyfile=<keyfile name>

#Node Purge APIs
/bin/curl -X PUT \
--tlsv1 \
--cacert /home/awsnodemanagement/ca.pem \
--cert /home/awsnodemanagement/${cerfile} \
--key /home/awsnodemanagement/${keyfile} \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d '{"desired_state":"revoked"}' \
https://${momhostname}:8140/puppet-ca/v1/certificate_status/$HOSTNAME

/bin/curl -X DELETE \
--tlsv1 \
--cacert /home/awsnodemanagement/ca.pem \
--cert /home/awsnodemanagement/${cerfile} \
--key /home/awsnodemanagement/${keyfile} \
-H "Accept: application/json" \
https://${momhostname}:8140/puppet-ca/v1/certificate_status/$HOSTNAME

/bin/curl -X POST \
--tlsv1 \
--cacert /home/awsnodemanagement/ca.pem \
--cert /home/awsnodemanagement/${cerfile} \
--key /home/awsnodemanagement/${keyfile} \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-d "{\"command\":\"deactivate node\",\"version\":3,\"payload\":{\"certname\":\"$HOSTNAME\"}}" \
https://${momhostname}:8081/pdb/cmd/v1

#trigger a MoM agent run to inform the compiler has been purged
/bin/curl -k -H "X-Authentication:${rbactoken}" \
https://${momhostname}:8143/orchestrator/v1/command/deploy \
-X POST -d "{\"environment\":\"production\",\"scope\": {\"nodes\":  [\"${momhostname}\"]}}" \
-H "Content-Type: application/json"

#Remove local SSL keys so that agent is runable next time it is booted up.
rm -rf /etc/puppetlabs/puppet/ssl

