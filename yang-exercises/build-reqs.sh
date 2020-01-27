#!/usr/bin/env bash

sudo apt-get install git python3-pip libxml2-utils protobuf-compiler golang-go golang-goprotobuf-dev

sudo pip3 install pyang pyangbind pytest unzip

wget https://github.com/protocolbuffers/protobuf/releases/download/v3.11.2/protoc-3.11.2-linux-x86_64.zip
mkdir protoc
mv protoc-3.11.2-linux-x86_64.zip ./protoc
cd protoc
unzip protoc-3.11.2-linux-x86_64.zip
sudo cp ./bin/protoc /usr/local/bin/
sudo cp -R ./include/* /usr/local/include/

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
