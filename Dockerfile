FROM ruby:3.2.2-buster

RUN echo 'install: --no-document\nupdate: --no-document' >> /usr/local/etc/gemrc

RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
	bison \
	libgdbm-dev \
	&& rm -rf /var/lib/apt/lists/*

ENV RUBYGEMS_VERSION 3.4.10

RUN gem update --system "$RUBYGEMS_VERSION"

ENV BUNDLER_VERSION 2.3.26
RUN gem install bundler --version "$BUNDLER_VERSION"

ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH

RUN mkdir /cropio-backupper
WORKDIR /cropio-backupper

COPY . .

RUN bundle update \
	&& bundle install

CMD ["bundle", "exec", "rake", "download_data"]
