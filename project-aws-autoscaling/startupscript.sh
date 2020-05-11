#!/bin/bash
#Setup Configuration Variable First

momhostname=<MoM Hostname>
rbactoken=<RBAC Token>

#Make sure a Puppet run happens before informing MoM
sudo /opt/puppetlabs/bin/puppet agent -t

#trigger a MoM agent run to inform the compiler has been back
/bin/curl -k -H "X-Authentication:${rbactoken}" \
https://${momhostname}:8143/orchestrator/v1/command/deploy \
-X POST -d "{\"environment\":\"production\",\"scope\": {\"nodes\":  [\"${momhostname}\"]}}" \
-H "Content-Type: application/json"
