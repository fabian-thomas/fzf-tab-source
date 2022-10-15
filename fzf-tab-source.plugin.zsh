# shellcheck disable=all

## ## Common

## ```zsh
zstyle ':fzf-tab:complete:*' fzf-preview 'less ${realpath#--*=}'
## ```
##
## **NOTE: You need to install [lesspipe](https://github.com/wofr06/lesspipe) to
## preview directory, text, image, etc better.**
##
## `${realpath#--*=}` aims to handle `--long-option=/the/path/of/a/file`
##
## ![dir](https://user-images.githubusercontent.com/32936898/195973421-24f28667-3754-46f2-9dd4-42523285aec2.png)
##
## ![text](https://user-images.githubusercontent.com/32936898/195970444-4220411d-5a11-4b60-a19f-a8839d827711.png)
##
## ![image](https://user-images.githubusercontent.com/32936898/195970442-1ca8db87-fcb2-469e-8578-163ea73a19ff.png)

## ```zsh
zstyle ':fzf-tab:user-expand:*' fzf-preview 'less $word'
## ```
##
## **NOTE: You need to install [pinyin-completion](https://github.com/petronny/pinyin-completion).**
##
## ![user-expand](https://user-images.githubusercontent.com/32936898/195970438-1282c11b-c2e4-455e-8a6a-76c7446ecf8b.png)

## ```zsh
zstyle ':fzf-tab:complete:\
(-parameter-|-brace-parameter-|export|unset|expand|typeset|declare|local):*' \
  fzf-preview 'echo ${(P)word}'
## ```
##
## ![-parameter-](https://user-images.githubusercontent.com/32936898/195970440-98a83556-e664-42e6-9adb-918b865053f3.png)

## ```zsh
zstyle ':fzf-tab:complete:-tilde-:*' fzf-preview \
  '(($+commands[finger])) && finger $word \
  || (($+commands[pinky])) && pinky $word'
## ```
##
## ![-tilde-](https://user-images.githubusercontent.com/32936898/195971353-54ff0bd0-31e7-4bb0-bd88-1107f63a5751.png)

## ```zsh
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
  'case "$group" in
  "external command") less =$word;;
  "executable file") less ${realpath#--*=};;
  "builtin command") run-help $word | bat --color=always -plman;;
  "parameter") echo ${(P)word}
  esac'
## ```
##
## ![-command-](https://user-images.githubusercontent.com/32936898/195971354-0a9e3228-96d9-4f94-ae58-265ca0709787.png)

## ```zsh
zstyle ':fzf-tab:complete:(-equal-|(\\|*/|)(sudo|proxychains)):*' fzf-preview \
  'less =$word'
## ```

## ## Built-in
##
## Built-in commands and aliases should start with `(\\|)` to support `\command`.

## ```zsh
zstyle ':fzf-tab:complete:(\\|)bindkey:*' fzf-preview \
  'case "$group" in
keymap) bindkey -M$word | bat --color=always -pltsv;;
esac'
## ```
##
## ![bindkey](https://user-images.githubusercontent.com/32936898/195971356-78d0e417-428c-481a-8c96-345d5d73be14.png)

## ```zsh
zstyle ':fzf-tab:complete:(\\|)read:*' fzf-preview \
  'case "$group" in
varprompt) echo ${(P)word};;
esac'
## ```

## ```zsh
zstyle ':fzf-tab:complete:(\\|)run-help:*' fzf-preview 'run-help $word'
## ```
##
## ![run-help](https://user-images.githubusercontent.com/32936898/195971646-1724d415-6c30-41fe-b5a7-4cb2f78b0d57.png)

## ```zsh
zstyle ':fzf-tab:complete:(\\|)zinit:*' fzf-preview \
  "less ${ZINIT[PLUGINS_DIR]}/"'$word/README*'
## ```
##
## ![zinit](https://user-images.githubusercontent.com/32936898/195971845-006f9b46-0685-4c53-aef8-ab50b0038dfe.png)

