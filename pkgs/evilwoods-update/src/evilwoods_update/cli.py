"""Command-line parsing and dispatch."""

import argparse
import logging
import os
from collections.abc import Sequence

from . import commands


LOGGER = logging.getLogger(__name__)
MUTATING_COMMANDS = frozenset({"update", "stage", "hold", "resume"})


def _parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(
        prog="evilwoods-update",
        description="Stage NixOS systems for activation at the next boot.",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("update", help="check for and stage an automatic update")

    stage_parser = subparsers.add_parser("stage", help="stage a local NixOS system")
    stage_parser.add_argument("store_path", metavar="store-path")

    subparsers.add_parser("hold", help="hold automatic updates")
    subparsers.add_parser("resume", help="resume automatic updates and check now")
    subparsers.add_parser("status", help="show updater state")
    return parser


def _run(argv: Sequence[str] | None) -> int:
    args = _parser().parse_args(argv)

    if args.command in MUTATING_COMMANDS and os.geteuid() != 0:
        LOGGER.error("The %s command requires root; try running it with sudo.", args.command)
        return 1

    if args.command == "stage":
        return commands.stage(args.store_path)

    handler = getattr(commands, args.command)
    return handler()


def main(argv: Sequence[str] | None = None) -> int:
    """Parse arguments, dispatch one command, and return its process exit code."""
    logging.basicConfig(level=logging.INFO, format="%(levelname)s: %(message)s")
    try:
        return _run(argv)
    except KeyboardInterrupt:
        LOGGER.error("Interrupted.")
        return 130
    except Exception:
        LOGGER.exception("Operation failed.")
        return 1
