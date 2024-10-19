#!/usr/bin/env xonsh

import argparse

parser = argparse.ArgumentParser(description='Install NixOS my local or remote machines')
parser.add_argument('-r', '--remote-host', action='store_true', help='Remote host to install NixOS on')
parser.add_argument('nixos_config',  help='NixOS configuration to install')


def main():
  parser.print_help()


if __name__ == '__main__':
  main()
