# DigitalOcean CoreOS Express Demo

Demo repo that will stand up CoreOS instances on Digital Ocean and deploy
a simply NodeJS hello world app to that infastructure.  Also sets up HAProxy
as an LB to the expres web servers.

## Instructions

You must specify a DO_AUTH environment variable, which is your OAuth key for 
Digital Ocean, or store it in your home folder as `.doauth`. Then follow these
instructions for set up.  Currently the IMAGE is hardcoded to use my demo instance,
which you won't be able to pull or push to.  Just change all references in unit
files and the scripts to your own quay.io repo to test it.

1. Run `./bin/create_cluster.sh`.  This will stand up 3 512 mb CoreOS Beta 
instances.
2. While this comes up you can test the nodejs app by running `./bin/runloca.sh`
3. Once the DO instances are up you can initialize them by running `./bin/deploy.sh`
This will take your built image you tested with `./bin/runlocal.sh`, push it your
repo, and then transfer and run all the unit files for the demo app, registrator,
and haproxy.  The script attempts to guess the IP to use from the DO API, it will
grab the first one it finds.  You can overwrite with an IP of your own choosing
if you have other instances under this account by setting the environment variable
`DO_IP`.
4. Check with `fleetctl` once all the unit files are up.  When they are you should
be able to access the hello world app via the haproxy lb.
5. Finally, you can make changes and redeploy the app with `./bin/redeploy.sh`.
