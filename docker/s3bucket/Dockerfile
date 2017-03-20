FROM src-cloudsim:latest

USER root

# Instructions based on https://github.com/s3fs-fuse/s3fs-fuse and
# https://github.com/xueshanf/docker-s3fs/. Consider adding their License notice (MIT)
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    automake \
    autotools-dev \
    libcurl4-gnutls-dev \
    libfuse-dev \ 
    libssl-dev \
    libxml2-dev \
    make \
    pkg-config \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Latest release (v1.80)
RUN wget https://github.com/s3fs-fuse/s3fs-fuse/archive/v1.80.tar.gz \
    && tar zxvf v1.80.tar.gz -C /usr/src \
    && rm v1.80.tar.gz \
    && cd /usr/src/s3fs-fuse-1.80 && ./autogen.sh && ./configure --prefix=/usr && make && make install

# Create default mount dir and give w permissions to other users. The cloudsim 
# user will mount s3 on top of this dir, when the s3_entrypoint is exectuted. 
RUN mkdir /mnt/s3bucket && chmod 777 /mnt/s3bucket

ENV S3_BUCKET_NAME cloudsim_default_bucket

# setup entrypoint
COPY ./s3_entrypoint.sh /
COPY ./upload_to_s3.sh /
RUN chmod 755 /s3_entrypoint.sh /upload_to_s3.sh

USER $USERNAME

ENTRYPOINT ["/s3_entrypoint.sh"]
CMD ["/bin/bash"]
