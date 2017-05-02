FROM nvidia-gazebo-ros:latest
# This image extends from nvidia-gazebo-ros image to also provide java 8. 
USER root

# ----------------------------------------------------------------------------------
# Install openjdk 8.

# These are needed to have add-apt-repository command
RUN apt-get update && apt-get install -y \
    python-software-properties \
    software-properties-common \
    && add-apt-repository -y ppa:openjdk-r/ppa \
    && apt-get update && apt-get install -y \
        openjdk-8-jdk \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
    
# ----------------------------------------------------------------------------------

# Install the srcsim repository, with keys (need wget for this)
RUN echo "deb http://srcsim.gazebosim.org/src $(lsb_release -cs) main" > /etc/apt/sources.list.d/src-latest.list \
    && wget -O - http://srcsim.gazebosim.org/src/src.key | apt-key add - \
    && wget -O - https://bintray.com/user/downloadSubjectPublicKey?username=bintray | apt-key add - \
    && apt-get update && apt-get install -y \
        srcsim \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# After installing srcsim we need to switch back to java 8
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64
RUN update-alternatives --set java /usr/lib/jvm/java-8-openjdk-amd64/jre/bin/java \
    && update-alternatives --set javac /usr/lib/jvm/java-8-openjdk-amd64/bin/javac \
    && rm /usr/lib/jvm/default-java \
    && ln -s /usr/lib/jvm/java-8-openjdk-amd64 /usr/lib/jvm/default-java

# Environment variable needed for synchronized controller
ENV IS_GAZEBO true
# Consider overriding this ENV var with other IP using the '-e' run command argument
ENV ROS_IP=127.0.0.1

# Change ownership of ihmc_ros_java_adapter. This ROS package requires to write some
# files in its installation directory at runtime. We're working on a fix for this issue. 
# In the meantime, please change the ownership of this directory to your user.
RUN chown -R $USERNAME:$USERNAME /opt/ros/indigo/share/ihmc_ros_java_adapter

# Increase real-time scheduling priority (rtprio) for group ros, which is required by 
# the IHMC controller. Add current user to ros group:
RUN groupadd ros \
    && adduser $USERNAME ros \
    && echo "@ros    -       rtprio      99" > /etc/security/limits.d/ros-rtprio.conf

# setup entrypoint
COPY ./src_entrypoint.sh /
RUN chmod 755 /src_entrypoint.sh

USER $USERNAME
WORKDIR /home/$USERNAME

# Copy IHMC networking ini file
RUN mkdir -p $HOME/.ihmc \
    && curl https://raw.githubusercontent.com/ihmcrobotics/ihmc_ros_core/0.8.0/ihmc_ros_common/configurations/IHMCNetworkParametersTemplate.ini \
      > $HOME/.ihmc/IHMCNetworkParameters.ini

# Download deployed controller and gradle cache
RUN cd $HOME \
    && wget http://gazebosim.org/distributions/srcsim/valkyrie_controller.tar.gz \
    && tar xvf valkyrie_controller.tar.gz \
    && rm valkyrie_controller.tar.gz

# Build srcsim from source
# These are needed to have add-apt-repository command
RUN apt-get update \
 && apt-get install -y \
    python-catkin-tools \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

ENV WS $HOME/ws
RUN mkdir -p ${WS}/src
WORKDIR ${WS}/src
RUN hg clone https://bitbucket.org/osrf/srcsim \
 && cd ${WS} \
 && . /opt/nasa/indigo/setup.sh \
 && catkin init \
 && catkin config --install \
 && cd ${WS}/src/srcsim \
 && hg pull \
 && hg up default \
 && catkin build

# Pre-build ihmc_ros_java_adapter
#RUN . /opt/nasa/indigo/setup.sh \
RUN . ${WS}/install/setup.sh \
 && roslaunch ihmc_valkyrie_ros valkyrie_warmup_gradle_cache.launch

RUN mkdir -p $HOME/gazebo-logs

ENTRYPOINT ["/src_entrypoint.sh"]
