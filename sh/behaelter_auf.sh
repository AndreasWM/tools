#!/usr/bin/env bash
CONTAINER_PATH="$HOME/Dropbox/Harry318/dees/.dees.dat"
SOURCE_PATH="$HOME/Dropbox/Harry318/dees/.source.dat"
MOUNT_POINT="$HOME/Dokumente/dees"

cp "$CONTAINER_PATH" "$SOURCE_PATH"
mkdir -p "$MOUNT_POINT"

veracrypt -t "$SOURCE_PATH" "$MOUNT_POINT"