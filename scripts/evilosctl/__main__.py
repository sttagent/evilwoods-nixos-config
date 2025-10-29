import subprocess
import sys
import os
import argparse
import json
from typing import cast
from socket import gethostname
from utils import run_command

import questionary
import inspect


sys.argv[0] = os.path.basename(sys.argv[0].removesuffix("/"))


def get_arg_parser() -> argparse.ArgumentParser:
    arg_parser = argparse.ArgumentParser(
        description="Apply nixosConfigurations to local or remote hosts"
    )
    _ = arg_parser.add_argument("--debug", action="store_true", help="dry run")

    common_remote_parser = argparse.ArgumentParser(add_help=False)
    _ = common_remote_parser.add_argument(
        "-t", "--target-host", type=str, help="the host is remote"
    )
    common_build_parser = argparse.ArgumentParser(add_help=False)
    _ = common_build_parser.add_argument(
        "-c", "--choose", action="store_true", help="choose a configuration"
    )
    _ = common_build_parser.add_argument(
        "nixos_config",
        nargs="?",
        help="the nixos configuration to apply",
        default=None,
    )

    sub_parsers = arg_parser.add_subparsers(
        title="subcommands", dest="subcommand", required=True, help="sub-command help"
    )
    build_parser = sub_parsers.add_parser(
        "build",
        aliases=["b"],
        help="build the nixos configuration",
        parents=[common_remote_parser, common_build_parser],
    )
    _ = build_parser.add_argument(
        "--diff", action="store_true", help="perform a diff after build"
    )

    diff_parser = sub_parsers.add_parser(
        "diff",
        aliases=["d"],
        help="diff the new nixos configuration with the old",
        parents=[common_remote_parser, common_build_parser],
    )
    test_parser = sub_parsers.add_parser(
        "test",
        aliases=["t"],
        help="test the nixos configuration",
        parents=[common_remote_parser, common_build_parser],
    )
    switch_parser = sub_parsers.add_parser(
        "switch",
        aliases=["s"],
        help="switch to the new nixos configuration",
        parents=[common_remote_parser, common_build_parser],
    )

    boot_parser = sub_parsers.add_parser(
        "boot",
        aliases=["bo"],
        help="boot to the new nixos configuration",
        parents=[common_remote_parser, common_build_parser],
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
        parents=[common_remote_parser, common_build_parser],
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
        parents=[common_remote_parser, common_build_parser],
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

    return arg_parser


def choose_nixos_config() -> str:
    nix_flake_show_result = run_command(
        ["nix", "flake", "show", "--json"], capture_output=True
    )

    config_name_list: list[str] = list(
        json.loads(nix_flake_show_result.stdout)["nixosConfigurations"].keys()
    )
    choice: str = questionary.select(
        "Select a configuration", choices=config_name_list
    ).ask()
    return choice


def diff_result_with_current(args: argparse.Namespace, is_remote: bool = False) -> None:
    closure: str = os.path.realpath("./result")
    current_system: str = os.path.realpath("/run/current-system")

    if is_remote:
        _ = run_command(["nvd", "diff", f"{current_system}", f"{closure}"])
    else:
        _ = run_command(["nvd", "diff", f"{current_system}", f"{closure}"])


def build_nixos_system(args: argparse.Namespace, is_remote: bool = False) -> None:
    _ = run_command(
        f"nixos-rebuild {args.subcommand} --flake .#{args.nixos_config} 2>&1 | nom",
        shell=True,
        capture_output=False,
    )


def apply_nixos_config(args: argparse.Namespace, is_remote: bool = False) -> None:
    build_nixos_system(args, is_remote)
    _ = run_command(
        f"nixos-rebuild {args.subcommand} --ask-sudo-password --flake .#{args.nixos_config}",
        shell=True,
        capture_output=False,
    )


def generate_new_host_key(args: argparse.Namespace, is_remote: bool = False) -> None:
    pass


def install_nixos_config(args: argparse.Namespace, is_remote: bool = False) -> None:
    pass


def main() -> None:
    args = get_arg_parser().parse_args()

    print(args)

    if args.choose:
        args.nixos_config = choose_nixos_config()

    is_remote: bool = gethostname() != args.target_host
    match args.subcommand:
        case "diff":
            diff_result_with_current(args, is_remote)
        case "build":
            build_nixos_system(args, is_remote)
        case "test" | "switch" | "boot":
            apply_nixos_config(args, is_remote)
        case "gen-host-keys":
            generate_new_host_key(args, args.secrets_path)
        case "install":
            install_nixos_config(args, is_remote)


if __name__ == "__main__":
    main()
