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
