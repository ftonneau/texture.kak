# This script fills Kakoune scratch buffers with a textured logo and a few
# tips on usage.
# Author: François Tonneau

# ------------------------------------------------------------
# Public options and commands
# ------------------------------------------------------------

declare-option -docstring 'color of K trunk' str texture_trunk_color rgb:67a5ab
declare-option -docstring 'color for K fork' str texture_fork_color rgb:87c6cc
declare-option -docstring 'color for K limb' str texture_limb_color rgb:e0ba70
declare-option -docstring 'color for K tile' str texture_tile_color rgb:6d7183
declare-option -docstring 'color for K pane' str texture_pane_color rgb:253545

declare-option -docstring 'color for dim text (light)' str texture_dim_light bright-black
declare-option -docstring 'color for dim text (dark)' str texture_dim_dark bright-black

declare-option -docstring 'color for hot text (light)' str texture_hot_light yellow
declare-option -docstring 'color for hot text (dark)' str texture_hot_dark yellow

define-command -docstring 'texture light|dark 1..8: set texture variant' \
-params 2 texture %{
    try %{
        "texture-theme-%arg(1)"
        "texture-width-%arg(2)"
    }
}
complete-command -menu texture shell-script-candidates %{
    case $kak_token_to_complete in
        0) printf '%s\n%s\n' light dark ;;
        1) seq 1 8 ;;
    esac
}

# ------------------------------------------------------------
# Kakoune version: string setting
# ------------------------------------------------------------

declare-option -hidden str texture_version_str
define-command -hidden texture-has-no- nop
try %{
    "texture-has-no-%val(version)"
    set-option global texture_version_str 'v-***'
} \
catch %{
    set-option global texture_version_str "v.%val(version)"
}

# ------------------------------------------------------------
# Text-color setting
# ------------------------------------------------------------

declare-option -hidden str texture_dim
declare-option -hidden str texture_hot

define-command -hidden texture-theme-light %{
    set-option global texture_dim "%opt(texture_dim_light)"
    set-option global texture_hot "%opt(texture_hot_light)"
}

define-command -hidden texture-theme-dark %{
    set-option global texture_dim "%opt(texture_dim_dark)"
    set-option global texture_hot "%opt(texture_hot_dark)"
}

# ------------------------------------------------------------
# Logo and tab width setting (via extra characters)
# ------------------------------------------------------------

declare-option -hidden str texture_trunk_extra
declare-option -hidden str texture_tile_extra
declare-option -hidden int texture_fork_width
declare-option -hidden str texture_tab_extra

define-command -hidden texture-width-1 %{
    declare-option -hidden str texture_trunk_extra ''
    declare-option -hidden str texture_tile_extra ''
    declare-option -hidden int texture_fork_width 3
    declare-option -hidden str texture_tab_extra ''
}

define-command -hidden texture-width-2 %{
    declare-option -hidden str texture_trunk_extra '-'
    declare-option -hidden str texture_tile_extra ''
    declare-option -hidden int texture_fork_width 3
    declare-option -hidden str texture_tab_extra ' '
}

define-command -hidden texture-width-3 %{
    declare-option -hidden str texture_trunk_extra '--'
    declare-option -hidden str texture_tile_extra '('
    declare-option -hidden int texture_fork_width 4
    declare-option -hidden str texture_tab_extra '   '
}

define-command -hidden texture-width-4 %{
    declare-option -hidden str texture_trunk_extra '---'
    declare-option -hidden str texture_tile_extra '('
    declare-option -hidden int texture_fork_width 4
    declare-option -hidden str texture_tab_extra '    '
}

define-command -hidden texture-width-5 %{
    declare-option -hidden str texture_trunk_extra '----'
    declare-option -hidden str texture_tile_extra '(('
    declare-option -hidden int texture_fork_width 5
    declare-option -hidden str texture_tab_extra '      '
}

define-command -hidden texture-width-6 %{
    declare-option -hidden str texture_trunk_extra '-----'
    declare-option -hidden str texture_tile_extra '(('
    declare-option -hidden int texture_fork_width 5
    declare-option -hidden str texture_tab_extra '       '
}

