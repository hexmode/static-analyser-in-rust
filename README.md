# Create a Static Analyser in Rust

This project builds on [Michael Bryan\'s
experiment](https://github.com/Michael-F-Bryan/static-analyser-in-rust)
but makes some different decisions about the implementation. For
example, I\'m writing the README using [Org Mode](https://orgmode.org/)
rather than Markdown. It is still an experiment in using *literate
programming* to write a static analysis, but I\'ll be using tools I\'m
familiar with (e.g. Emacs, Org-Mode) and free software like [Free
Pascal](https://www.freepascal.org/) instead of Delphi.

The main goal for me is using this exercise to learn a bit about
building a parser in Rust, but I\'ll also use this project to
demonstrate other things as well.

## Building

If you want to build and read this locally you\'ll need to have the
following installed:

-   Rust (via [rustup](https://rustup.rs/))
-   tango (`cargo install tango`{.verbatim})
-   mdbook (`cargo install mdbook`{.verbatim})

If you\'ve freshly cloned the repo then `src/lib.rs`{.verbatim} won\'t
yet exist. Cargo doesn\'t particularly like this, so we need to manually
run `tango`{.verbatim} to generate the Rust code.

``` example
$ tango
```

If you look at the `src/`{.verbatim} directory you\'ll see two copies of
everything, one in markdown (`*.md`{.verbatim}) and the other in Rust
(`*.rs`{.verbatim}). If there are ever any compile errors, it\'s often
super useful to be able to look at the actual source code being
compiled.

If you want to look at the book version of the code, you\'ll need to run
`mdbook`{.verbatim}.

``` example
$ mdbook build --open
```

And the `rustdoc`{.verbatim} documentation can be viewed the usual way.

``` example
$ cargo doc --open
```
