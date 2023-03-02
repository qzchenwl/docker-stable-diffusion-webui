#!/bin/bash

cd /content/stable-diffusion-webui
source venv/bin/activate
python3 launch.py "$@"

