#!/usr/bin/env bash

echo "Building the project..."

## Set up the environment
if [ ! -d ".venv" ]; then
    uv init .venv
    source .venv/bin/activate
    uv sync
fi

## Activate the virtual environment
source .venv/bin/activate

## Updating Repository
git pull origin main

# Build the project
cd web
mkdocs build
cd ..

## Deactivate the virtual environment
deactivate
echo "Build complete."
exit 0

