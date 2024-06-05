#!/bin/bash

# Check if the correct number of arguments are provided
if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <source_directory> <destination_directory>"
    exit 1
fi

# Source and destination directories from user input
SOURCE_DIR="$1"
DEST_DIR="$2"

# Function to create directories and hard link files
function link_files() {
    local SRC_DIR=$1
    local DST_DIR=$2

    # Loop through items in the source directory
    for ITEM in "$SRC_DIR"/*; do
        # Get the basename of the item
        local ITEM_NAME=$(basename "$ITEM")

        # Check if item is a directory
        if [[ -d "$ITEM" ]]; then
            # Create the corresponding directory in the destination
            mkdir -p "$DST_DIR/$ITEM_NAME"
            # Recursively link files in the subdirectory
            link_files "$ITEM" "$DST_DIR/$ITEM_NAME"
        else
            # Item is a file, create a hard link in the destination directory
            ln "$ITEM" "$DST_DIR/$ITEM_NAME"
        fi
    done
}

# Call the function with source and destination directories
link_files "$SOURCE_DIR" "$DEST_DIR"

echo "Hard linking completed."
