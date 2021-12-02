#!/usr/bin/env bash
set -Eeuo pipefail
dir="$(dirname "$(realpath "$0")")"
cd "$dir"


# Puzzle Solution
answer="$( cargo script depth_increase_counter.crs input )"
echo "Answer: ${answer}"
