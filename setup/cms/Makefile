# Setup tasks for CMS module
USER=
PASS=
PREFIX=cms_
DATASOURCE="@@DATASOURCE@@"

generate_initial_password:
	printf "login@@SALT@@" | sha384sum 

database:
	mysql -u $(USER) --password=$(PASS) < setup.sql
