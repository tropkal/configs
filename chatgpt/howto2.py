#!/usr/bin/env python3
from openai import OpenAI

client = OpenAI(api_key=f.read().strip())
import sys
import os

dir_path = os.path.dirname(os.path.realpath(__file__))

# !!!You need an API key!!!
# https://platform.openai.com/account/api-keys
with open(f"{dir_path}/.gpt_api_key.txt") as f:
  

arg = ' '.join(sys.argv[1:])

r = client.chat.completions.create(model="gpt-3.5-turbo",
#model="gpt-4",
messages=[
      {"role": "system", "content": "You are ChatGPT, a large language model trained by OpenAI. Answer as concisely as possible."},
      {"role": "user", "content": f"{arg}"}
  ])

text = r["choices"][0]["message"]["content"]
if text.startswith('`') and text.endswith('`'):
  text = text[1:-1]

print(text)
