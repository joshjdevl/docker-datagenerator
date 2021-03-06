FROM ubuntu:trusty
MAINTAINER josh <jjoy [at] cs {dot} ucla {dot} edu>

RUN apt-get update && apt-get -y install python-software-properties software-properties-common
RUN add-apt-repository "deb http://gb.archive.ubuntu.com/ubuntu $(lsb_release -sc) universe"
RUN apt-get update

RUN add-apt-repository ppa:saiarcot895/myppa
RUN apt-get update
RUN apt-get -y install apt-fast

RUN apt-fast -y install git


RUN apt-fast -y install wget sudo vim curl
RUN apt-fast -y install build-essential

ENV PYTHON_VERSION 2.7.8

RUN apt-fast -y install sqlite3 libsqlite3-dev libssl-dev zlib1g-dev libxml2-dev libbz2-dev
ADD https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz /tmp/Python-${PYTHON_VERSION}.tgz
RUN cd /tmp && tar -xvf Python-${PYTHON_VERSION}.tgz
RUN cd /tmp/Python-${PYTHON_VERSION} \
    && ./configure CFLAGSFORSHARED="-fPIC" CCSHARED="-fPIC" --quiet CCSHARED="-fPIC" --prefix=/usr/local/opt/python --exec-prefix=/usr/local/opt/python CCSHARED="-fPIC" \
    && make clean && make -j3 && make install

ENV PATH /usr/local/opt/python/bin:$PATH
RUN ln -s /usr/local/opt/python/bin/python /usr/local/bin/python

#RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python
RUN which python && python --version

RUN cd /tmp && wget https://bootstrap.pypa.io/get-pip.py && python get-pip.py
RUN ln -s /usr/local/opt/python/bin/pip /usr/local/bin/pip

RUN pip install distribute==0.7.3 && pip install setuptools==6.1 && pip install -U pip

ADD requirements.txt /tmp/requirements.txt
RUN pip install -r /tmp/requirements.txt

RUN add-apt-repository ppa:webupd8team/java
RUN apt-get update
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | \
    /usr/bin/debconf-set-selections
RUN apt-fast install -y oracle-java8-installer
RUN apt-fast install -y oracle-java8-set-default

ENV SCALA_VERSION 2.9.2
ENV PATH /opt/scala-$SCALA_VERSION/bin:$PATH

RUN wget -q http://www.scala-lang.org/files/archive/scala-$SCALA_VERSION.tgz -O /tmp/scala_$SCALA_VERSION.tgz
RUN tar xfz /tmp/scala_$SCALA_VERSION.tgz -C /opt

ENV MAVEN_VERSION 3.2.2
ADD http://www.us.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz
RUN tar xfz /tmp/apache-maven-$MAVEN_VERSION-bin.tar.gz -C /opt

ENV PATH /opt/apache-maven-$MAVEN_VERSION/bin:$PATH


