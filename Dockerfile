FROM ubuntu

LABEL maintainer="plein@purestorage.com"

# Version of K8s for kubectl install
ENV KUBEVERSION=v1.20.0
# Version of s5cmd
ARG  S5CMDVERSION=1.0.0
# Used by git to download the Gist I host of a file we need
ARG  RUNUTILGIST=841f3e5ce73da9a3bea7e7d31fdb7651
# helps apt run better non-interactively
ARG  DEBIAN_FRONTEND=noninteractive
	
ARG	RUNUTILGIST=841f3e5ce73da9a3bea7e7d31fdb7651
ARG	MYTIMEZONE=America/Chicago

WORKDIR /tmp
RUN apt-get update && apt install -y pv nano wget curl git bash-completion \
	unzip tzdata iperf3 iputils-ping vim \
	&& echo "source /usr/share/bash-completion/bash_completion" >> /root/.bashrc \
	&& ln -fs /usr/share/zoneinfo/${MYTIMEZONE} /etc/localtime
# Install kubectl
RUN curl -LO https://dl.k8s.io/release/${KUBEVERSION}/bin/linux/amd64/kubectl \
	&& install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl \
	&& kubectl completion bash >/etc/bash_completion.d/kubectl \
	&& echo 'alias k=kubectl' >>~/.bashrc \
	&& echo 'complete -F __start_kubectl k' >>~/.bashrc
# Install s5cmd
RUN curl -L https://github.com/peak/s5cmd/releases/download/v${S5CMDVERSION}/s5cmd_${S5CMDVERSION}_Linux-64bit.tar.gz | tar xzf - && \
    mv s5cmd /usr/local/bin/

# Install util.sh "run" command that makes pretty output like you are typing. Useful for demos.
RUN git clone https://gist.github.com/${RUNUTILGIST}.git && mv ${RUNUTILGIST}/util.sh /usr/local/bin/ && chmod +x /usr/local/bin/util.sh \
    && rm -rf ${RUNUTILGIST}

# takes longer to build, but more  secure if you upgrade....
#RUN apt-get -y upgrade 
# cleanup on aisle 4

RUN rm -rf /tmp/* && apt-get clean && rm -rf /var/lib/apt/lists/

WORKDIR /root
# hack to let this run in the background without failing
CMD exec /bin/bash -c "trap : TERM INT; sleep infinity & wait"   
