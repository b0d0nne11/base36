# base36

![Haskell CI](https://github.com/b0d0nne11/base36/workflows/Haskell%20CI/badge.svg)

This package provides support for transforming integral values to and from
alphanumeric, case-insensative text. I wrote it to help generate the left hand
part of email message IDs but it may be useful in a variety of contexts.

## Quickstart

```
$ cabal v2-repl
...
*Data.Text.Base36> :set -XOverloadedStrings
*Data.Text.Base36> encode 237816
"asdf"
*Data.Text.Base36> decode "asdf"
237816
```

## Development & Support

Run tests with `cabal v2-run base36-test`.

Feel free to open an issue or pull request on GitHub.

Copyright (c) 2020, Brendan O'Donnell
