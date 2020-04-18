#!/bin/bash

#Make sure a Puppet run happens before informing MoM
sudo -i puppet agent -t

#trigger a MoM agent run to inform the compiler has been back
/bin/curl -k -H 'X-Authentication:0CCOlIZsIOr1fb92ER6iYbZ9RZeeMEiWyyX4U-75gQVI' \
https://ip-10-0-0-100.ap-southeast-1.compute.internal:8143/orchestrator/v1/command/deploy \
-X POST -d '{"environment":"production","scope": {"nodes":  ["ip-10-0-0-100.ap-southeast-1.compute.internal"]}}' \
-H "Content-Type: application/json"
