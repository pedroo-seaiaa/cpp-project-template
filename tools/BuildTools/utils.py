import subprocess
import re
import sys

def import_package(package_name: str) -> None:
    try:
        __import__(package_name)
        # print(f"{package_name} module is installed.")
    except ModuleNotFoundError:
        print(f"{package_name} module is not installed.")

        user_response = input("Do you want to install it? (yes/no): ").lower()

        if user_response == "yes":
            try:
                # Attempt to install the module
                subprocess.run(["pip", "install", package_name], check=True)
                print(f"{package_name} module has been successfully installed.")
                # Now try importing it again
                __import__(package_name)
                print(f"Now the {package_name} module is available.")
            except subprocess.CalledProcessError:
                print(f"Failed to install the {package_name} module.")
        else:
            print(f"Installation aborted. The script cannot proceed without the {package_name} module.")
            sys.exit(1)  # Exit with a non-zero code to indicate an error

import_package('packaging')
from packaging import version

def check_software_version(software: str, required_version:str):
    try:
        # Run the command to get the version
        result = subprocess.run([software, "--version"], check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True)
        # Extract version number using a regular expression
        match = re.search(r"version (\d+\.\d+\.\d+)", result.stdout)
        if match:
            installed_version_str = match.group(1)
            installed_version = version.parse(installed_version_str)
            #print(f"Installed {software} version: {installed_version}")
            # Compare with the required version
            return installed_version >= version.parse(required_version)
        else:
            print(f"Failed to extract {software} version.")
            return False
    except subprocess.CalledProcessError:
        return False