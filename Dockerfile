FROM smizy/hbase:1.3-alpine

ARG BUILD_DATE="2020-02-01"
# ARG VCS_REF
ARG VERSION="4.14.3"

LABEL \
    maintainer="milnomada" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.license="Apache License 2.0" \
    org.label-schema.name="milnomada/apache-phoenix" \
    org.label-schema.url="https://github.com/milnomada" \
    org.label-schema.vcs-type="Git" \
    org.label-schema.vcs-url="https://github.com/milnomada/docker-apache-phoenix"

ENV PHOENIX_VERSION   $VERSION
ENV PHOENIX_VER       4.14.3
# ENV HBASE_VER         1.3

# Updated
ENV HBASE_VER         1.3

ENV PHOENIX_HOME      /usr/local/phoenix-${PHOENIX_VER}

ENV PATH $PATH:${PHOENIX_HOME}/bin

RUN set -x \
    && apk update \
    && apk --no-cache add \
        bash \
        su-exec \
        python \
        wget \
    && mirror_url="http://apache.rediris.es" \
    #&& mirror_url=$( \
    #    wget -q -O - "http://www.apache.org/dyn/closer.cgi/?as_json=1" \
    #    | grep "preferred" \
    #    | sed -n 's#.*"\(http://*[^"]*\)".*#\1#p' \
    #    ) \
    && package_name="apache-phoenix-${PHOENIX_VERSION}-HBase-${HBASE_VER}" \
    && wget -q -O - ${mirror_url}/phoenix/${package_name}/bin/${package_name}-bin.tar.gz \
        | tar -xzf - -C /usr/local \
    && mv /usr/local/${package_name}-bin ${PHOENIX_HOME} \
    && cd ${PHOENIX_HOME} \
    && mkdir -p server \
    && mv *-server.jar server/ \
    ## cleanup    
    && rm *-tests.jar *-sources.jar 

## Add user-specified CLASSPATH
ENV HBASE_CLASSPATH ${PHOENIX_HOME}/server/*

WORKDIR ${PHOENIX_HOME}
