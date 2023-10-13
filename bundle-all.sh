#!/bin/bash -l
gem update --system
bundle

for d in ./cmor-*/ ; do (cd "$d" && bundle); done
