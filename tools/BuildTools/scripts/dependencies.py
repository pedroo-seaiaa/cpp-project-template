from utils import check_software_version
import sys
import os
import platform
import subprocess
print("[dependencies.py] traced ")


SHOULD_ABORT = False


def is_running_as_sudo():
    return os.geteuid() == 0


def defaultOnSuccess(software: str, version: str):
    print(f"{software} {version} or higher is installed")


def defaultOnMissing(software: str, version: str):
    global SHOULD_ABORT
    print(f"{software} {version} is missing! Please create a Pull Request with the installation steps!")
    SHOULD_ABORT = True


class SystemRequirement:
    def __init__(self, software, version, onMissing=None, onSuccess=None):
        self.software = software
        self.version = version
        self.onMissing = onMissing if onMissing is not None else lambda: defaultOnMissing(
            self.software, self.version)
        self.onSuccess = onSuccess if onSuccess is not None else lambda: defaultOnSuccess(
            self.software, self.version)

    def onSuccess(self):
        return self.onSuccess()

    def onMissing(self):
        return self.onMissing()


def install_cmake():
    print("Installing cmake...")
    if platform.system().lower() == "linux":
        # Install pip using apt-get on Ubuntu
        if is_running_as_sudo():
            subprocess.run(["apt-get", "update"], check=True)
            subprocess.run(
                ["apt-get", "install", "cmake", "-y", "--no-install-recommends"], check=True)
        else:
            subprocess.run(["sudo", "apt-get", "update"], check=True)
            subprocess.run(["sudo", "apt-get", "install",
                           "cmake", "-y", "--no-install-recommends"], check=True)
    else:
        subprocess.run([sys.executable, "-m", "ensurepip",
                       "--default-pip"], check=True)
    print("pip has been successfully installed.")


def install_clang():
    print("Installing clang...")


# ############################################################################
# System Requirements
# ############################################################################
system_requirements = [
    SystemRequirement("cmake", "3.21.0", install_cmake),
    SystemRequirement("clang", "15.0.0")
]


def check_system_requirements():
    print("[TRACE] check_system_requirements <<<<<<<<<<<<<<<<<<<<<< ")
    for system_requirement in system_requirements:
        if (check_software_version(system_requirement.software, system_requirement.version)):
            print(f"{system_requirement.software} found successfully")
            system_requirement.onSuccess()
        else:
            print(f"{system_requirement.software} missing!")
            system_requirement.onMissing()

        if SHOULD_ABORT:
            return False

    return True
