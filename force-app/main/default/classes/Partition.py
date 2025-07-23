import os
import shutil
import re
from collections import defaultdict

def extract_prefix(filename):
    # Extract prefix before second capital word or underscore
    match = re.match(r'^([A-Z][a-z]+)([A-Z][a-z]+)?', filename)
    if match:
        return match.group(1)
    return filename.split('_')[0]

def group_similar_files(directory):
    os.chdir(directory)
    entries = [entry for entry in os.listdir() if os.path.isfile(entry) or os.path.isdir(entry)]

    prefix_map = defaultdict(list)

    for entry in entries:
        prefix = extract_prefix(entry)
        prefix_map[prefix].append(entry)

    for prefix, items in prefix_map.items():
        if len(items) > 1:
            folder_name = f"{prefix}"
            os.makedirs(folder_name, exist_ok=True)
            for item in items:
                try:
                    shutil.move(item, os.path.join(folder_name, item))
                    print(f"Moved: {item} -> {folder_name}")
                except Exception as e:
                    print(f"Could not move {item}: {e}")

    print("\n✅ Grouping completed.")

if __name__ == "__main__":
    path = input("Enter the path to the directory: ").strip()

    if os.path.exists(path):
        group_similar_files(path)
    else:
        print("❌ The provided path does not exist.")
