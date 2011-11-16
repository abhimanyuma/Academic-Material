HTML=index.html lecture-at-a-time.html
SUBDIRS=lectures projects
LITERATE_HASKELL=single-page.lhs
TOHTML  = pandoc -s --to=html --mathml
TOLATEX = pandoc -s --to=latex --template=${TEMPLATES}/latex/lecture.template
include ${DEFAULT_RULES}

all: default-all
clean: default-clean