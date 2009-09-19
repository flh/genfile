# Copyright (C) 2006-2009, The Perl Foundation.
# $Id$

# arguments we want to run parrot with
PARROT_ARGS =

# values from parrot_config
BUILD_DIR     = /home/florian/devel/parrot/parrot
LOAD_EXT      = .so
O             = .o
EXE           = 
PERL          = /usr/bin/perl
RM_F          = $(PERL) -MExtUtils::Command -e rm_f

# Various paths
PARROT_DYNEXT = $(BUILD_DIR)/runtime/parrot/dynext
PERL6GRAMMAR  = $(BUILD_DIR)/runtime/parrot/library/PGE/Perl6Grammar.pbc
NQP           = $(BUILD_DIR)/compilers/nqp/nqp.pbc
PCT           = $(BUILD_DIR)/runtime/parrot/library/PCT.pbc

# Set up extensions

# Setup some commands
PARROT        = $(BUILD_DIR)/parrot$(EXE)
CAT           = $(PERL) -MExtUtils::Command -e cat
PBC_TO_EXE    = $(BUILD_DIR)/pbc_to_exe$(EXE)

SOURCES = genfile.pir \
  genfile_grammar.pir \
  genfile_actions.pir

BUILTINS_PIR = # \

CLEANUPS = \
  genfile.pbc \
  genfile.c \
  genfile$(O) \
  genfile$(EXE) \
  genfile_grammar.pir \
  genfile_actions.pir

# the default target
all: genfile$(EXE)

# targets for building a standalone genfile
genfile$(EXE): genfile.pbc
	$(PBC_TO_EXE) genfile.pbc
	
genfile.pbc: $(PARROT) $(SOURCES)
	$(PARROT) $(PARROT_ARGS) -o genfile.pbc genfile.pir

genfile_grammar.pir: $(PERL6GRAMMAR) parser.pg
	$(PARROT) $(PARROT_ARGS) $(PERL6GRAMMAR) \
	    --output=genfile_grammar.pir \
	    parser.pg

genfile_actions.pir: $(NQP) $(PCT) actions.pm
	$(PARROT) $(PARROT_ARGS) $(NQP) --output=genfile_actions.pir \
	    --target=pir actions.pm

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
clean: testclean
	$(RM_F) $(CLEANUPS)
