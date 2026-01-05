import os
import glob

files = glob.glob('*622-68-4*.xml')
print('Found files:', files)

if files:
    filename = files[0]
    print(f'Reading file: {filename}')
    with open(filename, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    print(f'File length: {len(content)}')
    print('\nFull content:')
    print(content)
    with open('full_content.txt', 'w', encoding='utf-8') as f:
        f.write(content)
    print('\nSaved to full_content.txt')
