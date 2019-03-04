#!/usr/bin/env bash

pless () {
  pygmentize -g $@ | less -r;
}

