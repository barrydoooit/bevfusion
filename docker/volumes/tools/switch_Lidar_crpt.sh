#!/bin/bash

# Define the base path for the nuScenes-C root and the target link path
nuscenes_c_root="/bevfusion/data/nuScenes-C"
target_link_path="/bevfusion/data/nuscenes/samples/LIDAR_TOP"

# Function to create symbolic link
create_link() {
    local source_path=$1
    local target_path=$2

    # Remove the existing symbolic link or directory, if it exists
    if [ -e "$target_path" ] || [ -L "$target_path" ]; then
        rm -rf "$target_path"
    fi

    # Create a new symbolic link
    ln -s "$source_path" "$target_path"
    echo "Symbolic link created at $target_path"
}

# Check for --recover option
if [ "$1" = "clear" ]; then
    original_lidar_path="${nuscenes_c_root}/clear/samples/LIDAR_TOP"
    create_link "$original_lidar_path" "$target_link_path"
    exit 0
fi

# Check if two arguments are provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <corruption_type> <severity> OR $0 clear"
    exit 1
fi

corruption_type=$1
severity=$2

# Define the path of the corrupted LIDAR_TOP based on input
corrupted_lidar_path="${nuscenes_c_root}/${corruption_type}/${severity}/samples/LIDAR_TOP"

# Check if the specified corrupted LIDAR_TOP directory exists
if [ ! -d "$corrupted_lidar_path" ]; then
    echo "Corrupted LIDAR_TOP path does not exist: $corrupted_lidar_path"
    exit 1
fi

create_link "$corrupted_lidar_path" "$target_link_path"
