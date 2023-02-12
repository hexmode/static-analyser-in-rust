# Ssh!
ifndef VERBOSE
.SILENT:
endif

.PHONY: open build build-crate build-docs clean word-count todo tangle try-install emacs markdown pandoc cargo ripgrep mdbook

all: build-crate build-docs

OPEN := xdg-open
ORG_FILES := $(wildcard src/*.org src/parse/*.org)
RS_FILES := $(ORG_FILES:.org=.rs)
MD_FILES := $(ORG_FILES:.org=.md)

usage:
	echo "Usage:"
	echo "    all          Build both the crate and accompanying book"
	echo "    tangle       Extract the source code from the org files"
	echo "    open         Build the project and open the tutorial in your browser"
	echo "    word-count   Get some (rough) statistics about the repository"
	echo "    clean        Remove any unnecessary files and build artefacts"
	echo "    todo         Find all sections marked TODO or FIXME"
	echo "    usage        Print this help text"

open: cargo build-docs tangle
	cargo doc --open
	${OPEN} target/book/index.html

build-crate: cargo tangle
	cargo build

build-docs: mdbook markdown
	mdbook build

clean: cargo
	test ! -f src/lib.rs || cargo clean
	git clean -f -x -d

word-count:
	echo -e "lines words file"
	echo -e "----- ----- ----"
	wc --lines --words $$(find src/ -name "*.org")

todo: ripgrep
	rg 'TODO|FIXME' --iglob '*.org'

tangle: ${RS_FILES}

markdown: ${MD_FILES}

%.md: %.org pandoc
	pandoc -r org -i $< -w gfm -o $@

%.rs: %.org emacs
	emacs -Q --batch --eval "(progn (require 'ob-tangle) (org-babel-tangle-file \"$<\" (file-name-nondirectory \"$@\") \"rust\")))"

try-install: cargo
	test -n "${target}" || ( echo must supply package argument for try-install target; exit 1 )
	export ans=`bash -c 'read -p "Install ${target} with cargo (N/y)? " ans; \
		ans=$${ans:-n}; echo $${ans:0:1} | tr "[:upper:]" "[:lower:]"'` && \
		test "$$ans" = "y" && \
			cargo install ${target} || \
			exit 10

emacs pandoc cargo:
	bash -c 'type $@ >/dev/null 2>&1' || (echo Please install $@.; exit 1)

mdbook:
	bash -c 'type mdbook >/dev/null 2>&1' || ${MAKE} try-install package=mdbook

ripgrep:
	bash -c 'type rgxxx >/dev/null 2>&1' || ${MAKE} try-install package=ripgrep
