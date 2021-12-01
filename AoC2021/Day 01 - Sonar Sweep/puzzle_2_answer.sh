#!/usr/bin/env bash
set -Eeuo pipefail
dir="$(dirname "$(realpath "$0")")"
cd "$dir"


# Puzzle Solution
./depth_increase_counter_w_measurement_window.crs input
