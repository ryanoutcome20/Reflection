import re

TAG = "steamID64"
NOTE = "Cheating Group"
HEADER = "IDs from /groups/"

text = []

print("Paste entries, then press Ctrl+D (Linux/macOS) or Ctrl+Z Enter (Windows):")

try:
    while True:
        text.append(input())
except EOFError:
    pass

pattern = re.compile(
    rf"<{re.escape(TAG)}>(.*?)</{re.escape(TAG)}>"
)

ids = pattern.findall("\n".join(text))

if HEADER:
    print(f"-- {HEADER}")

for steamid in ids:
    print(f'    ["{steamid}"] = true, -- {NOTE}')