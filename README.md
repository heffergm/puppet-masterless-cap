# masterless puppet deployments with capistrano

## Command line options
* ```NOOP=t``` This will apply puppet manifests without actually performing the changes, so you can see the effect of code changes and not actually break anything: ```NOOP=t cap some_stage deploy```
* ```TAGS="monit,users"``` Use the TAGS var to apply specifically tagged modules. Multiple modules can be specified, delimited with commas.
* ```HOSTFILTER=prod-fe-r01``` Limits the deploy to specified hosts. Multiple hosts should be quoted and comma delimited.
* ```MAXHOSTS=50``` Sets the number of concurrent hosts that will issue a git pull against the remote origin.

## Examples
* ```HOSTFILTER="prod-fe-r01,prod-fe-r02" TAGS="monit,iptables" NOOP=t cap prod_fe deploy``` Performs a dry run against prod-fe-r0[1-2] of the modules tagged monit and iptables.
