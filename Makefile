# Copyright (C) 2006-2009, The Perl Foundation.
# $Id$

# Path to parrot_config
PARROT_CONFIG = parrot_config

# arguments we want to run parrot with
PARROT_ARGS =

# values from parrot_config
PARROT_BIN_DIR = $(shell $(PARROT_CONFIG) bindir)
PARROT_LIB_DIR = $(shell $(PARROT_CONFIG) libdir)$(shell $(PARROT_CONFIG) versiondir)
LOAD_EXT       = $(shell $(PARROT_CONFIG) loadext)
O              = $(shell $(PARROT_CONFIG) o)
EXE            = $(shell $(PARROT_CONFIG) exe)
PERL           = $(shell $(PARROT_CONFIG) perl)
$(eval RM_F = $(shell $(PARROT_CONFIG) rm_f))

# Various paths
PERL6GRAMMAR   = $(PARROT_LIB_DIR)/library/PGE/Perl6Grammar.pbc
NQP_PBC        = $(PARROT_LIB_DIR)/languages/nqp/nqp.pbc

# Set up extensions

# Setup some commands
PARROT         := $(PARROT_BIN_DIR)/parrot$(EXE)
PBC_TO_EXE     = $(PARROT_BIN_DIR)/pbc_to_exe$(EXE)

PIR_SOURCES = genfile.pir \
  src/genfile_grammar.pir \
  src/genfile_actions.pir \
  src/Compiler.pir \
  src/Node.pir

CLEANUPS = \
  genfile.pbc \
  genfile.c \
  genfile$(O) \
  genfile$(EXE) \
  src/genfile_grammar.pir \
  src/genfile_actions.pir

# the default target
all: genfile$(EXE)

# targets for building a standalone genfile
genfile$(EXE): genfile.pbc
	$(PBC_TO_EXE) genfile.pbc

genfile.pbc: $(PARROT) $(PIR_SOURCES)
	$(PARROT) $(PARROT_ARGS) -o genfile.pbc genfile.pir

src/genfile_grammar.pir: $(PERL6GRAMMAR) src/parser/parser.pg src/parser/makefile.pg
	$(PARROT) $(PARROT_ARGS) $(PERL6GRAMMAR) \
	    --output=src/genfile_grammar.pir \
	    src/parser/parser.pg src/parser/makefile.pg

src/genfile_actions.pir: $(NQP_PBC) src/parser/actions.pm
	$(PARROT) $(PARROT_ARGS) $(NQP_PBC) --output=src/genfile_actions.pir \
	    --target=pir src/parser/actions.pm

# This is a listing of all targets, that are meant to be called by users
help:
	@echo ""
	@echo "Following targets are available for the user:"
	@echo ""
	@echo "  all:               genfile.pbc"
	@echo "                     This is the default."
	@echo "Cleaning:"
	@echo "  clean:             Basic cleaning up."
	@echo ""
	@echo "Misc:"
	@echo "  help:              Print this help message."
	@echo ""

##  cleaning
clean:
	$(RM_F) $(CLEANUPS)
