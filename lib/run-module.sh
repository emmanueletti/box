#!/usr/bin/env bash

run_module() {
  local module_root=$1
  local label
  label="$(basename "$module_root")"

  shopt -s nullglob

  echo "📦 box: $label"

  for step in "${module_root}"/[0-9]*.sh; do
    "$step"
  done
}
