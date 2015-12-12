
FROM java:8-jre

MAINTAINER Niclas Hedhman <niclas@hedhman.org> 
ENV NEWTS_VERSION=1.3.1

# Download and extract OpsCenter
RUN \
  mkdir /opt; \
  cd /opt; \
  curl -L https://github.com/OpenNMS/newts/releases/download/${NEWTS_VERSION}/newts-${NEWTS_VERSION}-bin.tar.gz -o newts-${NEWTS_VERSION}-bin.tar.gz ; \
  tar xvf newts-${NEWTS_VERSION}-bin.tar.gz ; \
  cd newts-${NEWTS_VERSION} \

# Copy over daemons
RUN ln -s /opt/newts-${NEWTS_VERSION}/logs /var/log/newts;

# Initialize Cassandra

RUN \
    cd /opt/newts-${NEWTS_VERSION} \
    bin/init etc/config.yaml

# Expose ports
EXPOSE 8888

WORKDIR /opt/newts-${NEWTS_VERSION}

CMD ["/opt/newts-${NEWTS_VERSION}i/bin/newts -c etc/config.yaml"]

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /opt/*.gz
