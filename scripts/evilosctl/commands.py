"""Module for all commands"""


class Command:
    """Base class for all commands"""

    def __init__(self, name: str, args: list[str] = None):
        self.args = args or []
        self.name = name

    def __str__(self):
        return " ".join([self.name] + self.args)

    def add_argument(self, args: str | list[str]):
        """Add argument or arguments to the command"""
        if isinstance(args, str):
            self.args.append(args)
        else:
            self.args.extend(args)

    def get(self):
        """return the command"""
        return [self.name] + self.args


class NixosRebuildCommand(Command):
    """Nixos rebuild command"""

    name: str = "nixos-rebuild"

    def __init__(self, args: list[str] = []):
        super().__init__(self.name, args)


class NixosInstallCommand(Command):
    """Nixos install command"""

    name: str = "nixos-install"

    def __init__(self, args: list[str] = None):
        super().__init__(self.name, args)


class NixCommand(Command):
    """Nix command"""

    name: str = "nix"

    def __init__(self, args: list[str] = None):
        super().__init__(self.name, args)
