#!/bin/bash
# Unit tests for svn-ignore.bash
#
# Copyright (C) 2009 Andrea Francia Trivolzio(PV) Italy
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  
# 02110-1301, USA.

set -o errexit
set -o nounset

function test-add-first-ignore-in-cur-dir() {
  setup-test-repo-and-wc
  
  (
    cd wc
    svn-ignore-add path-to-ignore
  )
  
  assertEquals "path-to-ignore" "$(svn-ignore-list wc)"
}

function test-add-first-ignore-in-other-dir() {
  setup-test-repo-and-wc
  
  svn-ignore-add wc/path-to-ignore
  
  assertEquals "path-to-ignore" "$(svn-ignore-list wc)"
}

function test-append-second-ignore() {
  setup-test-repo-and-wc
  
  (
    cd wc
    svn-ignore-add first-path-to-ignore
    svn-ignore-add second-path-to-ignore
  )
  
  assertEquals "first-path-to-ignore
second-path-to-ignore" "$(svn-ignore-list wc)"
}

function test-append-second-ignore-on-other-dir() {
  setup-test-repo-and-wc
  
  svn-ignore-add wc/first-path-to-ignore
  svn-ignore-add wc/second-path-to-ignore
  
  assertEquals "first-path-to-ignore
second-path-to-ignore" "$(svn-ignore-list wc)"
}

function test-get-current-ignore-list() {
  setup-test-repo-and-wc
  (
    cd wc
    svn-ignore-add my-path-to-ignore
  )
  
  assertEquals "my-path-to-ignore" "$(svn-ignore-list wc)"
}


function test-that-repo-is-clean() {
  setup-test-repo-and-wc

  local ignore="$(svn-ignore-list wc)"
  
  assertEquals "" "$ignore"
}

function setup-test-repo-and-wc() {
  rm -Rf repo
  rm -Rf wc
  svnadmin create repo >/dev/null
  svn co file://$(pwd)/repo wc >/dev/null
}

