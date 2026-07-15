if status is-interactive
    set -g fish_greeting
end

if not set -q LS_COLORS
    set -gx LS_COLORS (dircolors -b | sed "s/[^']*'//; s/'.*//; s/.\$//")
end

set -x MANPAGER bat -plman

function fish_command_not_found
    __fish_default_command_not_found_handler $argv
end

#---------#
#   FZF   #
#---------#

set -x FZF_DEFAULT_OPTS '
    --cycle
    --style=full:sharp
    --border=none
    --layout=reverse
    --pointer=">"
    --marker="┃"
    --gutter=" "
    --color=fg:-1,fg+:#FBF1C7,bg:-1,bg+:#282828
    --color=hl:#98971A,hl+:#B8BB26
    --color=prompt:#b26386,pointer:#6a9d6b,marker:#8fbf7c
    --color=info:#928374,spinner:#689D6A,header:#458588,label:#aeaeae
    --color=border:#7d6f65
    --bind "change:first"
' # --border=double

#--------------#
#   fzf.fish   #
#--------------#

fzf_configure_bindings --directory=ctrl-f

set fzf_fd_opts --hidden --exclude .git
set fzf_preview_dir_cmd eza --icons -a --group-directories-first -1 --no-user --color=always
set fzf_preview_file_cmd bat -p --color=always

#---------------#
#   fifc.fish   #
#---------------#

set fifc_bat_opts -p
set fifc_fd_opts --hidden --exclude .git
set fifc_eza_opts --icons -a --group-directories-first -1 --no-user --color=always

function _autopair_tab
    _fifc
end

#----------#
#   tide   #
#----------#

set tide_time_color black
set tide_time_bg_color brblack

set tide_time_format '%H:%M'
set tide_left_prompt_items pwd git newline

#-----------#
#   alias   #
#-----------#

alias cd "z"
alias l "eza --icons -a --group-directories-first -1 --no-user --long"
alias tree "eza --icons --tree --group-directories-first"

#----------#
#   abbr   #
#----------#

# --- one letter --- #
abbr -a -- c clear
abbr -a -- m "micro"
abbr -a -- f "spf"

# --- program rename --- #
abbr -a -- copy "wl-copy"
abbr -a -- dsize "du -hs"
abbr -a -- open "xdg-open"
abbr -a -- icat "kitten icat"
abbr -a -- py "python"
abbr -a -- ipy "ipython"

# --- program overide --- #
abbr -a -- cat "bat"
abbr -a -- less "bat"
abbr -a -- code "codium"
abbr -a -- diff "delta --diff-so-fancy --side-by-side"

# --- dnf --- #
abbr -a -- in 'sudo dnf in'
abbr -a -- update 'sudo dnf upgrade && flatpak update'
abbr -a -- clean 'sudo dnf clean all && sudo dnf autoremove'

# --- git --- #
abbr -a -- g lazygit
abbr -a -- gf 'onefetch --number-of-file-churns 0 --no-color-palette'

abbr -a -- gs "git status"
abbr -a -- gcl "git clone"
abbr -a -- gd "git diff"
abbr -a -- ga "git add"
abbr -a -- gaa "git add --all"
abbr -a -- gc "git commit"
abbr -a -- gcm "git commit -m"
abbr -a -- gpl "git pull"
abbr -a -- gps "git push"
abbr -a -- gpst "git push && git push --tags"
abbr -a -- gtag "git tag -ma"
abbr -a -- gb "git branch"
abbr -a -- gch "git checkout"
abbr -a -- gchb "git checkout -b"
abbr -a -- glog "git log --oneline --decorate --graph"
abbr -a -- glol "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset'"
abbr -a -- glola "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --all"
abbr -a -- glols "git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar) %C(bold blue)<%an>%Creset' --stat"

# --- other --- #
abbr -a -- which type

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end
abbr --add dotdot --regex '^\.\.+$' --function multicd

#------------#
#   zoxide   #
#------------#

zoxide init fish | source
