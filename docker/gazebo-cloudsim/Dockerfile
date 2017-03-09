FROM ubuntu:trusty

# setup environment
ENV DEBIAN_FRONTEND noninteractive
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    wget \   
    bash-completion \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# Add gazebo repository
RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'
RUN wget http://packages.osrfoundation.org/gazebo.key -O - | sudo apt-key add -
RUN apt-get update

# Create a user with passwordless sudo
RUN adduser --gecos "Development User" --disabled-password gazebo
RUN adduser gazebo sudo
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN echo "export QT_X11_NO_MITSHM=1" >> /home/gazebo/.bashrc

# Install Gazebo 7
RUN apt-get install -y gazebo7

ENV USERNAME gazebo

USER $USERNAME
WORKDIR /home/$USERNAME

# Get gazebo models by calling wget here
# Do it early since it's big
RUN wget -P /tmp/ https://bitbucket.org/osrf/gazebo_models/get/default.tar.gz \
 && mkdir -p $HOME/.gazebo/models \
 && tar -xvf /tmp/default.tar.gz -C $HOME/.gazebo/models --strip 1 \
 && rm /tmp/default.tar.gz

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
