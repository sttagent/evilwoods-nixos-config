#!/usr/bin/env xonsh

import sys
import os
script_dir = os.path.dirname(os.path.dirname(os.path.realpath(__file__)))
sys.path.insert(0, str(script_dir))

import argparse
import json
import questionary
import inspect
import evilosctl.commands


def get_args():
    arg_parser = argparse.ArgumentParser(description = "Apply nixosConfigurations to local or remote hosts")
    arg_parser.add_argument('--debug', action='store_true', help="dry run")

    common_parser = argparse.ArgumentParser(add_help=False)
    common_parser.add_argument('-t', '--target-host', type=str, help="the host is remote")
    common_parser.add_argument('nixos_config', nargs='?', help="the nixos configuration to apply", default=None)

    sub_parsers = arg_parser.add_subparsers(
        title="subcommands", dest="subcommand", required=True, help="sub-command help")
    build_parser = sub_parsers.add_parser(
        'build', aliases=['b'], help="build the nixos configuration", parents=[common_parser])
    build_parser.add_argument('--diff', action='store_true', help="perform a diff after build")

    diff_parser = sub_parsers.add_parser(
        'diff', aliases=["d"], help="diff the new nixos configuration with the old", parents=[common_parser])
    test_parser = sub_parsers.add_parser(
        'test', aliases=["t"], help="test the nixos configuration", parents=[common_parser])
    switch_parser = sub_parsers.add_parser(
        'switch', aliases=["s"], help="switch to the new nixos configuration", parents=[common_parser])

    boot_parser = sub_parsers.add_parser(
        'boot', aliases=["bo"], help="boot to the new nixos configuration", parents=[common_parser])
    boot_parser.add_argument('--reboot', action='store_true', help="reboot after applying the new configuration", default=False)

    gen_host_keys_parser = sub_parsers.add_parser(
        'gen-host-keys', aliases=["ghk"], help="generate new host keys", parents=[common_parser])
    gen_host_keys_parser.add_argument('--secrets-path', type=str, help="the path to the secrets folder", default="../evilwoods-nixos-config-secrets")

    install_parser = sub_parsers.add_parser(
        'install', aliases=["i"], help="install the nixos configuration", parents=[common_parser])
    install_parser.add_argument('--reboot', action='store_true', help="reboot after applying the new configuration")
    install_parser.add_argument('--extra-files', type=str, help="extra files to be copied to the target host", default=None)

    return arg_parser.parse_args()


def reboot_system(args, is_remote=False):
    print("Rebooting system...")
    if is_remote:
        ssh -t @(args.target_host) "sudo systemctl reboot"
    else:
        sleep(1)
        sudo systemctl reboot


def diff_result_with_current(args, is_remote=False):
    closure = $(realpath ./result);
    hostname = ""
    if is_remote:
       hostname = $(ssh @(args.target_host) hostname)
    else:
       hostname = $(hostname)

    if hostname not in closure:
        print("result does not match target host")
        return

    if is_remote:
        nix copy --substitute-on-destination --to ssh://@(args.target_host) @(closure)
        ssh @(args.target_host) nix run 'nixpkgs#nvd' -- diff /run/current-system/ @(closure)
    else:
        nvd diff /run/current-system ./result/


def build_nixos_system(args, is_remote=False):
    nixos-rebuild build --flake @(f".#{args.nixos_config}") err>out | nom

    if args.diff:
        diff_result_with_current(args, is_remote)


def apply_nixos_config(args, is_remote=False):
    if is_remote:
        nixos-rebuild @(args.subcommand) \
            --ask-sudo-password \
            --no-reexec \
            --flake @(f".#{args.nixos_config}") \
            --target-host @(args.target_host)
    else:
        nixos-rebuild @(args.subcommand) --sudo --flake @(f".#{args.nixos_config}")

    if args.subcommand == "boot" && args.reboot:
        reboot_system(args, is_remote)


def install_nixos_config(args, is_remote=False):
    if is_remote:
        nix run github:nix-community/nixos-anywhere -- \
            --ssh-options "-t" \
            --flake @(f".#{args.nixos_config}") \
            --target-host @(args.target_host) \
            --extra-files @(args.extra_files)
    else:
        sudo nix --experimental-features "nix-command flakes" run \
            github:nix-community/disko/latest -- \
            --mode destroy,format,mount \
            --flake @(f".#{args.nixos_config}")
        nixos-rebuild install --flake @(f".#{args.nixos_config}")


def generate_new_host_key(args, secrets_path):
    if not p"~/.config/sops/age/keys.txt".exists():
        exit_with_error(" Age key file not found.")

    if not pf"{secrets_path}".exists():
        exit_with_error(" Secrets path not found.")

    try:
        grep -qse @(f"^ \\+- &{args.nixos_config} .*$") @(secrets_path)/.sops.yaml
    except:
        exit_with_error(" Host not found in .sops.yaml")

    tmp_dir = $(mktemp -td evilosctl-XXXXXXXXXX)
    mkdir -p @(tmp_dir)/etc/ssh
    ssh-keygen -A -f @(tmp_dir) all> /dev/null
    age_pub_key = $(ssh-to-age -i @(tmp_dir)/etc/ssh/ssh_host_ed25519_key.pub)

    cp @(secrets_path)/.sops.yaml @(secrets_path)/.sops.yaml.bak
    sed @(fr"s/\(^ \+- &{args.nixos_config} \).*/\1{age_pub_key}/") -i @(secrets_path)/.sops.yaml

    try:
        sops --config @(secrets_path)/.sops.yaml updatekeys -y @(secrets_path)/secrets/*
    except:
        mv @(secrets_path)/.sops.yaml.bak @(secrets_path)/.sops.yaml
        exit_with_error("Failed to update keys")

    rm @(secrets_path)/.sops.yaml.bak

    print(tmp_dir)


def choose_nixos_config():
    nixos_configurations = !(@thread nix flake show --json)
    nixos_configurations.rtn
    config_name_list = json.loads(nixos_configurations.output)["nixosConfigurations"].keys()
    choice = questionary.select("Select a configuration", choices=config_name_list).ask()
    return choice


def print_commands(cmds: [str]) -> None:
    print(
        "\nDEBUG:--------- Command to be run: ---------\n"
        f"{cmds}\n"
        "DEBUG:--------------------------------------\n"
    )


def exit_with_error(msg: str) -> None:
    print(msg)
    sys.exit(1)


def setup_env():
    $RAISE_SUBPROC_ERROR = True


def main():
    setup_env()
    args = get_args()

    args.nixos_config = choose_nixos_config() if args.nixos_config is None else args.nixos_config
    args.target_host = args.nixos_config if args.target_host is None else args.target_host

    if args.debug:
        print(f"\nDEBUG: ARGS: {args}\n")

    is_remote = $(hostname) != args.target_host
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
        case _:
            print(f"Unknown subcommand: {args.subcommand}")
            sys.exit(1)


if __name__ == '__main__':
    main()
