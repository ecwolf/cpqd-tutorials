.DEFAULT_GOAL := all

DOC_DIR := "doc"
PYBINDPLUGIN := $(shell python3 -c 'import pyangbind; import os; print("{}/plugin".format(os.path.dirname(pyangbind.__file__)))')

validate:
	# generate doc
	pyang demo-port.yang -f tree -o "$(DOC_DIR)/demo-port.tree"
	pyang demo-port.yang -f jstree -o "$(DOC_DIR)/demo-port.html"
	pyang demo-port.yang -f uml -o "$(DOC_DIR)/demo-port.uml"
	# finally validate - Not ready yet
	pyang demo-port.yang --ietf

build:
	# generate / compile python model
	pyang --plugindir $(PYBINDPLUGIN) -f pybind -o demo_port.py demo-port.yang

test:
	# test the example ped files against the model
	python3 -m pytest -s -v

all: validate build test

clean:
	rm doc/*
