.DEFAULT_GOAL=all
HASKELL_SCRIPTS=repo-item lecture

.PHONY: all clean

all	: ${HASKELL_SCRIPTS}
clean	:
	rm -f ${HASKELL_SCRIPTS}

.SECONDEXPANSION:
${HASKELL_SCRIPTS}: $$@.hs
	ghc --make -O2 $@.hs
