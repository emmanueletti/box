#!/usr/bin/env bash

set -euo pipefail

case $TERM in
    foot|foot-*)
        echo sixels
        ;;
    *)
        echo symbols
        ;;
esac
