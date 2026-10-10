#!/usr/bin/env bash
SOURCE_PATH="$HOME/Dropbox/Harry318/dees/.source.dat"
CONTAINER_PATH="$HOME/Dropbox/Harry318/dees/.dees.dat"
cp "$SOURCE_PATH" "$CONTAINER_PATH"
veracrypt -t -d -k "$CONTAINER_PATH"