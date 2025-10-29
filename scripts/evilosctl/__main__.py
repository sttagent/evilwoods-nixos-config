import subprocess
import sys
import os
import argparse
import json
import logging
from typing import cast

import questionary
import inspect


sys.argv[0] = os.path.basename(sys.argv[0].removesuffix("/"))

logger = logging.getLogger(sys.argv[0])


def get_args():
    arg_parser = argparse.ArgumentParser(
        description="Apply nixosConfigurations to local or remote hosts"
    )
    _ = arg_parser.add_argument("--debug", action="store_true", help="dry run")

    common_parser = argparse.ArgumentParser(add_help=False)
    _ = common_parser.add_argument(
        "-t", "--target-host", type=str, help="the host is remote"
    )
    _ = common_parser.add_argument(
        "nixos_config",
        type=str,
        nargs="?",
        help="the nixos configuration to apply",
        default="",
    )

    sub_parsers = arg_parser.add_subparsers(
        title="subcommands", dest="subcommand", required=True, help="sub-command help"
    )
    build_parser = sub_parsers.add_parser(
        "build",
        aliases=["b"],
        help="build the nixos configuration",
        parents=[common_parser],
    )
    _ = build_parser.add_argument(
        "--diff", action="store_true", help="perform a diff after build"
    )

    diff_parser = sub_parsers.add_parser(
        "diff",
        aliases=["d"],
        help="diff the new nixos configuration with the old",
        parents=[common_parser],
    )
    test_parser = sub_parsers.add_parser(
        "test",
        aliases=["t"],
        help="test the nixos configuration",
        parents=[common_parser],
    )
    switch_parser = sub_parsers.add_parser(
        "switch",
        aliases=["s"],
        help="switch to the new nixos configuration",
        parents=[common_parser],
    )

    boot_parser = sub_parsers.add_parser(
        "boot",
        aliases=["bo"],
        help="boot to the new nixos configuration",
        parents=[common_parser],
    )
    _ = boot_parser.add_argument(
        "--reboot",
        action="store_true",
        help="reboot after applying the new configuration",
        default=False,
    )

    gen_host_keys_parser = sub_parsers.add_parser(
        "gen-host-keys",
        aliases=["ghk"],
        help="generate new host keys",
        parents=[common_parser],
    )
    _ = gen_host_keys_parser.add_argument(
        "--secrets-path",
        type=str,
        help="the path to the secrets folder",
        default="../evilwoods-nixos-config-secrets",
    )

    install_parser = sub_parsers.add_parser(
        "install",
        aliases=["i"],
        help="install the nixos configuration",
        parents=[common_parser],
    )
    _ = install_parser.add_argument(
        "--reboot",
        action="store_true",
        help="reboot after applying the new configuration",
    )
    _ = install_parser.add_argument(
        "--extra-files",
        type=str,
        help="extra files to be copied to the target host",
        default=None,
    )

    return arg_parser.parse_args()


def choose_nixos_config() -> str:
    try:
        nix_flake_show_result = subprocess.run(
            "nix flake show --json",
            capture_output=True,
            shell=True,
            check=True,
            encoding="utf-8",
        )
    except subprocess.CalledProcessError as e:
        logger.error(f"in command: {e.cmd}")
        logger.error(e.stderr)
        sys.exit(e.returncode)

    config_name_list = list(
        json.loads(nix_flake_show_result.stdout)["nixosConfigurations"].keys()
    )
    choice = questionary.select(
        "Select a configuration", choices=config_name_list
    ).ask()
    return choice


def main() -> None:
    args = get_args()

    args.nixos_config = (
        choose_nixos_config() if args.nixos_config == "" else args.nixos_config
    )

    print(args.nixos_config)


if __name__ == "__main__":
    main()