## ## Command
##
## Commands should start with `(\\|*/|)` to support `/usr/bin/commmand`.

## ```zsh
cmds=(
  {cpp,readlink,'readelf -a',size,strings,nm,'objdump -d'}' $realpath'
  {gcc,g++,cc,c++,clang{,++}}' -o- -S $realpath | bat --color=always -plasm'
)
for cmd in $cmds ; do
  bin=${cmd%% *}
  bins=({,{{i686,x86_64}-w64-mingw32,i386-apple-darwin,o{64{,e},32}}-}$bin)
  for bin in $bins ; do
    zstyle ':fzf-tab:complete:(\\|*/|)'"$bin"':*' fzf-preview \
      '[ -f $realpath ] && '"$cmd"' || less ${realpath#--*=}'
  done
done

dir=/opt/android-ndk/toolchains/llvm/prebuilt/linux-x86_64/bin
if [[ -d $dir ]]; then
  for cmd in {,$dir/aarch64-linux-android??-}clang{,++} ; do
    bin=${cmd##*/}
    zstyle ':fzf-tab:complete:(\\|*/|)'"$bin"':*' fzf-preview \
      '[ -f $realpath ] &&'"$cmd"' -o- -S $realpath \
      | bat --color=always -plasm || less ${realpath#--*=}'
  done
fi
unset dir

cmds=(
  {hexdump,xxd,hexyl,'od -Ax -tx1','pandoc -tmarkdown'}' $realpath'
  )
for cmd in $cmds ; do
  bin=${cmd%% *}
  zstyle ':fzf-tab:complete:(\\|*/|)'"$bin"':*' fzf-preview \
    '[ -f $realpath ] && '"$cmd"' || less ${realpath#--*=}'
done
## ```
##
## ![hexyl](https://user-images.githubusercontent.com/32936898/195972152-d0130d58-afd4-431c-8e9a-d1777e885257.png)

## ```zsh
cmds=(
  {finger,pinky,getconf,fc-list,'dpkg -L'}' $word'
  {{pip{,3},apt{,-cache}}' show','pkg info'}' $word | bat --color=always -plyaml'
  {jupyter,brew,plotext}' $word --help | bat --color=always -plhelp'
  'jupyter $word --help | bat --color=always -plrst'
  'man $word | bat --color=always -plman'
  {go,yarn,luarocks,cabal,nix,gh,git,svn,systemctl,docker,gem,pyenv}' \
    help $word | bat --color=always -plhelp'
)
for cmd in $cmds ; do
  bin=${cmd%% *}
  zstyle ':fzf-tab:complete:(\\|*/|)'"$bin"':*' fzf-preview "$cmd"
done
## ```
##
## ![git](https://user-images.githubusercontent.com/32936898/195972427-1abb643e-7a3e-4571-b9c3-e4dd911cf4e5.png)

## ```zsh
zstyle ':fzf-tab:complete:(\\|*/|)(kill|ps):argument-rest' fzf-preview \
  '[ "$group" = "process ID" ] && ps -p$word -wocmd --no-headers \
  | bat --color=always -plsh'
zstyle ':fzf-tab:complete:(\\|*/|)(kill|ps):argument-rest' fzf-flags \
  --preview-window=down:3:wrap
## ```
##
## ![kill](https://user-images.githubusercontent.com/32936898/195972969-437326bb-4514-4c46-8a55-fe16808a0368.png)

## ```zsh
zstyle ':fzf-tab:complete:(\\|*/|)(g|b|d|p|freebsd-|)make:*' fzf-preview \
  'case "$group" in
"make target") make -n $word | bat --color=always -plsh;;
"make variable") make -pq | rg -Ns "^$word = " | bat --color=always -plsh;;
file) less ${realpath#--*=};;
esac'
## ```
##
## ![make](https://user-images.githubusercontent.com/32936898/195984087-c802d78f-00ae-4139-904c-74fb668cb844.png)

## ```zsh
zstyle ':fzf-tab:complete:(\\|*/|)has:*' fzf-preview \
  'case "$group" in
"external command") has $word;;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)pygmentize:*' fzf-preview \
  'case "$group" in
