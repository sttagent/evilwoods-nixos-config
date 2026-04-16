def lla [...args] { ls -la ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
def la  [...args] { ls -a  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
def ll  [...args] { ls -l  ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }
def l   [...args] { ls     ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }

$env.EDITOR = "nvim"

$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_insert = "blink_line"
$env.config.cursor_shape.vi_normal = "blink_block"
