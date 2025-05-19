#!/usr/bin/env python
"""
Setup script to prepare the application for deployment.
This script ensures that templates and static files are properly copied to the app directory structure.
"""

import os
import shutil
import sys

def ensure_dir(directory):
    """Ensure a directory exists, creating it if necessary."""
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"Created directory: {directory}")

def copy_files(src_dir, dest_dir):
    """Copy all files from source directory to destination directory."""
    if not os.path.exists(src_dir):
        print(f"Warning: Source directory {src_dir} does not exist.")
        return
    
    ensure_dir(dest_dir)
    
    # Get list of files in source directory
    files = os.listdir(src_dir)
    if not files:
        print(f"Warning: Source directory {src_dir} is empty.")
        return
    
    # Copy each file
    for item in files:
        src_item = os.path.join(src_dir, item)
        dest_item = os.path.join(dest_dir, item)
        
        if os.path.isdir(src_item):
            # Recursively copy subdirectories
            shutil.copytree(src_item, dest_item, dirs_exist_ok=True)
            print(f"Copied directory: {item}")
        else:
            # Copy files
            shutil.copy2(src_item, dest_item)
            print(f"Copied file: {item}")

def main():
    """Main function to prepare the application for deployment."""
    # Get the base directory of the project
    base_dir = os.path.dirname(os.path.abspath(__file__))
    
    # Define source and destination directories
    templates_src = os.path.join(base_dir, 'templates')
    templates_dest = os.path.join(base_dir, 'app', 'templates')
    
    static_src = os.path.join(base_dir, 'static')
    static_dest = os.path.join(base_dir, 'app', 'static')
    
    # Ensure app directory exists
    app_dir = os.path.join(base_dir, 'app')
    ensure_dir(app_dir)
    
    # Copy templates and static files
    print("\nCopying templates...")
    copy_files(templates_src, templates_dest)
    
    print("\nCopying static files...")
    copy_files(static_src, static_dest)
    
    print("\nDeployment preparation complete!")

if __name__ == "__main__":
    main()