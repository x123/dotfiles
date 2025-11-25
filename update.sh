#!/bin/sh
set -xe
nix flake update --commit-lock-file
