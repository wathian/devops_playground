#!/bin/bash

set -euxo pipefail

BRANCH=master
git clone https://github.com/wathian/govtech_devops_2022.git
git checkout $BRANCH
git pull origin $BRANCH