#!/bin/bash

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

