FROM centos:7 AS python_builder

ENV WORKSPACE="/workspace"

# compile dev
RUN yum -y groupinstall "Development tools" && \
    yum -y install zlib-devel bzip2-devel openssl-devel \
    ncurses-devel sqlite-devel readline-devel tk-devel  \
    gdbm-devel db4-devel libpcap-devel xz-devel libffi-devel wget

ADD resource/python/Python-3.7.5.tar.xz /tmp

RUN mkdir -p $WORKSPACE/python3.7 && \
    cd /tmp/Python-3.7.5 && \
    ./configure --prefix=$WORKSPACE/python3.7 && \
    make && make install

RUN ln -s $WORKSPACE/python3.7/bin/python3 /usr/local/bin/python3 && \
    ln -s $WORKSPACE/python3.7/bin/pip3 /usr/local/bin/pip3
ARG PIP_INDEX="-i http://mirrors.cloud.tencent.com/pypi/simple/ --trusted-host mirrors.cloud.tencent.com"
ENV PIP_INDEX=$PIP_INDEX
RUN pip3 install $PIP_INDEX -U pip==21.3.1 && \
    pip3 install $PIP_INDEX virtualenvwrapper==4.8.4

RUN cd $WORKSPACE && tar -zcvf python3.7.tar.gz --exclude=*.pyc python3.7



FROM centos:7

# timezone
ENV TZ Asia/Shanghai
RUN ln -fs /usr/share/zoneinfo/${TZ} /etc/localtime && echo ${TZ} > /etc/timezone

# passwd
RUN cat /dev/urandom | head -n 10 | md5sum | cut -c 1-10 > /root/.passwd && \
    echo "root:$(cat /root/.passwd)" | chpasswd

# yum
RUN yum -y update ca-certificates && \
    yum -y install epel-release openssh-server which python-pip && \
    yum clean all && \
    rm -rf /etc/ld.so.cache && \
	rm -rf /sbin/sln && \
	rm -rf /usr/{{lib,share}/locale,share/{man,doc,info,cracklib,i18n},{lib,lib64}/gconv,bin/localedef,sbin/build-locale-archive} && \
	rm -rf /{root,tmp,var/cache/{ldconfig,yum}}/* 


# openssh
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -t ecdsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -t ed25519 -f  /etc/ssh/ssh_host_ed25519_key
RUN sed -i \
    -e 's~^#PermitRootLogin yes~PermitRootLogin yes~g' \
    -e 's~^#PubkeyAuthentication yes~PubkeyAuthentication yes~g' \
    /etc/ssh/sshd_config

# workspace
ENV WORKSPACE="/workspace"
RUN mkdir -p $WORKSPACE

# python3
COPY --from=python_builder $WORKSPACE/python3.7.tar.gz /tmp/python3.7.tar.gz

VOLUME $WORKSPACE
EXPOSE 22

CMD /usr/sbin/sshd;/bin/bash
