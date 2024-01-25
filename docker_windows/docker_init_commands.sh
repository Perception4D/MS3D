#!/bin/bash

git config --global --add safe.directory /MS3D

export PYTHONPATH=/MS3D

python ./setup.py develop

cd tracker && pip install -e . --user && cd ..
