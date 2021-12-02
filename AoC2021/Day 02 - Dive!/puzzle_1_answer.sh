#!/usr/bin/env bash
set -Eeuo pipefail
dir="$(dirname "$(realpath "$0")")"
cd "$dir"


# Puzzle Solution
rust-script puzzle_1_solution.crs input
