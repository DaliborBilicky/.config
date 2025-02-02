#!/bin/bash

IGNORE_LIST=("bash" "kitty" "lsd" "nvim" "starship" "confupdate.sh")

if [ ! -d ".git" ]; then
    echo "Error: This is not a Git repository!"
    exit 1
fi

> .gitignore

if [ -d "$HOME/.config" ]; then
	ls -1 $HOME/.config | grep -v -e '^.$' -e '^..$' >> .gitignore
else
    echo "Warning: .config directory not found!"
fi

for item in "${IGNORE_LIST[@]}"; do
    sed -i "s|^$item\$|#$item|" .gitignore
done

echo "Updated .gitignore:"
cat .gitignore
git add .
git commit
git push origin main
