#!/bin/bash
set -eo pipefail
RED='\033[1;31m'
NC='\033[0m' # No Color

dependencies=($@)
echo "Dependencies passed: ${dependencies[@]}"

# cd into the directory this script is located
cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null

# Move into the repo root and use it as the working dir
cd "$(git rev-parse --show-cdup)"
git_root="$(pwd)"
ext_dir="${git_root}/external"

function dep_missing() {
    if [[ ! -d "$1" ]]; then
        # if folder passed as an argument does not exist
        return 0 # true
    elif [[ -z "$(ls -A $1)" ]]; then
        # if folder passed as an argument is empty
        return 0 # true
    fi
    # folder is populated
    return 1 # false
}

# Download dependencies
echo -e "${RED}Cloning dependencies...${NC}"
for dep in "${dependencies[@]}"; do
    if dep_missing "$ext_dir/$dep"; then
        echo -e "${RED}--- Clone $dep ---${NC}"
        git clone "git@github.com:colinw7/${dep}.git" "$ext_dir/$dep"
        echo
    fi
done

# Build dependencies
echo -e "${RED}Building dependencies...${NC}"
for dep in "${dependencies[@]}"; do
    echo -e "${RED}--- Build $dep ---${NC}"
    cd "$ext_dir/$dep/src"

    if [[ ${dep} == "CQUtil" ]]; then
       qmake
       make
    else
        make CC='g++ -fPIC'
    fi

    cd "${git_root}"
    echo
done
echo -e "${RED}All dependencies built successfully!${NC}"
