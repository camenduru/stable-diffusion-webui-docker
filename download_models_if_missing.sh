#!/bin/bash

# Check if the files exist
if [ ! -f models/Stable-diffusion/oilPainting_oilPaintingV10.safetensors ]; then
    # Download the file
    echo "Downloading Sorolla Model..."
    wget https://civitai.com/api/download/models/23979 -O models/Stable-diffusion/oilPainting_oilPaintingV10.safetensors
    echo "Successfuly downloaded Sorolla Model"
fi
