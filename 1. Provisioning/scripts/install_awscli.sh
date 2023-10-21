#!/usr/bin/env bash

sudo apt-get install unzip -y
sudo apt-get install python3.10-venv -y
curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
unzip awscli-bundle.zip
sudo /usr/bin/python3.10 awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

