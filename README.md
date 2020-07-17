This is intended to work with linux, MAC, Windows...

## Step#1) Clone this repo
    ```
    git clone git@github.com:nephomaniac/sos_venv.git 
    cd sos_venv
    ```
## Step#2) Install vagrant and virtual box on your host machine 
ie ubuntu:
```
sudo apt-get install virtualbox
sudo apt-get install vagrant
```
(note: If you see a bunch of Ruby errors when running vagrant then you probably want to grab a more recent version
           of vagrant then the one provided by apt-get. 
           You can download the binary and copy it to ${which vagrant} from 
           https://www.vagrantup.com/downloads, or build from ghub, etc.)      


## Step#3) Install srg-sources on your local machine (/opt/srg-sources) 
If you dont have them cloned already do this:   
(First install git lfs. See here for more info: https://github.com/git-lfs/git-lfs/wiki/Installation)
```
    sudo apt-get install git-lfs
    git lfs install
    git lfs clone git@bitbucket.org:smartrg/srg-sources.git /opt/srg-sources
```
(Note: You can have multiple srg-source dirs, just make sure you edit the Vagrant file to sync
 the correct one to the VM. See this line: 
 config.vm.synced_folder "/opt/srg-sources", "/opt/srg-sources", create: true)


## Step#4) Setup SSH for git, etc..  
Vagrant is set to forward the keys so no need to copy to the VM. 
This requires adding the key(s) you want added to your local ssh-agent. 
Example exporting a key named 'id_rsa' (this key should be ~/.ssh/ on your host machine)
 ```
    eval \"$(ssh-agent -s)\"
    ssh-add ~/.ssh/id_rsa" >&2
 ```
 For some environments you may need to add extra config to your .ssh/config, such as
 config lines to add to keychain or the sshagent. 
 For Ubuntu I found basic config like below worked fine...
 Example from .ssh/config...
 ```
    host github.com
        user git
        identityfile ~/.ssh/my_ghub_rsa

    host bitbucket.org
        user git
        identityfile ~/.ssh/id_rsa 
 ```
## Step#5) Run the VM
```
    cd sos_venv/
    vagrant up
```

## Step #6) Build sos
```
    cd sos_venv/
    vagrant ssh
``` 
From within the VM run your commands to build. 
sos init && sos bld -t raptor
    
    
### Managing the VM:
Using vagrant commands, the box can be:
- reloaded (w/ or w/o --provision) to apply new Vagrantfile config. 
- suspended
- provisioned (ie to test changes or reapply things run in bootstrap.sh)
- destroyed - clean removal of all the artifacts. Just 'vagrant up' again to start with a clean new build env when you're ready. 
  
### Next Steps, things to try:
- Try syncing with a cloned sos dir on the host via the Vagrantfile
- Adjust the boostrap.sh to add commands to sos init and bld upon vm launch. 
    
    