"Where to read the input.  Defaults to standard input.") less $word;;
option) ;;
*) pygmentize -L $word | bat --color=always -plrst;;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)ydcv:*' fzf-preview \
  'case "$group" in
word) ydcv --color=always --history=/dev/null $word;;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)(,neo)mutt:*' fzf-preview \
  'case "$group" in
"file attachment") less ${realpath#--*=};;
recipient) (($+commands[finger])) && finger $word || pinky $word;;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)(scp|rsync):*' fzf-preview \
  'case "$group" in
file) less ${realpath#--*=};;
user) (($+commands[finger])) && finger $word || pinky $word;;
*host*) grc --colour=on ping -c1 $word;;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)bat:*' fzf-preview \
  'case "$group" in
subcommand) bat cache --help | bat --color=always -plhelp;;
*) less ${realpath#--*=};;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)journalctl:*' fzf-preview \
  'case "$group" in
boot\ *) journalctl -b $word | bat --color=always -pllog;;
"/dev files") journalctl -b /dev/$word | bat --color=always -pllog;;
esac'
zstyle ':fzf-tab:complete:(\\|*/|)(pacman|yay):*' fzf-preview \
  '[ "$group" != repository/package ] &&
  pacman -Qi $word | bat --color=always -plyaml'
zstyle ':fzf-tab:complete:(\\|*/|)pkg-config:argument-rest' fzf-preview \
  '[ "$group" = package ] && less /usr/(lib|share)/pkgconfig/$word.pc ||
  less $word'
zstyle ':fzf-tab:complete:(\\|*/|)(c(make|test|pack)|ccmake|cmake-gui):*' \
  fzf-preview '[[ $word == --help* ]] && cmake $word'
zstyle ':fzf-tab:complete:(\\|*/|)(pkill|killall):*' fzf-preview \
  'grc --colour=on ps -C$word'
zstyle ':fzf-tab:complete:(\\|*/|)df:argument-rest' fzf-preview \
  '[ "$group" != "device label" ] && grc --colour=on df -Th $word'
zstyle ':fzf-tab:complete:(\\|*/|)du:argument-rest' fzf-preview \
  'grc --colour=on du -sh $realpath'
zstyle ':fzf-tab:complete:(\\|*/|)gdu:argument-rest' fzf-preview \
  '[ -d $realpath ] && gdu -n $realpath || grc --colour=on du -sh $realpath'
zstyle ':fzf-tab:complete:(\\|*/|)findmnt:argument-1' fzf-preview \
  '[ "$group" != prefix ] && grc --colour=on findmnt $word'
## ```

## ## Subcommand

## ```zsh
cmds=(
  'git help $word | bat --color=always -plhelp'
  'gem '{check,rdoc,contents,pristine,list,which,environment,dependency}' $word'
  'git check-ignore $word || less $word'
  'gem specification $word | bat --color=always -plyaml'
  'docker '{image,container}' ls $word'
  'systemctl '{cat,show}' $word | bat --color=always -plini'
  'brew '{ls,list}' $word'
  'git log --color=always $word | perl \
    -pe$(jq -j '\''.[] as $i | "s=" + $i.code + "=" + $i.emoji + "=g;"'\'' \
    ~/.gitmoji/gitmojis.json)'
)
for cmd in $cmds ; do
  bin=${${cmd/ /-}%% *}
  zstyle ':fzf-tab:complete:'"$bin"':*' fzf-preview "$cmd"
done
## ```
##
## ![git log](https://user-images.githubusercontent.com/32936898/195972831-86ff5c74-e18e-41a0-99d8-8b7679930e98.png)

## ### systemctl

## ```zsh
zstyle ':fzf-tab:complete:systemctl-*' fzf-preview \
  'SYSTEMD_COLORS=1 systemctl status $word'
