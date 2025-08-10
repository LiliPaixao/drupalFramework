FROM php:8.3-apache

# Corrija vulnerabilidades instalando apenas as dependências necessárias e removendo caches
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates \
        libjpeg-dev \
        libpng-dev \
        libwebp-dev \
        libzip-dev \
        libxml2-dev \
        libxslt1-dev \
        libicu-dev \
        libpq-dev \
        libldap2-dev \
        libssl-dev \
        libonig-dev \
        zlib1g-dev \
        bash-completion \
        default-mysql-client \
        git \
        wget \
        unzip \
        nano \
        vim \
        sudo \
        htop \
        iputils-ping \
        dnsutils \
        imagemagick \
        graphviz \
        memcached \
        libmemcached-tools \
        libmemcached-dev \
        linux-libc-dev \
        libyaml-dev \
        ruby-dev \
        rubygems \
    && rm -rf /var/lib/apt/lists/*

# Ensure all packages are up-to-date to reduce vulnerabilities
RUN apt-get update && apt-get upgrade -y

# Instala extensões necessárias para o Drupal
RUN apt-get update && apt-get install -y \
	  ruby-dev \
      rubygems \
      imagemagick \
      graphviz \
      memcached \
      libmemcached-tools \
      libmemcached-dev \
      libjpeg-dev \
      libmcrypt-dev \
      libxml2-dev \
      libxslt1-dev \
      default-mysql-client \
      sudo \
      git \
      vim \
      nano \
      zip \
      wget \
      htop \
      iputils-ping \
      dnsutils \
      linux-libc-dev \
      libyaml-dev \
      libpng-dev \
      zlib1g-dev \
      libzip-dev \
      libicu-dev \
      libpq-dev \
      bash-completion \
      libldap2-dev \
      libssl-dev \
      libonig-dev \
	  libwebp-dev \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-configure gd --with-webp --with-jpeg \
    && docker-php-ext-install gd

RUN apt-get update && \
    apt-get install -y \
        zlib1g-dev \
        && docker-php-ext-install zip

# Install php extensions + added mysqli install
RUN docker-php-ext-install opcache pdo pdo_mysql && docker-php-ext-install mysqli

# Installation of Composer
RUN cd /usr/src && curl -sS http://getcomposer.org/installer | php
RUN cd /usr/src && mv composer.phar /usr/bin/composer

# # --- INÍCIO DA ADIÇÃO PARA DRUSH ---
# # Instala o Drush globalmente via Composer
# RUN composer global require drush/drush
# RUN ln -s /root/.config/composer/vendor/bin/drush /usr/local/bin/drush

# Adiciona o diretório do Drush ao PATH do container
ENV PATH="/root/.config/composer/vendor/bin:$PATH"
# --- FIM DA ADIÇÃO PARA DRUSH ---


# Custom Opcache
RUN ( \
  echo "opcache.memory_consumption=128"; \
  echo "opcache.interned_strings_buffer=8"; \
  echo "opcache.max_accelerated_files=20000"; \
  echo "opcache.revalidate_freq=5"; \
  echo "opcache.fast_shutdown=1"; \
  echo "opcache.enable_cli=1"; \
  ) >> /usr/local/etc/php/conf.d/docker-php-ext-opcache.ini

# Copia o arquivo de configuração do Apache para o contêiner
COPY ./apache-config.conf /etc/apache2/sites-available/000-default.conf

# Copy init-drupal.sh script into the container
COPY ./init-drupal.sh /var/www/html/
RUN cd /var/www/html && chmod +x ./init-drupal.sh

# Ativa o módulo de reescrita do Apache
RUN a2enmod rewrite

# Install Xdebug
RUN pecl install xdebug \
    && docker-php-ext-enable xdebug

# Define a variável de ambiente para o uso do Xdebug
RUN ( \
    echo "xdebug.mode=debug"; \
    echo "xdebug.client_host=host.docker.internal"; \
    echo "xdebug.start_with_request=yes"; \
) >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

# Adiciona alias para o Drush no .bashrc do root
RUN echo "alias drush='./vendor/bin/drush'" >> ~/.bashrc