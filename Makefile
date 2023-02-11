# Ssh!
.SILENT:

.PHONY: open build build-crate build-docs clean word-count todo tangle try-install emacs markdown

OPEN := xdg-open
ORG_FILES := $(wildcard src/*.org src/parse/*.org)
RS_FILES := $(ORG_FILES:.org=.rs)
MD_FILES := $(ORG_FILES:.org=.md)

usage:
	echo "Usage:"
	echo "    tangle       Extract the source code from the org files"
	echo "    open         Build the project and open the tutorial in your browser"
	echo "    build        Build both the crate and accompanying book"
	echo "    word-count   Get some (rough) statistics about the repository"
	echo "    clean        Remove any unnecessary files and build artefacts"
	echo "    todo         Find all sections marked TODO or FIXME"
	echo "    usage        Print this help text"

open: build-docs tangle
	cargo doc --open
	${OPEN} target/book/index.html

build: build-crate build-docs

build-crate: tangle
	cargo build

build-docs: markdown
	bash -c 'type mdbook' || ${MAKE} try-install target=mdbook
	mdbook build

clean:
	test ! -f src/lib.rs || cargo clean
	git clean -f -x -d

word-count:
	echo -e "lines words file"
	echo -e "----- ----- ----"
	wc --lines --words $$(find src/ -name "*.org")

todo:
	bash -c 'type rg' || ${MAKE} try-install target=ripgrep
	rg 'TODO|FIXME' --iglob '*.org'

emacs:
	bash -c 'type emacs >/dev/null' || (echo Please install emacs; exit 1)

pandoc:
	bash -c 'type pandoc >/dev/null' || (echo Please install pandoc; exit 1)

tangle: emacs ${RS_FILES}

markdown: pandoc ${MD_FILES}

%.md: %.org
	pandoc -r org -i $< -w gfm -o $@

%.rs: %.org
	emacs -Q --batch --eval "(progn (require 'ob-tangle) (org-babel-tangle-file \"$<\" (file-name-nondirectory \"$@\") \"rust\")))"

try-install:
	test -n "${target}" || ( echo must supply target; exit 1 )
	export ans=`bash -c 'read -p "Install ${target} with cargo (N/y)? " ans; \
		ans=$${ans:-n}; echo $${ans:0:1} | tr "[:upper:]" "[:lower:]"'` && \
		test "$$ans" = "y" && \
			cargo install ${target} || \
			exit 10
