#!/bin/bash

set -e
RED='\033[1;31m'
NC='\033[0m' # No Color

# Install dependencies
echo -e "${RED}Installing *nix dependency packages...${NC}"
sudo apt install libpng-dev libjpeg-dev libtre-dev libfreetype6-dev qt5-default libqt5svg5-dev -y

git_root="$(git rev-parse --show-cdup)"
git_root="${git_root:-./}"
ext_dir="${git_root}external"

# Download dependencies
echo -e "${RED}Cloning dependencies...${NC}"
dependencies=(CQUtil CConfig CFont CImageLib CMath CFile CFileUtil CStrUtil CRegExp CGlob CUtil COS)
for dep in "${dependencies[@]}"; do
    if [[ ! -d "$ext_dir/$dep" ]]; then
        echo -e "${RED}--- Clone $dep ---${NC}"
        git clone "https://github.com/colinw7/${dep}.git" "$ext_dir/$dep"
        echo
    fi
done

# Build dependencies and project
echo -e "${RED}Building dependencies...${NC}"
working_dir=$(pwd)
for dep in "${dependencies[@]}"; do
    if [[ -d $ext_dir/$dep/src ]]; then
        echo -e "${RED}--- Build $dep ---${NC}"
        cd "$ext_dir/$dep/src"

        if [[ ! -d ../obj ]]; then
            mkdir ../obj
        fi

        if [[ ! -d ../lib ]]; then
            mkdir ../lib
        fi

        n=$(find . -maxdepth 1 -name "*.pro" | wc -l)
        if [[ $n == 1 ]]; then
            qmake
        fi

        make
        echo
        cd "$working_dir"
    fi
done
echo -e "${RED}All dependencies built successfully!${NC}"

# Build CQPropertyView targets
echo
echo -e "${RED}--- Build CQPropertyView (src) ---${NC}"
(
cd "${git_root}src"
qmake
make
)

echo
echo -e "${RED}--- Build CQPropertyView (test) ---${NC}"
(
cd "${git_root}test"
qmake
make
)

