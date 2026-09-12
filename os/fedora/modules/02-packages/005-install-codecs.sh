#!/usr/bin/env bash

set -euo pipefail

sudo dnf install -y --allowerasing ffmpeg ffmpeg-libs
sudo dnf group install -y multimedia
sudo dnf install -y libavcodec-freeworld
