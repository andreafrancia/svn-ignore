#!/bin/bash

set -o errexit
set -o nounset

function svn-ignore-add() {
  local path_to_ignore="$1"
  local wc="$(dirname "$path_to_ignore")"
  local new_ignore_list="$(concat-to-current-ignore-list "$wc" "$(basename "$path_to_ignore")" )"
  update-ignore-list-on "$new_ignore_list" "$wc"
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


