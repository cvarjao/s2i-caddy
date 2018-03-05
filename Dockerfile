FROM registry.access.redhat.com/rhel7/rhel
#FROM centos
MAINTAINER shea.phillips@cloudcompass.ca

LABEL io.openshift.s2i.scripts-url=image:///usr/local/s2i
ENV PATH $PATH:/opt/caddy
ENV CADDY_URI https://github.com/mholt/caddy/releases/download/v0.10.11/caddy_v0.10.11_linux_amd64.tar.gz
RUN echo "Installing caddy" && mkdir -p /opt/caddy && cd /opt/caddy && curl -L "${CADDY_URI}" | tar -xvz &&  /opt/caddy/caddy -version -agree
    
## Copy the S2I scripts into place
COPY ./.s2i/bin/ /usr/local/s2i

ADD Caddyfile /etc/Caddyfile

# Create the location where we will store our content, and fiddle the permissions so we will be able to write to it.
# Also twiddle the permissions on the Caddyfile so we will be able to overwrite it with a user-provided one if desired.
RUN mkdir -p /var/www/html && chmod g+w /var/www/html && chmod g+w /etc/Caddyfile && chmod -R a+rw /tmp

# Expose the port for the container to Caddy's default
EXPOSE 2015

USER 1001

#ENTRYPOINT ["/sbin/tini"]

CMD ["sh","/usr/local/s2i/usage"]
