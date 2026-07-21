"""Command workflows.

The workflows are added in later implementation tasks.  These placeholders make
the CLI runnable without performing any host mutation in the meantime.
"""

import logging


LOGGER = logging.getLogger(__name__)


def _not_implemented(command: str) -> int:
    LOGGER.error("The %s command is not implemented yet.", command)
    return 1


def update() -> int:
    return _not_implemented("update")


def stage(store_path: str) -> int:
    del store_path
    return _not_implemented("stage")


def hold() -> int:
    return _not_implemented("hold")


def resume() -> int:
    return _not_implemented("resume")


def status() -> int:
    return _not_implemented("status")
