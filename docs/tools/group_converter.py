import time
import pyperclip
import requests
import xml.etree.ElementTree as ET

group = pyperclip.paste().strip()

if not group:
    raise SystemExit("Clipboard is empty.")

session = requests.Session()
session.headers.update({
    "User-Agent": "Mozilla/5.0"
})

url = f"https://steamcommunity.com/groups/{group}/memberslistxml/?xml=1"

ids = []

while url:
    print(f"Fetching: {url}")

    response = session.get(url, timeout=30)
    response.raise_for_status()

    root = ET.fromstring(response.text)

    for node in root.findall(".//steamID64"):
        if node.text:
            ids.append(node.text.strip())

    next_page = root.find(".//nextPageLink")

    if next_page is not None and next_page.text:
        url = next_page.text.strip()
        time.sleep(1.0)  # avoid Steam rate limiting
    else:
        url = None

txt = f"\n    -- IDs from /groups/{group}.\n"

for steamid in ids:
    txt += f'    {{"{steamid}", CG.."{group}"}},\n'

print(f"Collected {len(ids)} SteamIDs.")
print(txt)

pyperclip.copy(txt)