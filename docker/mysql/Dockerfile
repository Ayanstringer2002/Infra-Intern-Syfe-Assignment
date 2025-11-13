FROM mysql:8.0

# Custom MySQL configuration
COPY my.cnf /etc/mysql/conf.d/
RUN chown mysql:mysql /etc/mysql/conf.d/my.cnf

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
    CMD mysqladmin ping -h localhost -u root -p${MYSQL_ROOT_PASSWORD} || exit 1