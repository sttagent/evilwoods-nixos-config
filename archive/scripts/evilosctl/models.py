from enum import Enum


class Action(Enum):
    TEST = "test"
    SWITCH = "switch"
    BOOT = "boot"
    BUILD = "build"
    DIFF = "diff"
    BUILDVM = "build-vm"
