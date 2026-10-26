FROM php:8.2-apache

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        git \
        python3 \
        python3-pip \
        unzip \
    && rm -rf /var/lib/apt/lists/*

RUN python3 -m venv /opt/demisto-venv
RUN /opt/demisto-venv/bin/pip install --no-cache-dir --upgrade pip setuptools wheel && \
    /opt/demisto-venv/bin/pip install --no-cache-dir demisto-sdk
ENV PATH="/opt/demisto-venv/bin:${PATH}"

ENV HOME=/tmp

RUN mkdir -p /tmp/.demisto-sdk && \
    chmod -R 777 /tmp/.demisto-sdk

RUN mkdir -p /var/www/.demisto-sdk && \
    chown -R www-data:www-data /var/www/.demisto-sdk

RUN chown -R www-data:www-data /var/www/html

RUN echo "max_execution_time = 600" > /usr/local/etc/php/conf.d/timeout_custom.ini && \
    echo "upload_max_filesize = 500M" >> /usr/local/etc/php/conf.d/timeout_custom.ini && \
    echo "post_max_size = 500M" >> /usr/local/etc/php/conf.d/timeout_custom.ini && \
    echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/timeout_custom.ini && \
    echo "error_reporting = E_ALL & ~E_NOTICE" >> /usr/local/etc/php/conf.d/timeout_custom.ini && \
    echo "max_input_vars = 20000" >> /usr/local/etc/php/conf.d/timeout_custom.ini
