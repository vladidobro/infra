#!/bin/bash
nix flake lock --update-input secrets --update-input homepage
