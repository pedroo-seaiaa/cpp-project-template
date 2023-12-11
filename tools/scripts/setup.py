# TODO(PO): Add copyright note

import subprocess
import re
import sys

from utils import import_package
import_package('packaging')

# Define a list of software build_dependencies
build_dependencies = [
    {"name": "cmake", "version": "3.28.0", "url": "https://github.com/Kitware/CMake/releases/download/v3.28.0/cmake-3.28.0.tar.gz"},
    {"name": "ninja", "version": "1.11.1", "url": "https://github.com/ninja-build/ninja/archive/refs/tags/v1.11.1.tar.gz"},
    {"name": "Library3", "version": "3.2.1", "url": "https://example.com/library3"},
    # Add more build_dependencies as needed
]

# Define a list of software build_dependencies
test_dependencies = [
    {"name": "gtest", "version": "1.0.0", "url": "https://example.com/library1"},
    {"name": "gmock", "version": "2.1.3", "url": "https://example.com/library2"},
    {"name": "benchmark", "version": "3.2.1", "url": "https://example.com/library3"},
    # Add more build_dependencies as needed
]

# Define a list of software build_dependencies
lint_dependencies = [
    {"name": "clang-format", "version": "1.0.0", "url": "https://example.com/library1"},
    {"name": "cmake-lint", "version": "2.1.3", "url": "https://example.com/library2"},
    {"name": "cmake-format", "version": "3.2.1", "url": "https://example.com/library3"},
    # Add more build_dependencies as needed
]

# Define a list of software build_dependencies
static_analyzers_dependencies = [
    {"name": "clang-format", "version": "1.0.0", "url": "https://example.com/library1"},
    {"name": "cmake-lint", "version": "2.1.3", "url": "https://example.com/library2"},
    {"name": "cmake-format", "version": "3.2.1", "url": "https://example.com/library3"},
    # Add more build_dependencies as needed
]

# Function to print information for each dependency
def print_dependency_info(dependency):
    print(f"Name: {dependency['name']}")
    print(f"Version: {dependency['version']}")
    print(f"URL: {dependency['url']}")
    print("")

# Iterate through the list of build_dependencies and print information
for dependency in build_dependencies:
    print_dependency_info(dependency)

def is_cmake_installed(required_version):
    try:
        # Run the command to get CMake version
        result = subprocess.run(["cmake", "--version"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        # Extract version number using a regular expression
        match = re.search(r"version (\d+\.\d+\.\d+)", result.stdout)
        if match:
            installed_version_str = match.group(1)
            installed_version = version.parse(installed_version_str)
            print(f"Installed CMake version: {installed_version}")
            # Compare with the required version
            return installed_version >= version.parse(required_version)
        else:
            print("Failed to extract CMake version.")
            return False
    except subprocess.CalledProcessError:
        return False

# Specify the required minimum CMake version
required_cmake_version = "3.21.0"

# Check if CMake is installed and has the required version or higher
if is_cmake_installed(required_cmake_version):
    print(f"CMake {required_cmake_version} or higher is installed.")
else:
    print(f"CMake {required_cmake_version} or higher is not installed.")