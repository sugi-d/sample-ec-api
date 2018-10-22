FROM ruby:2.5.3
ENV LANG C.UTF-8
ENV RAILS_ENV development
ENV ENTRYKIT_VERSION 0.4.0
ENV DOCKERIZE_VERSION v0.3.0

# Install softwares
RUN apt-get update -qq \
    && apt-get install -y \
    wget \
    ca-certificates \
    openssl \
    build-essential \
    mysql-client \
    libv8-dev \
    vim

# Install entrykit
WORKDIR /
RUN wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz \
    && mv entrykit /bin/entrykit \
    && chmod +x /bin/entrykit \
    && entrykit --symlink

# Install dockerize
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-linux-amd64-$DOCKERIZE_VERSION.tar.gz

RUN mkdir /app
WORKDIR /app
ADD Gemfile* /app/

RUN gem update --system
RUN gem install bundler

# Alias
RUN echo 'alias ll="ls -laG"' >> /root/.bashrc

ENTRYPOINT [ \
    "prehook", \
        "dockerize -timeout 60s -wait tcp://db:3306", "--", \
    "prehook", \
        "bundle install -j4 --path /usr/local/bundle", "--" \
]
