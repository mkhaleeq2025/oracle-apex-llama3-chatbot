#!/bin/bash

curl http://localhost:11434/api/generate \
  -H "Content-Type: application/json" \
  -d '{
    "model": "llama3",
    "prompt": "Explain Oracle APEX in one sentence."
  }'


# Run it

chmod +x test_llama3_api.sh
./test_llama3_api.sh
