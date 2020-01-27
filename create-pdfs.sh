#!/bin/bash

pandoc --pdf-engine=xelatex -V colorlinks -V urlcolor=NavyBlue -V toccolor=Red --highlight-style zenburn  onos-tutorial.md -o  onos-tutorial.pdf

pandoc --pdf-engine=xelatex  osm-tutorial.md -o  osm-tutorial.pdf

pandoc --pdf-engine=xelatex  yang-tutorial.md -o  yang-tutorial.pdf
