import argparse
import json
import os
import time
from socket import gethostname

import questionary
from models import Action
from utils import run_command


def get_arg_parser() -> argparse.ArgumentParser:
    arg_parser = argparse.ArgumentParser(
        description="Apply nixosConfigurations to local or remote hosts"
    )

    common_flags = argparse.ArgumentParser(add_help=False)
    common_flags.add_argument("--debug", action="store_true", help="dry run")
    common_remote_flags = argparse.ArgumentParser(add_help=False)
    common_remote_flags.add_argument(
        "-t", "--target-host", type=str, help="the host is remote"
    )
    common_build_flags = argparse.ArgumentParser(add_help=False)
    common_build_flags.add_argument(
        "-c", "--choose", action="store_true", help="choose a configuration"
    )
    common_build_flags.add_argument(
        "nixos_config",
        nargs="?",
        help="the nixos configuration to apply",
        default=None,
    )
    common_build_flags.add_argument(
        "--diff", action="store_true", help="perform a diff after build"
    )

    sub_parsers = arg_parser.add_subparsers(
        title="subcommands", dest="subcommand", required=True, help="sub-command help"
    )
    sub_parsers.add_parser(
        Action.BUILD.value,
        help="build the nixos configuration",
        parents=[common_remote_flags, common_build_flags],
    )

    sub_parsers.add_parser(
        Action.BUILDVM.value,
        help="build the nixos configuration",
        parents=[common_build_flags],
    )
    sub_parsers.add_parser(
        Action.DIFF.value,
        help="diff the new nixos configuration with the old",
        parents=[common_remote_flags, common_build_flags],
    )
    sub_parsers.add_parser(
        Action.TEST.value,
        help="test the nixos configuration",
        parents=[common_remote_flags, common_build_flags],
    )
    sub_parsers.add_parser(
        Action.SWITCH.value,
        help="switch to the new nixos configuration",
        parents=[common_remote_flags, common_build_flags],
    )
    boot_parser = sub_parsers.add_parser(
        Action.BOOT.value,
        help="boot to the new nixos configuration",
        parents=[common_remote_flags, common_build_flags],
    )
    boot_parser.add_argument(
        "--reboot",
        action="store_true",
        help="reboot after applying the new configuration",
        default=False,
    )

    gen_host_keys_parser = sub_parsers.add_parser(
        "gen-host-keys",
        aliases=["ghk"],
        help="generate new host keys",
        parents=[common_remote_flags, common_build_flags],
    )
    gen_host_keys_parser.add_argument(
        "--secrets-path",
        type=str,
        help="the path to the secrets folder",
        default="../evilwoods-nixos-config-secrets",
    )

    install_parser = sub_parsers.add_parser(
        "install",
        aliases=["i"],
        help="install the nixos configuration",
        parents=[common_remote_flags, common_build_flags],
    )
    install_parser.add_argument(
        "--reboot",
        action="store_true",
        help="reboot after applying the new configuration",
    )
    install_parser.add_argument(
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
        _ = run_command(
            [
                "ssh",
                f"root@{args.target_host}",
                f"nix copy --to ssh://root@{args.target_host} {closure}",
            ]
        )
        current_system = run_command(
            [
                "ssh",
                f"root@{args.target_host}",
                "readlink -f /run/current-system",
            ]
        ).stdout

        _ = run_command(
            [
                "ssh",
                f"root@{args.target_host}",
                f"nix run nixpkgs#nvd -- diff {current_system} {closure}",
            ],
            capture_output=False,
        )
    else:
        _ = run_command(["nvd", "diff", f"{current_system}", f"{closure}"])


def build_nixos_system(args: argparse.Namespace, is_remote: bool = False) -> None:
    _ = run_command(
        ["nixos-rebuild", "build", "--flake", f".#{args.nixos_config}"],
        capture_output=False,
    )

    if args.diff:
        diff_result_with_current(args, is_remote)


def build_vm(args: argparse.Namespace) -> None:
    _ = run_command(
        ["nixos-rebuild", "build-vm", "--flake", f".#{args.nixos_config}"],
        capture_output=False,
    )


def apply_nixos_config(args: argparse.Namespace, is_remote: bool = False) -> None:
    build_nixos_system(args, is_remote)
    if is_remote:
        _ = run_command(
            [
                "nixos-rebuild",
                args.subcommand,
                "--ask-sudo-password",
                "--flake",
                f".#{args.nixos_config}",
                f"--target-host {args.target_host}",
            ],
            capture_output=False,
        )
    else:
        _ = run_command(
            [
                "nixos-rebuild",
                args.subcommand,
                "--sudo",
                "--flake",
                f".#{args.nixos_config}",
            ],
            capture_output=False,
        )

    if args.subcommand == "boot" and args.reboot:
        if args.diff:
            _ = input("Press enter to reboot...")
        countdown(3, "Rebooting in")
        reboot_system(args, is_remote)


def reboot_system(args: argparse.Namespace, is_remote: bool = False) -> None:
    if is_remote:
        _ = run_command(
            [
                "ssh",
                f"root@{args.target_host}",
                "sudo",
                "systemctl",
                "reboot",
            ]
        )
    else:
        _ = run_command(["systemctl", "reboot"])


def countdown(seconds: int, message="") -> None:
    print()
    for i in range(seconds, 0, -1):
        print(f"\r{message} {i}...", end="", flush=True)
        time.sleep(1)


def generate_new_host_key(
    args: argparse.Namespace, secrets_path: str, is_remote: bool = False
) -> None:
    pass


def install_nixos_config(args: argparse.Namespace, is_remote: bool = False) -> None:
    pass


def main() -> None:
    args = get_arg_parser().parse_args()

    print(args)

    if args.choose:
        args.nixos_config = choose_nixos_config()

    if args.target_host is None:
        args.target_host = args.nixos_config

    is_remote: bool = False
    if args.target_host and gethostname() != args.target_host:
        is_remote = True

    match args.subcommand:
        case "diff":
            diff_result_with_current(args, is_remote)
        case "build":
            build_nixos_system(args, is_remote)
        case "build-vm":
            build_vm(args)
        case "test" | "switch" | "boot":
            apply_nixos_config(args, is_remote)
        case "gen-host-keys":
            generate_new_host_key(args, args.secrets_path)
        case "install":
            install_nixos_config(args, is_remote)
        case _:
            pass


if __name__ == "__main__":
    main()
