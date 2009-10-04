#!/bin/bash

set -o errexit
set -o nounset

function svn-ignore-add() {
  local path_to_ignore="$1"
  svn-ignore-add-to-dir "$(basename "$path_to_ignore")" "$(dirname "$path_to_ignore")"
}

function svn-ignore-add-to-dir() {
  local path_to_ignore="$1"
  local working_dir="$2"
  local new_ignore_list="$(concat-to-current-ignore-list "$working_dir" "$path_to_ignore" )"
  update-ignore-list-on "$new_ignore_list" "$working_dir"
}

function update-ignore-list-on () {
  local ignore_list="$1"
  local working_copy="$2"
  svn propset svn:ignore "$ignore_list" "$working_copy" >/dev/null
}

function concat-to-current-ignore-list() {
  local working_dir="$1"
  local new_path_to_ignore="$2"

  {
    svn-ignore-list "$working_dir"
    echo "$new_path_to_ignore"
  } | discard-empty-lines
}

function svn-ignore-list() {
  local wc_path="$1"
  svn propget svn:ignore "$wc_path"
}

function discard-empty-lines() {
  sed '/^\s*$/d'
}


