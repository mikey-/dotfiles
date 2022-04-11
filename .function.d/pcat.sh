#!/usr/bin/env bash

pcat () {
  pygmentize -g "$@" | cat;
}
