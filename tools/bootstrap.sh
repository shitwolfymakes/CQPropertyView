#!/bin/bash
set -eo pipefail
RED='\033[1;31m'
NC='\033[0m' # No Color

# Install required packages
echo -e "${RED}Installing *nix dependency packages...${NC}"
sudo apt install libpng-dev libjpeg-dev libtre-dev libfreetype6-dev qt5-default libqt5svg5-dev -y

# cd into the directory this script is located
cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &> /dev/null

# Move into the repo root and use it as the working dir
cd "$(git rev-parse --show-cdup)"
git_root="$(pwd)"

# Enumerate required external dependencies
dependencies=(
    CQUtil
    CConfig
    CFont
    CImageLib
    CMath
    CFile
    CFileUtil
    CStrUtil
    CRegExp
    CGlob
    CUtil
    COS
)

# Download and build external dependencies
chmod +x tools/build_dependencies.sh
./tools/build_dependencies.sh ${dependencies[@]}

# Build CQPropertyView targets
echo
echo -e "${RED}--- Build CQPropertyView (src) ---${NC}"
(cd "${git_root}/src" && qmake && make)

echo
echo -e "${RED}--- Build CQPropertyView (test) ---${NC}"
(cd "${git_root}/test" && qmake && make)

