#!/usr/bin/env bash
nixos-rebuild switch \
    --flake ".#kulich" \
    --fast \
    --build-host root@kulich \
    --target-host root@kulich