define-command -hidden texture-width-7 %{
    declare-option -hidden str texture_trunk_extra '------'
    declare-option -hidden str texture_tile_extra '((('
    declare-option -hidden int texture_fork_width 6
    declare-option -hidden str texture_tab_extra '         '
}

define-command -hidden texture-width-8 %{
    declare-option -hidden str texture_trunk_extra '-------'
    declare-option -hidden str texture_tile_extra '((('
    declare-option -hidden int texture_fork_width 6
    declare-option -hidden str texture_tab_extra '          '
}

# ------------------------------------------------------------
# Logo and tips presentation
# ------------------------------------------------------------

hook -group texture global WinCreate '\*scratch\*' %{

    # Define content and paste it into the buffer.
    evaluate-commands -save-regs %{"} %{
        set-register dquote \
    "


    -1---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -2---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -3---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -4---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -5---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -6---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -7---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}
    -8---%opt{texture_trunk_extra} ((((((((((%opt{texture_tile_extra}  A  K  O  U  N  E
                     %opt{texture_tab_extra} %opt{texture_version_str}

    Start typing     %opt{texture_tab_extra} i
    Stop typing      %opt{texture_tab_extra} <Esc>
    Save file        %opt{texture_tab_extra} :w filename<Enter>
    Get help         %opt{texture_tab_extra} :doc topic<Enter>
    Quit             %opt{texture_tab_extra} :q<Enter>

    Press any key --

"
        execute-keys <esc><esc> <percent> R
    }

    # Colorize content.
    add-highlighter window/texture group

    add-highlighter window/texture/row1 regex \
    "(-1-+)( .......)(.{%opt<texture_fork_width>})" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row2 regex \
    "(-2-+)( ......)(.{%opt<texture_fork_width>})(.)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row3 regex \
    "(-3-+)( .....)(.{%opt<texture_fork_width>})(..)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row4 regex \
    "(-4-+)( ....)(.{%opt<texture_fork_width>})(...)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row5 regex \
    "(-5-+)( ...)(.{%opt<texture_fork_width>})(....)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row6 regex \
    "(-6-+)( ..)(.{%opt<texture_fork_width>})(.)(....)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_limb_color),%opt(texture_pane_color)+b" \
    "5:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row7 regex \
    "(-7-+)( .)(.{%opt<texture_fork_width>})(.)(..)(...)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "5:%opt(texture_limb_color),%opt(texture_pane_color)+b" \
    "6:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/row8 regex \
    "(-8-+)( .{%opt<texture_fork_width>})(...)(..)(..)" \
    "1:%opt(texture_trunk_color),%opt(texture_trunk_color)" \
    "2:%opt(texture_fork_color),%opt(texture_pane_color)+b" \
    "3:%opt(texture_tile_color),%opt(texture_pane_color)+b" \
    "4:%opt(texture_limb_color),%opt(texture_pane_color)+b" \
    "5:%opt(texture_tile_color),%opt(texture_pane_color)+b"

    add-highlighter window/texture/naming regex \
    '(A  K  O  U  N  E)\n(.*?)\n' \
    "1:default,+b" "2:%opt(texture_dim)"

    add-highlighter window/texture/press regex \
    'Press(.+)?$' \
    "0:%opt(texture_dim)"

    add-highlighter window/texture/action regex \
    'Start typing|Stop typing|Run command|Get help|Save file|Quit|' \
    "0:default,+b"

    add-highlighter window/texture/arg regex \
    '(command|filename|topic)<' \
    "1:%opt(texture_hot),+b"

    add-highlighter window/texture/key regex \
    '<.+?>' \
    "0:%opt(texture_dim),+i"

    # On first window opening, change cursor faces to make them invisible.
    hook -group texture window -once WinDisplay '\*scratch\*' %{
        set-face window PrimaryCursorEol default
        set-face window LineNumberCursor LineNumbers
    }

    # On first key press, do some cleanup and restore cursor faces to their
    # parent (unmodified) values.
    hook -group texture buffer -once NormalKey .* %{
        execute-keys -draft <percent><a-d>
        remove-highlighter window/texture
        set-face window PrimaryCursorEol PrimaryCursorEol
        set-face window LineNumberCursor LineNumberCursor
    }
}

