import subprocess
import sys
import logging

logger = logging.getLogger(sys.argv[0])


def run_command(
    command: list[str] | str, *, shell: bool = False, capture_output: bool = False
) -> subprocess.CompletedProcess[str]:
    try:
        result: subprocess.CompletedProcess[str] = subprocess.run(
            command,
            capture_output=capture_output,
            check=True,
            shell=shell,
            text=True,
            encoding="utf-8",
        )
    except subprocess.CalledProcessError as e:
        logger.error(f"in command: {e.cmd}")
        logger.error(e.stderr)
        sys.exit(e.returncode)

    return result
