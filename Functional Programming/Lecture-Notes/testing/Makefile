include Makefile.configure


ROOT=$(abspath .)
DEFAULT_RULES=${ROOT}/defaults/Makefile
SCRIPTS=${ROOT}/scripts
MACROS=${ROOT}/macros
TEMPLATES=${ROOT}/templates

export SOURCE
export DESTINATION
export BASE_URL
export DEFAULT_RULES
export SCRIPTS
export MACROS
export TEMPLATES


.PHONY: all clean update update-dryrun
all:
	make -C ${SCRIPTS}
	make -C ${SOURCE}
clean:
	make -C ${SCRIPTS} clean
	make -C ${SOURCE} clean

update: all
	make -C ${SOURCE} .files
	rsync -avz --files-from=${SOURCE}/.files ${SOURCE} ${DESTINATION}

update-dryrun: all
	make -C ${SOURCE} .files
	rsync -avz --dry-run --files-from=${SOURCE}/.files ${SOURCE} ${DESTINATION}