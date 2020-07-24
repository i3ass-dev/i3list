---
description: >
  list information about the current i3 session.
updated:       2020-07-24
version:       0.196
author:        budRich
repo:          https://github.com/budlabs/i3ass
created:       2017-10-06
dependencies:  [bash, gawk, i3]
see-also:      [bash(1), awk(1), i3(1), i3fyra(1)]
synopsis: |
    [--json FILE]
    --instance|-i TARGET [--json FILE]
    --class|-c    TARGET [--json FILE]
    --conid|-n    TARGET [--json FILE]
    --winid|-d    TARGET [--json FILE]
    --mark|-m     TARGET [--json FILE]
    --title|-t    TARGET [--json FILE]
    --help|-h
    --version|-v
...

# long_description

`i3list` prints a list in a *array* formatted list. 
If a search criteria is given 
(`-c`|`-i`|`-n`|`-d`|`-m`) 
information about the first window matching the criteria is displayed. 
Information about the active window is always displayed. 
If no search criteria is given, 
the active window will also be the target window.

By using eval, 
the output can be used as an array in bash scripts, 
but the array needs to be declared first.
