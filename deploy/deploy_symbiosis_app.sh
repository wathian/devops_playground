#!/bin/bash

set -eux

eval `ssh-agent`
ssh-add ~/.ssh/gh.wathian.rsa2.pem

##### Prepare Git Repository #####
USERNAME=wathian_github_action
EMAIL=wathian_github_action
REPO=git@github.com:wathian/devops_playground.git
DIR=/app/govtech_devops_2022
BRANCH=uat

if [ ! -d "$DIR" ]; then
    git clone $REPO $DIR
fi
cd $DIR
git config --global user.name "$USERNAME"
git config --global user.email "$EMAIL"
git remote set-url origin $REPO
git remote -v
git fetch --all

LOCAL_BRANCH_EXIST=$(git branch --list $BRANCH)
REMOTE_BRANCH_EXIST=$(git branch --list -r origin/$BRANCH)
if [[ $LOCAL_BRANCH_EXIST != "" ]]; then 
    # check existance of local branch
    git checkout $BRANCH
else
    # if don't have, create one locally
    git checkout -b $BRANCH
fi

if [[ $REMOTE_BRANCH_EXIST == "" ]]; then
    # create remote branch if don't have
    git push origin -u $BRANCH
else
    # else set local branch to track upstream
    git branch --set-upstream-to=origin/$BRANCH $BRANCH
fi

# Consideration: allow direct push to uat but might introduce conflict
git pull origin $BRANCH

##### Prepare Version & Git Tag #####
# Format: v1.2.3
CURRENT_TAG=$(git ls-remote --tags --sort=-v:refname | head -n 1 | awk -F/ '{print $3}')
echo "[CURRENT] Tag: $CURRENT_TAG"
NEW_TAG=$(echo $CURRENT_TAG | awk -F. '{OFS="."; gsub("v", ""); $3+=1; print "v"$0}')
echo "[NEW] Tag: $NEW_TAG"

##### Merge Git Tag #####

##### Push Git Tag #####
git tag -f $NEW_TAG HEAD
git push origin $NEW_TAG

##### Prepare Symbiosis Application #####
rm -rf node_modules/
npm install

##### Start Symbiosis Application #####
set +e
APP_STATUS=$(sudo systemctl is-active symbiosis-app.service)
if [ $APP_STATUS == "active" ] ; then
    sudo systemctl stop symbiosis-app.service
fi

sudo systemctl import-environment ENV=$BRANCH
sudo systemctl enable symbiosis-app.service
sudo systemctl daemon-reload
sudo systemctl start symbiosis-app.service
sudo systemctl status symbiosis-app.service
# Useful
# sudo systemctl stop symbiosis-app.service
# Returns 0 (active) | >0 (inactive)
# sudo systemctl is-active symbiosis-app.service