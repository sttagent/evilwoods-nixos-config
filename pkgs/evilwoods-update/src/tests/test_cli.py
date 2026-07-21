import pytest

from evilwoods_update import cli


@pytest.mark.parametrize("command", ["update", "hold", "resume", "status"])
def test_dispatches_commands_without_arguments(monkeypatch, command):
    called = []
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0)
    monkeypatch.setattr(cli.commands, command, lambda: called.append(command) or 0)

    assert cli.main([command]) == 0
    assert called == [command]


def test_dispatches_stage_path(monkeypatch):
    called = []
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0)
    monkeypatch.setattr(cli.commands, "stage", lambda path: called.append(path) or 0)

    assert cli.main(["stage", "/nix/store/example-system"]) == 0
    assert called == ["/nix/store/example-system"]


@pytest.mark.parametrize("argv", [[], ["unknown"], ["stage"], ["hold", "extra"]])
def test_usage_errors_exit_two(argv):
    with pytest.raises(SystemExit) as error:
        cli.main(argv)

    assert error.value.code == 2


@pytest.mark.parametrize("command", ["update", "stage", "hold", "resume"])
def test_non_root_mutating_command_is_rejected_before_dispatch(
    monkeypatch, caplog, command
):
    called = False

    def unexpected_dispatch(*args):
        nonlocal called
        called = True
        return 0

    monkeypatch.setattr(cli.os, "geteuid", lambda: 1000)
    monkeypatch.setattr(cli.commands, command, unexpected_dispatch)
    argv = [command, "/nix/store/example-system"] if command == "stage" else [command]

    assert cli.main(argv) == 1
    assert not called
    assert "requires root" in caplog.text
    assert "sudo" in caplog.text


def test_non_root_status_is_allowed(monkeypatch):
    monkeypatch.setattr(cli.os, "geteuid", lambda: 1000)
    monkeypatch.setattr(cli.commands, "status", lambda: 0)

    assert cli.main(["status"]) == 0


def test_command_exit_code_is_returned(monkeypatch):
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0)
    monkeypatch.setattr(cli.commands, "update", lambda: 1)

    assert cli.main(["update"]) == 1


def test_operational_exception_maps_to_one(monkeypatch, caplog):
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0)

    def fail():
        raise RuntimeError("broken")

    monkeypatch.setattr(cli.commands, "update", fail)

    assert cli.main(["update"]) == 1
    assert "Operation failed" in caplog.text


def test_keyboard_interrupt_maps_to_130(monkeypatch, caplog):
    monkeypatch.setattr(cli.os, "geteuid", lambda: 0)

    def interrupt():
        raise KeyboardInterrupt

    monkeypatch.setattr(cli.commands, "update", interrupt)

    assert cli.main(["update"]) == 130
    assert "Interrupted" in caplog.text
