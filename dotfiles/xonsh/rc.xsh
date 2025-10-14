xontrib load coreutils # direnv

# TODO: figure out why xonsh doesn't pick up the env vars
# set by home-manager

$EDITOR = 'nvim'
$VI_MODE = True
$CASE_SENSITIVE_COMPLETIONS = False

$CARAPACE_BRIDGES = "fish"
$COMPLETIONS_CONFIRM = True

#
# aliases["ls"] = "eza"
aliases["ll"] = "eza -l"
aliases["lla"] = "eza -l -a"
#

execx($(starship init xonsh))
# execx($(zoxide init xonsh), 'exec', __xonsh__.ctx, filename='zoxide')
execx($(atuin init xonsh))