## ```
##
## ![systemctl](https://user-images.githubusercontent.com/32936898/195973059-ab426a65-2e04-4e5a-8474-d201a6644adb.png)

## ### brew

## ```zsh
zstyle ':fzf-tab:complete:brew-(edit|cat|test):*' \
  fzf-preview 'brew cat $word | bat --color=always -plruby'
zstyle ':fzf-tab:complete:brew-((|un)install|info|cleanup):*' \
  fzf-preview 'brew info $word | bat --color=always -plyaml'
## ```

## ### gem

## ```zsh
zstyle ':fzf-tab:complete:\
gem-((|un)install|update|lock|fetch|open|yank|owner|unpack):*' \
  fzf-preview 'gem info $word | bat --color=always -plyaml'
## ```

## ### tmux

## ```zsh
zstyle ':fzf-tab:complete:tmux:*' fzf-preview \
  'case "$word" in
(show|set)(env|-environment)) tmux ${word/set/show} -g | bat --color=always -plsh;;
(show|set)(-hook?|(-window)-option?|w|)) tmux ${word/set/show} -g \
  | bat --color=always -pltsv;;
(show|set)(msgs|-message?)) tmux ${word/set/show} | bat --color=always -pllog;;
(show|set)(b|-buffer)) tmux ${word/set/show};;
(ls|list-)*) tmux $word;;
esac'
zstyle ':fzf-tab:complete:tmux-(show-hooks|set-hook):*' fzf-preview \
  'tmux show-hook -g $word'
zstyle ':fzf-tab:complete:tmux-(show|set)-environment:*' fzf-preview \
  'tmux show-environment -g $word | bat --color=always -plsh'
zstyle ':fzf-tab:complete:tmux-(show-options|set-option):*' fzf-preview \
  'tmux show-options -gq $word | bat --color=always -pltsv'
zstyle ':fzf-tab:complete:tmux-(show-window-options|set-window-option):*' \
  fzf-preview 'tmux show-window-options -g $word | bat --color=always -pltsv'
## ```

## ### git

## ```zsh
zstyle ':fzf-tab:complete:git-blame:*' fzf-preview \
  'case "$group" in
"cached file") git blame $word | delta;;
esac'
zstyle ':fzf-tab:complete:git-(push|pull|fetch):*' fzf-preview \
  'case "$group" in
"local repository") less ${realpath#--*=};;
remote) git remote show $word;;
*host*) grc --colour=on ping -c1 $word;;
esac'
zstyle ':fzf-tab:complete:git-(diff|cherry-pick):*' fzf-preview \
  'case "$group" in
"tree file") less $word;;
*) git diff $word | delta ;;
esac'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
  'case "$group" in
"commit tag") git show --color=always $word ;;
*) git show --color=always $word | delta ;;
esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'case "$group" in
"modified file") git diff $word | delta ;;
"recent commit object name") git log --color=always $word | perl \
  -pe$(jq -j '\''.[] as $i | "s=" + $i.code + "=" + $i.emoji + "=g;"'\'' \
  ~/.gitmoji/gitmojis.json) | delta ;;
*) git log --color=always $word | perl \
  -pe$(jq -j '\''.[] as $i | "s=" + $i.code + "=" + $i.emoji + "=g;"'\'' \
  ~/.gitmoji/gitmojis.json);;
esac'
zstyle ':fzf-tab:complete:git-reflog(|-*):*' fzf-preview \
  'case "$group" in
command) git reflog show --color=always | perl \
  -pe$(jq -j '\''.[] as $i | "s=" + $i.code + "=" + $i.emoji + "=g;"'\'' \
  ~/.gitmoji/gitmojis.json;;
reference) git reflog --color=always $word | perl \
  -pe$(jq -j '\''.[] as $i | "s=" + $i.code + "=" + $i.emoji + "=g;"'\'' \
  ~/.gitmoji/gitmojis.json;;
esac'

unset cmd cmds bin bins
## ```
# ex: foldmethod=marker foldmarker=```zsh,```
