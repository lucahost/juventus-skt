FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu
EXPOSE 1433

LABEL  "MAINTAINER" "Enrique Catalá Bañuls <enrique@enriquecatala.com>"
LABEL "Project" "Microsoft SQL Server container with sample databases"

RUN apt-get update && apt-get install -y  \
	curl \
	apt-transport-https

RUN mkdir -p /var/opt/mssql/backup
WORKDIR /var/opt/mssql/backup

##############################################################
# DATABASES SECTION
#    1) Add here the databases you want to have in your image
#    2) Edit setup.sql and include the RESTORE commands
#

# Adventureworks databases
#
RUN curl -L -o AdventureWorks2017.bak https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2017.bak

##############################################################

RUN mkdir -p /usr/config
WORKDIR /usr/config/

COPY setup.* ./
COPY entrypoint.sh ./

RUN chmod +x setup.sh
RUN chmod +x entrypoint.sh

# This entrypoint start sql server, restores data and waits infinitely
ENTRYPOINT ["./entrypoint.sh"]

CMD ["sleep infinity"]