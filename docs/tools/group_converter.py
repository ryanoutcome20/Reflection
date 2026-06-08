import re
import requests
import pyperclip

group = pyperclip.paste().strip()

if not group:
    raise SystemExit("Clipboard is empty.")

url = f"https://steamcommunity.com/groups/{group}/memberslistxml/?xml=1"

response = requests.get(
    url,
    headers={
        "User-Agent": "Mozilla/5.0"
    },
    timeout=30,
)

response.raise_for_status()

xml = response.text

ids = re.findall(r"<steamID64>(\d+)</steamID64>", xml)

txt = (f"\n    -- IDs from /groups/{group}.\n")

for steamid in ids:
    txt += (f'    {{"{steamid}", CG.."{group}"}},\n')

print(txt)
pyperclip.copy(txt)