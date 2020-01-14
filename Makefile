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

#check - Check for dependencies and show help
check:
	@printf "Checking for sh...\n"
	@which sh >/dev/null 2>/dev/null || printf "sh not in path...\n"
	@which sh > /dev/null
	@printf "Checking for sqlcmd...\n"
	@which sqlcmd >/dev/null 2>/dev/null || printf "sqlcmd not in path...\n"
	@which sqlcmd > /dev/null
	@printf "Checking for sed...\n"
	@which sed >/dev/null 2>/dev/null || printf "sed not in path...\n"
	@which sed > /dev/null

#deploy-mssql - Create databases for a Microsoft SQL Server backend
deploy-mssql: SQLBIN=sqlcmd
deploy-mssql: assemble
deploy-mssql:
	@echo '$(SQLBIN) is not yet supported...'	
	@test -z "bob"
	@$(SQLBIN) -S $(DBSERVER) -i $(SQLFILE) -U $(DBUSER) -P $(DBPASSWORD)

#deploy-mysql - Create databases for a MySQL server backend
deploy-mysql: SQLBIN=mysql
deploy-mysql: assemble
deploy-mysql:
	@$(SQLBIN) -e 'CREATE DATABASE IF NOT EXISTS $(DATASOURCE)' -u $(DBUSER) --password=$(DBPASSWORD)
	@$(SQLBIN) -D $(DATASOURCE) -u $(DBUSER) --password=$(DBPASSWORD) < $(SQLFILE)

#deploy-pgsql - Create databases for a PostgreSQL server backend
deploy-pgsql: SQLBIN=psql
deploy-pgsql: assemble
deploy-pgsql:
	@echo 'PostgreSQL is not yet supported...'	
	@test -z "bob"

#assemble - Put all static SQL into one file and load it
assemble:
	@find -type f -name setup.sql | sort -r > $(SQLFILE)

#clean - Clean any generated files
clean:
	@rm -f $(SQLFILE)
