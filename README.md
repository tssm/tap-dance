Change a key behavior if it has been pressed a certain amount of
times in a given period.

# Motivation
Although counts allow one to move quickly, one needs to know more
or less how many times a motion should be inputted, and so
counting them becomes the bottleneck. Instead, one may prefer to
press the same key repeatedly.

tap-dance makes it possible to do something more useful in such
cases, e.g., start a motion plug-in. Think of it as an alternative
to [Hardtime][1] and the like.

# Set up
Require `tap-dance` and call the returned function with all the
following arguments:

- maps: a table whose indices (strings) are the keys to be
  changed, and their corresponding values (string or Lua function)
  the commands to be executed when repeated enough times.
- modes: an array-like table of mode's short-name where the
  changes should apply
  (see shortcomings below).
- max-presses: number of times a key can be pressed before its
  behaviour is changed.

E.g.:

```
require(’tap-dance’)(
  {
    l = "<Plug>(leap-forward-to)",
    h = "<Plug>(leap-backward-to)"
  },
  {"n", "x"},
  2
)
```

# Shortcomings

- Operator-pending mode is not supported (yet).
- Modes and repetitions can't be configured per key (yet).

[1]: https://github.com/takac/vim-hardtime
