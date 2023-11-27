#!/usr/bin/env python3
from openai import OpenAI
import sys
import os

dir_path = os.path.dirname(os.path.realpath(__file__))

# !!!You need an API key!!!
# https://platform.openai.com/account/api-keys
with open(f"{dir_path}/.gpt_api_key.txt", "r") as f:
    api_key = f.readline().strip()
    client = OpenAI(api_key=api_key)


arg = """ """.join(sys.argv[1:])

r = client.chat.completions.create(model="gpt-3.5-turbo",
    # model="gpt-4",
    messages=[
        {"role": "system", "content": "You are ChatGPT, a large language model trained by OpenAI. Answer as concisely as possible."},
        {"role": "user", "content": f"Answer with only the actual command without any intro or explanation. What is the ubuntu command line command to {arg}"}
    ]
)

response = r.choices[0].message.content
if response.startswith('`') and response.endswith('`'):
    response = response[1:-1]

print(response)
