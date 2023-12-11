# TODO(PO): Add copyright note

import subprocess
import re
import sys

from dependencies import check_system_requirements

print("Checking the system requirements ...")
if check_system_requirements():
    print("Checking the system requirements --- SUCCESS")
else:
    print("Checking the system requirements --- FAILURE")
