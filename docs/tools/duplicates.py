import re
import sys

KEY_RE = re.compile(r'^\s*\[\s*"([^"]+)"\s*\]')

def remove_duplicates(input_file, output_file):
    seen = set()

    with open(input_file, "r", encoding="utf-8") as f:
        lines = f.readlines()

    result = []

    for line in lines:
        match = KEY_RE.match(line)

        if match:
            key = match.group(1)

            if key in seen:
                continue

            seen.add(key)

        result.append(line)

    with open(output_file, "w", encoding="utf-8") as f:
        f.writelines(result)

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print(f"Usage: {sys.argv[0]} input.lua output.lua")
        sys.exit(1)

    remove_duplicates(sys.argv[1], sys.argv[2])