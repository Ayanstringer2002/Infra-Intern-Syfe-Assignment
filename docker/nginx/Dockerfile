FROM ubuntu:22.04 as builder

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libpcre3-dev \
    libssl-dev \
    perl \
    make \
    curl \
    zlib1g-dev \
    libpq-dev \
    libiconv-hook-dev \
    wget

# Download and build OpenResty
WORKDIR /tmp
RUN wget https://openresty.org/download/openresty-1.21.4.1.tar.gz && \
    tar -xzf openresty-1.21.4.1.tar.gz

WORKDIR /tmp/openresty-1.21.4.1
RUN ./configure \
    --prefix=/opt/openresty \
    --with-pcre-jit \
    --with-ipv6 \
    --without-http_redis2_module \
    --with-http_iconv_module \
    --with-http_postgres_module \
    -j8

RUN make -j8 && make install

# Runtime stage
FROM ubuntu:22.04

RUN apt-get update && apt-get install -y \
    libpcre3 \
    libssl3 \
    zlib1g \
    libpq5 \
    curl \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /opt/openresty /opt/openresty

# Create nginx user
RUN useradd -r -s /bin/false nginx

# Create directories
RUN mkdir -p /var/log/nginx /var/cache/nginx

# Copy nginx configuration
COPY nginx.conf /opt/openresty/nginx/conf/nginx.conf
COPY lua-scripts /opt/openresty/nginx/conf/lua-scripts

# Expose port
EXPOSE 80

# Health check
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost/health || exit 1

# Start nginx
CMD ["/opt/openresty/nginx/sbin/nginx", "-g", "daemon off;"]