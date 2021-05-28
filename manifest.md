---
description: >
  list information about the current i3 session.
updated:       2021-05-28
version:       0.3
author:        budRich
repo:          https://github.com/budlabs/i3ass
created:       2017-10-06
dependencies:  [bash, gawk, i3]
see-also:      [bash(1), awk(1), i3(1), i3fyra(1)]
synopsis: |
    [--json JSON]
    --instance|-i TARGET [--json JSON]
    --class|-c    TARGET [--json JSON]
    --conid|-n    TARGET [--json JSON]
    --winid|-d    TARGET [--json JSON]
    --mark|-m     TARGET [--json JSON]
    --title|-t    TARGET [--json JSON]
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
