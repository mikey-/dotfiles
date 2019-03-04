#!/usr/bin/env bash

function mkcd() { mkdir -p "$@" && cd "$_"; }
function gmkcd() { mkdir -p "$@" && cd "$_" && git init; }
