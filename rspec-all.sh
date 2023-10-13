#!/bin/bash -l
for d in ./cmor-*/ ; do (echo "$d" && cd "$d" && bundle exec rspec -f d); done