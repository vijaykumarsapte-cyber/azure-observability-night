FROM --platform=linux/amd64 postgres:15

COPY init.sql /docker-entrypoint-initdb.d/init.sql

EXPOSE 5432

CMD ["postgres"]
