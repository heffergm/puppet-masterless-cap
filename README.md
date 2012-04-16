# Masterless puppet deployments with capistrano

## Say what?
* I decided very early on in my experimentation with puppet that maintaining a puppetmaster, scaling it, and dealing with the idiosyncracies therein were non starters from my point of view
* But guess what... you can be your own master! Puppet manifests can be applied with ```puppet apply```, and by specifying a variety of options like --modulepath, it becomes very easy to see how you can use capistrano and multistage to manage your infrastructure
* I've provided a snippet of code that would live in deploy.rb. It allows you to pass a variety of command line options at deploy time to influence the behavior of puppet
* There's also a customized cleanup task to account for the default deploy:cleanup expecting common release directory names on all hosts you're deploying to, which will rarely happen in this sort of setup. The custom task will run in serial across all hosts and ensure there are only :keep_releases kept around.

## Command line options
* ```NOOP=t``` This will apply puppet manifests without actually performing the changes, so you can see the effect of code changes and not actually break anything: ```NOOP=t cap some_stage deploy```
* ```TAGS="monit,users"``` Use the TAGS var to apply specifically tagged modules. Multiple modules can be specified, delimited with commas.
* ```HOSTFILTER=prod-fe-r01``` Limits the deploy to specified hosts. Multiple hosts should be quoted and comma delimited.
* ```MAXHOSTS=50``` Sets the number of concurrent hosts that will issue a git pull against the remote origin.

## Examples
* ```HOSTFILTER="prod-fe-r01,prod-fe-r02" TAGS="monit,iptables" NOOP=t cap prod_fe deploy``` Performs a dry run against prod-fe-r0[1-2] of the modules tagged monit and iptables.
