FROM php:7.4
MAINTAINER Dimitry "<gnomon@protonmail.com>"

# Baseline Laravel stuff
RUN apt-get update -y && apt-get install -y openssl zip unzip git libonig-dev
RUN curl -sS https://getcomposer.org/installer | \
    php -- --install-dir=/usr/local/bin --filename=composer

# The smartest thing to happen to PHP since "rm -rf php*"
RUN docker-php-ext-install pdo mbstring

# LDAP layer
RUN apt-get install -y libldap2-dev && \
    docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ && \
    docker-php-ext-install ldap

# Reinstalling PHP requirements
#  (like having to retake a test because your prof lost your paper)
RUN docker-php-ext-install tokenizer
RUN apt-get install -y libxml2-dev && \
    docker-php-ext-install xml
# Verbosity:  it's not just for your barista with a literature PhD
RUN php -m

# Copy the app to the /app directory
WORKDIR /app
COPY security-employee-tracker/ /app

## Uncomment if you need phpenv for some GUI CI/CD crap.
# COPY phpenv /phpenv

# Sqlite.  Really.  <sigh>
# This will change in my coming fork.
RUN touch storage/database.sqlite && \
    php artisan migrate --force -vvv

# Super-verbose because adding artisan and composer on top of PHP did nothing
#  to make PHP suck less.  Laravel is just more PHP arcana for the initiated.
RUN composer install -vvv

CMD php artisan serve --host=0.0.0.0 --port=8181 -vvv
EXPOSE 8181

