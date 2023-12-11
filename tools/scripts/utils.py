import subprocess
import sys

def import_package(package_name: str) -> None:
    try:
        __import__(package_name)
        print(f"{package_name} module is installed.")
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
