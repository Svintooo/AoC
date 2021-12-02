#!/usr/bin/env bash
set -Eeuo pipefail
dir="$(dirname "$(realpath "$0")")"
cd "$dir"


# Puzzle Solution
answer="$( cargo script depth_increase_counter_w_measurement_window.crs input )"
echo "Answer: ${answer}"
