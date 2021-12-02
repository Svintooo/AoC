#!/usr/bin/env bash
set -Eeuo pipefail
dir="$(dirname "$(realpath "$0")")"
cd "$dir"


# Puzzle Solution
answer="$( rust-script puzzle_2_solution.crs input )"
echo "Answer: ${answer}"
