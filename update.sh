#!/bin/bash
nix flake lock \
    --update-input secrets \
    --update-input homepage \
    --update-input svatba \
    --update-input svatba-dashboard \

