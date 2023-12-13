from utils import check_software_version


SHOULD_ABORT = False


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


def install_clang():
    print("Installing clang...")

# ############################################################################
# System Requirements
# ############################################################################


system_requirements = [
    SystemRequirement("cmake", "3.21.0", install_cmake),
    SystemRequirement("clang", "18.0.0"),  # Real version is 17.0.1
]


def check_system_requirements():
    for system_requirement in system_requirements:
        if (check_software_version(system_requirement.software, system_requirement.version)):
            system_requirement.onSuccess()
        else:
            system_requirement.onMissing()

        if SHOULD_ABORT:
            return False

    return True
