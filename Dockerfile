FROM ubuntu

LABEL maintainer="plein@purestorage.com"

# Version of K8s for kubectl install
ENV KUBEVERSION=v1.22.6
# Version of s5cmd
ARG  S5CMDVERSION=1.0.0
# Used by git to download the Gist I host of a file we need
ARG  RUNUTILGIST=841f3e5ce73da9a3bea7e7d31fdb7651
# helps apt run better non-interactively
ARG  DEBIAN_FRONTEND=noninteractive
ARG	 MYTIMEZONE=America/Chicago

WORKDIR /tmp
RUN apt-get update && apt install --no-install-recommends -y pv nano git bash-completion fio \
	unzip tzdata iperf3 iputils-ping vim sysstat \
	&& apt install -y wget curl openssh-client binutils \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /var/log/*

# Install kubectl
RUN curl -LO https://dl.k8s.io/release/${KUBEVERSION}/bin/linux/amd64/kubectl \
	&& install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
	&& kubectl completion bash >/etc/bash_completion.d/kubectl \
	&& echo 'alias k=kubectl' >>~/.bashrc \
	&& echo 'complete -F __start_kubectl k' >>~/.bashrc \
	&& rm -rf /tmp/*
# Install s5cmd
RUN curl -L https://github.com/peak/s5cmd/releases/download/v${S5CMDVERSION}/s5cmd_${S5CMDVERSION}_Linux-64bit.tar.gz | tar xzf - \
    && mv s5cmd /usr/local/bin/
# Install awscli
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install \
	&& rm -rf ./aws/
# Install util.sh "run" command that makes pretty output like you are typing. Useful for demos.
# RUN git clone https://gist.github.com/${RUNUTILGIST}.git \
#    && mv ${RUNUTILGIST}/util.sh /usr/local/bin/ \
#	&& chmod +x /usr/local/bin/util.sh

# takes longer to build, but more  secure if you upgrade....
#RUN apt-get -y upgrade 
WORKDIR /root

# hack to let this run in the background without failing
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"   
