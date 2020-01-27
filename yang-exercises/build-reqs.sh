#!/usr/bin/env bash

sudo apt-get install git python3-pip libxml2-utils protobuf-compiler golang-go golang-goprotobuf-dev

sudo pip3 install pyang pyangbind pytest

mkdir $HOME/go
mkdir $HOME/go/bin
mkdir $HOME/go/src
mkdir $HOME/go/pkg

sudo echo 'export GOPATH=$HOME/go' >> ~/.profile
sudo echo 'export GOBIN=$HOME/go/bin' >> ~/.profile
sudo echo 'export PATH=$PATH:/usr/local/go/bin:$GOBIN' >> ~/.profile
sudo source ~/.profile

git clone https://github.com/openconfig/ygot
cd ygot 
make install

cd proto_generator/
go install protogenerator.go
cd - 

cd generator 
go install generator.go
cd - 

cd ..
