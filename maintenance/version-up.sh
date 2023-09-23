#!/bin/bash
set -ue

# MIT License
#
# Copyright (c) 2023 Kazuhito Suda
#
# This file is part of FIWARE Small Bang
#
# https://github.com/lets-fiware/FIWARE-Small-Bang
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

LANG=C
LC_TIME=C

version_up() {
  FISB_HOME=$PWD
  OLD=$1
  NEW=$(echo "${OLD}" | awk -F \. -v 'OFS=.' '{print $1, $2+1,$3 }')

  BRANCH="release/${NEW}"
  DATE=$(date "+%d %B, %Y")
  
  git switch -c "${BRANCH}"
  
  sed -i "1s/${OLD}-next/${NEW} - ${DATE}/" "${FISB_HOME}/CHANGELOG.md"
  
  for file in README.md README_ja.md VERSION docs/en/index.md docs/ja/index.md docs/en/installation.md docs/ja/installation.md setup-fiware.sh
  do
    file="${FISB_HOME}/${file}"
    ls -l "${file}"
    sed -i -e "s/${OLD}.tar.gz/${NEW}.tar.gz/" "${file}"
    sed -i -e "s/FIWARE-Small-Bang-${OLD}/FIWARE-Small-Bang-${NEW}/" "${file}"
    sed -i -e "s/${OLD}-next/${NEW}/" "${file}"
    sed -i -e "s/v${OLD}/v${NEW}/" "${file}"
  done
  
  sed -i -e "s/${OLD}-next/${NEW}/" "${FISB_HOME}/config.sh"
  
  sed -i -e "s/${OLD}-next/${NEW}-next/" "${FISB_HOME}/.github/pull_request_template.md"
  sed -i -e "s/${OLD}-next/${NEW}-next/" "${FISB_HOME}/CONTRIBUTING.md"

  sed -i -e "s/${OLD}/${NEW}/" "${FISB_HOME}/SECURITY.md"
  
  git add .
  git commit -m "Bump: ${OLD}-next -> ${NEW}"
  git push origin "${BRANCH}"
}

next_version() {
  FISB_HOME=$PWD
  VER=$1
  
  BRANCH="release/${VER}_next"
  
  git switch -c "${BRANCH}"
  
  for file in VERSION setup-fiware.sh
  do
    file="${FISB_HOME}/${file}"
    ls -l "${file}"
    sed -i -e "s/${VER}/${VER}-next/" "${file}"
  done
  
  sed -i "1i ## FIWARE Small Bang v${VER}-next\n" "${FISB_HOME}/CHANGELOG.md"
  
  git add .
  git commit -m "Bump: ${VER} -> ${VER}-next"
  git push origin "${BRANCH}"
}

main() {
  if ! [ -e VERSION ]; then
    echo "VERSION file not found"
    exit 1
  fi

  VERSION=$(sed "s/VERSION=//" VERSION | sed "s/-next//" | awk -F \. -v 'OFS=.' '{print $1, $2,$3 }')

  set +e
  RESULT=$(grep -ic -next VERSION)
  set -e

  if [ "${RESULT}" -eq 1 ]; then
    version_up ${VERSION}
  else
    echo "next version"
    next_version ${VERSION}
  fi
}

main "$@"
