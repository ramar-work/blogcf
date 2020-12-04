# myst - project makefile version 1
# 
# This should contain all the recipes needed to duplicate this project 
# on another platform.
#
# TODO 
# Datasources need to be created as well...
#
SED=sed
TAR=tar
DATE=date
DBUSER=
DBPASSWORD=
DATASOURCE=rcdb
DBSERVER="localhost"
SQLFILE=setup/tmp.setup.sql
SQLBIN=
SQLFLAGS=
SCHEMA=
# TODO: Loop through this and check only for these in deps
SUPPORTED_DB_BACKEND=

#help - Show help
help:
	@printf "Available options are:\n"
	@grep '^#[a-z]' Makefile | sed 's/^#//'

#pkg - Make an archive of files.
pkg:
	git archive --format=tar dev | gzip > /tmp/$$(basename $$(pwd))-$$(date +%F).tar.gz
