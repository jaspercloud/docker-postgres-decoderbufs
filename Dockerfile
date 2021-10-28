FROM centos:7

RUN yum install -y make gcc gcc-c++ glibc-headers zlib-devel.x86_64 readline-devel.x86_64 which

COPY ./postgresql-9.6.10.tar.gz /tmp/
RUN cd /tmp \
&& tar -xvf postgresql-9.6.10.tar.gz \
&& cd /tmp/postgresql-9.6.10 \
&& ./configure --with-pgport=5432 --with-system-tzdata=/usr/share/zoneinfo --prefix=/usr/local --with-includes=/usr/local/include --with-libraries=/usr/local/lib \
&& make \
&& make install

COPY ./protobuf-2.6.1.tar.gz /tmp/
RUN cd /tmp \
&& tar -xvf protobuf-2.6.1.tar.gz \ 
&& cd /tmp/protobuf-2.6.1 \
&& ./configure \
&& make \
&& make install

COPY ./protobuf-c-1.2.1.tar.gz /tmp/
RUN export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig \ 
&& cd /tmp \
&& tar -xvf protobuf-c-1.2.1.tar.gz \
&& cd /tmp/protobuf-c-1.2.1 \
&& ./configure \
&& make \
&& make install

COPY ./pkg-config-0.29.tar.gz /tmp/
RUN cd /tmp \
&& tar -xvf pkg-config-0.29.tar.gz \
&& cd /tmp/pkg-config-0.29 \
&& yum install -y glib2-devel.x86_64 \
&& ./configure \
&& make \
&& make install

COPY ./postgres-decoderbufs.gz /tmp/
RUN cd /tmp \
&& tar -xvf postgres-decoderbufs.gz \
&& cd /tmp/postgres-decoderbufs \
&& make \
&& make install

COPY ./wal2json.tar.gz /tmp/
RUN cd /tmp \
&& tar -xvf wal2json.tar.gz \
&& cd /tmp/wal2json \
&& make \
&& make install

RUN adduser postgres \
&& mkdir /var/lib/postgresql \
&& chown -R postgres:postgres /var/lib/postgresql

ENV PGDATA /var/lib/postgresql/data

RUN sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/local/share/postgresql/postgresql.conf.sample; \
grep -F "listen_addresses = '*'" /usr/local/share/postgresql/postgresql.conf.sample

COPY ./boot.sh /boot.sh

CMD /boot.sh 

