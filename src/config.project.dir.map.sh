#!/bin/sh

THIS_FILE_PATH=$(
  cd $(dirname $0)
  pwd
)
source "$THIS_FILE_PATH/path-resolve.sh"

PROJECT_PATH=$(path_resolve "$THIS_FILE_PATH" "../")
SRC_PATH=$(path_resolve "$PROJECT_PATH" "src")
NOTE_PATH=$(path_resolve "$PROJECT_PATH" "note")
BUILD_PATH=$(path_resolve "$PROJECT_PATH" "dist")
PACKAGE_PATH=$(path_resolve "$PROJECT_PATH" "packages")
TOOL_PATH=$(path_resolve "$PROJECT_PATH" "tool")