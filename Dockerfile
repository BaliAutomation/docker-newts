
FROM java:8-jre

MAINTAINER Niclas Hedhman <niclas@hedhman.org> 
ENV NEWTS_VERSION=1.3.1
ENV NEWTS_DOWNLOAD_URL=https://github.com/OpenNMS/newts/releases/download/${NEWTS_VERSION}/newts-${NEWTS_VERSION}-bin.tar.gz

# Add user and group
RUN groupadd -r newts && useradd -r -g newts newts


# Download and extract OpsCenter
RUN \
  cd /opt; \
  curl -L ${NEWTS_DOWNLOAD_URL} -o newts-${NEWTS_VERSION}-bin.tar.gz ; \
  tar xvf newts-${NEWTS_VERSION}-bin.tar.gz; \
  mv newts-${VERSION} newts; \
  chown -R newts:newts /opt/newts

# Copy over daemons
RUN ln -s /opt/newts-${NEWTS_VERSION}/logs /var/log/newts;

# Clean up 'root' activity
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/*.gz

USER newts

# Initialize Cassandra
RUN \
    cd /opt/newts-${NEWTS_VERSION} \
    bin/init etc/config.yaml

# Expose ports
EXPOSE 8888


CMD ["/opt/newts/bin/newts -c etc/config.yaml"]

