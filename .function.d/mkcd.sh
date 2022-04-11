#!/usr/bin/env bash

function mkcd() { mkdir -p "$@" && cd "$_"; }
function mkcdgit() { mkdir -p "$@" && cd "$_" && git init; }
