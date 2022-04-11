#!/usr/bin/env bash

# shellcheck disable=SC2155
export DIARY_BASE_DIR="${HOME}/diary.d";
export DIARY_CURRENT_DIR="${DIARY_BASE_DIR}/$(date +%Y/%m/%d)";
