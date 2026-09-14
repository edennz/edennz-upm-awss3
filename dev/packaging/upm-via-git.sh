#!/bin/bash

#
# Package as Unity Package Manager (upm) via git branch.
#
# Copyright 2024, Eden Networks Limited
# Author(s): Philip Lamb
#
# Set environment variable PACKAGE_NAME to the name of the subfolder in Packages
# that contains the package to be packaged.
#


# fail if any commands fails
set -e
# debug log
set -x

# Get our location.
OURDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
SOURCE_ROOT="$OURDIR/../.."
PACKAGE_PATH="Packages/${PACKAGE_NAME}"

git config --global user.name 'Eden Networks Git Operations'
git config --global user.email 'gitmaster@eden.net.nz'

cd "${SOURCE_ROOT}"

# Do a subtree split of the package folder into the upm branch.
git branch -d upm &> /dev/null || echo upm branch not found
git subtree split -P "${PACKAGE_PATH}" -b upm
git checkout upm

# Ensure package includes lfs config.
git fetch origin main
git checkout origin/main -- .gitattributes
git add .gitattributes

# Fixup samples so meta files are ignored.
if [[ -d "Samples" ]]; then
  git mv Samples Samples~
  rm -f Samples.meta
fi
git commit -am "upm packaging"

# Force-push the upm branch.
git push -f -u origin upm
