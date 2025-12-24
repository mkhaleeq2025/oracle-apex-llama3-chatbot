#!/bin/bash

# Update system packages
sudo apt update -y

# Install curl if not present
sudo apt install -y curl

# Install Ollama
curl -fsSL https://ollama.com/install.sh | sh

# Verify installation
ollama --version

# Pull LLaMA 3 model
ollama pull llama3

# Start Ollama service
ollama serve

# How to Run It (on OCI VM)
chmod +x install_ollama.sh
./install_ollama.sh
