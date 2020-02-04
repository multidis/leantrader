## Phusion baseimage based Ubuntu setup with all LEAN dependencies
## https://github.com/QuantConnect/Lean/blob/master/DockerfileLeanFoundation
## CAUTION: Do not upgrade Python further due to Python.NET issues!
FROM quantconnect/lean:foundation

# miscellaneous dependencies from Ubuntu repositories
RUN apt-get -qq update && \
    apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" && \
    apt-get install -y -q \
        sudo \
        apt-utils \
        git \
        libc6 \
        libc6-dev \
        build-essential \
        gcc \
        wget \
        curl \
        file \
        unzip \
        pkg-config \
        inotify-tools \
        libreadline-dev \
        libncurses-dev \
        libpcre3-dev \
        libgnutls-dev \
        libffi-dev \
        libssl-dev \
        cmake \
        gfortran \
        glpk-utils \
        openssh-client \
    && \
    apt-get clean && rm -rf /tmp/* /var/tmp/*

# user path
RUN mkdir -p /home/leanu
# $HOME effective for the remainder of this Dockerfile only
ENV HOME /home/leanu
WORKDIR /home/leanu

# AWS CLI utility
RUN mkdir -p /tmp/install/awscli
RUN cd /tmp/install/awscli
RUN curl "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip" -o "awscli-bundle.zip"
RUN unzip awscli-bundle.zip
RUN sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

# custom container scripts
###


# custom script upon container launch: includes Lean config edits and rebuild
RUN mkdir -p /etc/my_init.d
ADD init_custom.sh /etc/my_init.d/init_custom.sh
RUN chmod +x /etc/my_init.d/init_custom.sh

# LEAN code itself
RUN wget https://github.com/QuantConnect/Lean/archive/master.zip && \
 unzip master.zip

# prepare LEAN with libraries (NuGet packages)
RUN \
 cd /home/leanu/Lean-master && \
 wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe && \
 mono nuget.exe restore QuantConnect.Lean.sln -NonInteractive

# LEAN algorithm source files and configurations
COPY config.json /home/leanu/Lean-master/Launcher/config.json
COPY Algorithm.CSharp/QuantConnect.Algorithm.CSharp.csproj /home/leanu/Lean-master/Algorithm.CSharp/QuantConnect.Algorithm.CSharp.csproj
COPY Algorithm.CSharp/Main.cs /home/leanu/Lean-master/Algorithm.CSharp/Main.cs

# build LEAN algorithm project
RUN \
 cd /home/leanu/Lean-master && \
 msbuild /property:Configuration=Release /home/leanu/Lean-master/Launcher/QuantConnect.Lean.Launcher.csproj && \
 cd /home/leanu/Lean-master/Launcher/bin/Release

# keep restarting LEAN and related monitoring services
COPY tradealgo.sh /home/leanu/Lean-master/Launcher/bin/Release/tradealgo.sh
RUN chmod +x /home/leanu/Lean-master/Launcher/bin/Release/tradealgo.sh
RUN mkdir /etc/service/leanrun
COPY tradealgo_run.sh /etc/service/leanrun/run
RUN chmod +x /etc/service/leanrun/run


WORKDIR /home/leanu/Lean-master/Launcher/bin/Release/

