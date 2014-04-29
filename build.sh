#!/bin/bash
set -e

VERSION=${VERSION:-1.4.3.6}
LUAROCKS_VERSION=${LUAROCKS_VERSION:-2.1.2}

apt-get update
apt-get -y install make git-core libpcre3-dev libgeoip-dev unzip zip build-essential curl libssl-dev

cd /tmp

curl -O http://openresty.org/download/ngx_openresty-$VERSION.tar.gz
tar -zxvf ngx_openresty-$VERSION.tar.gz

cd ngx_openresty-$VERSION
./configure \
    --prefix=/usr/local \
    --with-luajit \
    --conf-path=/etc/nginx.conf \
    --error-log-path=/tmp/error.log \
    --http-log-path=/tmp/access.log \
    --sbin-path=/usr/local/sbin/nginx \
    --http-client-body-temp-path=/tmp/client-body-temp-path \
    --http-proxy-temp-path=/tmp/proxy-temp-path \
    --http-fastcgi-temp-path=/tmp/fastcgi-temp-path \
    --http-uwsgi-temp-path=/tmp/uwsgi-temp-path \
    --http-scgi-temp-path=/tmp/scgi-temp-path \
    --lock-path=/tmp/nginx.lock \
    --pid-path=/tmp/nginx.pid \
    --with-http_geoip_module \
    --with-http_gzip_static_module \
    --with-http_realip_module \
    --with-http_stub_status_module \
    --with-http_ssl_module \
    --with-http_sub_module \
    --with-ipv6 \
    --with-http_stub_status_module \
    --with-http_secure_link_module \
    --with-http_sub_module \
    --with-pcre && \
    make && \
    make install

cd /tmp
curl -O http://luarocks.org/releases/luarocks-$LUAROCKS_VERSION.tar.gz
tar -zxvf luarocks-$LUAROCKS_VERSION.tar.gz
cd luarocks-$LUAROCKS_VERSION
./configure \
    --prefix=/usr/local \
    --lua-suffix=jit \
    --with-lua-include=/usr/local/luajit/include/luajit-2.0/ \
    --with-lua=/usr/local/luajit --with-lua-lib=/usr/local/lualib && \
    make build && \
    make install

rm -rf /tmp/*
apt-get autoremove -y
dpkg --get-selections | grep -v deinstall | awk '{print $1}' | grep -- '-dev$' | xargs apt-get -y purge
apt-get clean -y
rm -rf /var/lib/apt/lists/*



