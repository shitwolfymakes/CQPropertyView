#!/bin/bash

set -e
RED='\033[1;31m'
NC='\033[0m' # No Color

# Instructions
#    . make empty build directory outside of the repo folder
#    . cp build.sh to empty build directorys
#    . Run ./build.sh

# Install dependencies
echo -e "${RED}Installing *nix dependency packages...${NC}"
sudo apt install libpng-dev libjpeg-dev libtre-dev libfreetype6-dev qt5-default libqt5svg5-dev -y

cdir=`pwd`

echo -e "${RED}Cloning CQPropertyView repo...${NC}"
if [[ ! -d CQPropertyView ]]; then
    git clone https://github.com/colinw7/CQPropertyView.git CQPropertyView
fi

echo -e "${RED}Cloning dependencies...${NC}"
include_paths=$(cat CQPropertyView/src/CQPropertyView.pro | sed ':x; /\\$/ { N; s/\\\n//; tx }' | grep INCLUDEPATH | sed 's/INCLUDEPATH += //')
dependencies=()
for path in $include_paths; do
    n=$(echo $path | grep '..\/..\/' | wc -l)
    if [[ $n != 1 ]]; then
        continue
    fi

    dep_name=$(echo $path | sed 's@../../\(.*\)/include@\1@')
    dependencies+=($dep_name)

    if [[ ! -d $dep_name ]]; then
        echo -e "${RED}--- Clone $dep_name ---${NC}"
        git clone https://github.com/colinw7/${dep_name}.git $dep_name
        echo
    fi
done

# Build dependencies and project
echo -e "${RED}Building dependencies...${NC}"
for dep in ${dependencies[@]}; do
    if [[ -d $cdir/$dep/src ]]; then
        echo -e "${RED}--- Build $dep ---${NC}"
        cd $cdir/$dep/src

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
    fi
done
echo -e "${RED}All dependencies built successfully!${NC}"

echo
echo -e "${RED}--- Build CQPropertyView (src) ---${NC}"
cd $cdir/CQPropertyView/src
qmake
make

echo
echo -e "${RED}--- Build CQPropertyView (test) ---${NC}"
cd $cdir/CQPropertyView/test
qmake
make

