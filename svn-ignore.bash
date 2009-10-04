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
  local cur_ignore_list="$(svn-ignore-list "$working_dir")"
  local new_ignore_list="$(concat-ignore-lists "$cur_ignore_list" "$path_to_ignore" )"
  update-ignore-list-on "$new_ignore_list" "$working_dir"
}

function update-ignore-list-on () {
  local ignore_list="$1"
  local working_copy="$2"
  svn propset svn:ignore "$ignore_list" "$working_copy" >/dev/null
}

function concat-ignore-lists() {
  local cur_ignore_list="$1"
  local new_ignore_item="$2"

  {
    echo "$cur_ignore_list"
    echo "$new_ignore_item"
  }
}

function svn-ignore-list() {
  local wc_path="$1"
  svn propget svn:ignore "$wc_path"
}

function discard-empty-lines() {
  sed '/^\s*$/d'
}


