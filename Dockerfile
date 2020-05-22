FROM ubuntu:xenial

LABEL MAINTAINER="Weerayut Hongsa <kusumoto.com@gmail.com>"

ARG NODEJS_VERSION="10"
ARG IONIC_VERSION="6.9.2"
ARG ANDROID_SDK_VERSION="6200805"
ARG ANDROID_HOME="/opt/android-sdk"
ARG ANDROID_BUILD_TOOLS_VERSION="29.0.3"

# 1) Install system package dependencies
# 2) Install Nodejs/NPM/Ionic-Cli
# 3) Install Android SDK
# 4) Install SDK tool for support ionic build command
# 5) Cleanup
# 6) Add and set user for use by ionic and set work folder

ENV ANDROID_HOME "${ANDROID_HOME}"

RUN apt-get update \
    && apt-get install -y \
       build-essential \
       openjdk-8-jre \
       openjdk-8-jdk \
       curl \
       unzip \
       git \
       gradle
RUN curl -sL https://deb.nodesource.com/setup_${NODEJS_VERSION}.x | bash - \
    && apt-get update \
    && apt-get install -y nodejs
RUN npm install -g cordova @ionic/cli@${IONIC_VERSION}
RUN cd /tmp \
    && curl -fSLk https://dl.google.com/android/repository/commandlinetools-linux-${ANDROID_SDK_VERSION}_latest.zip -o sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && unzip sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \
    && mkdir /opt/android-sdk \
    && mkdir /opt/android-sdk/cmdline-tools \
    && mv tools /opt/android-sdk/cmdline-tools \
    && yes | $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager --licenses
RUN $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager "platform-tools" \
    && $ANDROID_HOME/cmdline-tools/tools/bin/sdkmanager "build-tools;${ANDROID_BUILD_TOOLS_VERSION}"
RUN apt-get autoremove -y \
    && rm -rf /tmp/sdk-tools-linux-${ANDROID_SDK_VERSION}.zip \ 
    && mkdir /ionicapp

WORKDIR /ionicapp
