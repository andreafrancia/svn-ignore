#!/bin/bash
# Bash utility commands for handling svn:ignore properties
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

function svn-ignore-add() {
  local path_to_ignore="$1"
  svn-ignore-add-to-dir "$(basename "$path_to_ignore")" "$(dirname "$path_to_ignore")"
}

function svn-ignore-add-to-dir() {
  local path_to_ignore="$1"
  local working_dir="$2"
  local cur_ignore_list="$(svn-ignore-list "$working_dir")"
  local new_ignore_list="$(concat-ignore-lists "$cur_ignore_list" "$path_to_ignore" )"
  svn-ignore-update-list "$new_ignore_list" "$working_dir"
}

function svn-ignore-update-list() {
  local ignore_list="$1"
  local working_copy="${2:-"."}"
  svn propset svn:ignore "$ignore_list" "$working_copy" >/dev/null
}

function concat-ignore-lists() {
  local cur_ignore_list="$1"
  local new_ignore_item="$2"
  local newline="
"

  echo -n "$cur_ignore_list"
  echo -n "${cur_ignore_list:+$newline}"
  echo -n "$new_ignore_item"  
}

function svn-ignore-list() {
  local wc_path="$1"
  svn propget svn:ignore "$wc_path"
}



