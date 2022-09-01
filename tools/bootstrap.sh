#!/bin/bash
set -eo pipefail
RED='\033[1;31m'
NC='\033[0m' # No Color

# Install dependencies
echo -e "${RED}Installing *nix dependency packages...${NC}"
sudo apt install libpng-dev libjpeg-dev libtre-dev libfreetype6-dev qt5-default libqt5svg5-dev -y

# cd into the directory this script is located
cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null

# Move into the repo root and use it as the working dir
cd "$(git rev-parse --show-cdup)"
git_root="$(pwd)"
ext_dir="${git_root}/external"

# Download dependencies
echo -e "${RED}Cloning dependencies...${NC}"
dependencies=(CQUtil CConfig CFont CImageLib CMath CFile CFileUtil CStrUtil CRegExp CGlob CUtil COS)
for dep in "${dependencies[@]}"; do
    if [[ ! -d "$ext_dir/$dep" ]]; then
        echo -e "${RED}--- Clone $dep ---${NC}"
        git clone "git@github.com:colinw7/${dep}.git" "$ext_dir/$dep"
        echo
    fi
done

# Build dependencies and project
echo -e "${RED}Building dependencies...${NC}"
for dep in "${dependencies[@]}"; do
    if [[ -d $ext_dir/$dep ]]; then
        echo -e "${RED}--- Build $dep ---${NC}"
        (cd "$ext_dir/$dep" && make)
        echo
    fi
done
echo -e "${RED}All dependencies built successfully!${NC}"

# Build CQPropertyView targets
echo
echo -e "${RED}--- Build CQPropertyView (src) ---${NC}"
(cd "${git_root}/src" && qmake && make)

echo
echo -e "${RED}--- Build CQPropertyView (test) ---${NC}"
(cd "${git_root}/test" && qmake && make)

