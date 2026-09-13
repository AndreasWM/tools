#!/usr/bin/env bash
CONTAINER_PATH="$HOME/Dropbox/Harry318/dees/.dees.dat"
MOUNT_POINT="$HOME/Dokumente/dees"

mkdir -p "$MOUNT_POINT"

veracrypt -t "$CONTAINER_PATH" "$MOUNT_POINT"