FROM php:8.3-apache

ENV DEBIAN_FRONTEND=noninteractive \
    PASSWORD=student \
    APACHE_RUN_USER=coder \
    APACHE_RUN_GROUP=coder

# أدوات النظام + إضافات PHP
RUN apt-get update && apt-get install -y --no-install-recommends \
      curl git unzip nano supervisor ca-certificates libzip-dev libsqlite3-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql pdo_sqlite zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && a2enmod rewrite \
    && rm -rf /var/lib/apt/lists/*

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/local/bin/composer

# IDE: code-server (VS Code داخل المتصفح)
RUN curl -fsSL https://code-server.dev/install.sh | sh

# المستخدم الذي يعمل عليه الطالب (UID 1000 ليتوافق مع لينكس غالبًا)
RUN useradd -m -u 1000 -s /bin/bash coder \
    && mkdir -p /home/coder/www /home/coder/.local/share/code-server \
    && chown -R coder:coder /home/coder

# إعدادات PHP و Apache
COPY php-dev.ini /usr/local/etc/php/conf.d/zz-dev.ini
RUN sed -i 's#/var/www/html#/home/coder/www#g' /etc/apache2/sites-available/000-default.conf \
    && printf '<Directory /home/coder/www>\n    Options Indexes FollowSymLinks\n    AllowOverride All\n    Require all granted\n</Directory>\nServerName localhost\n' \
       > /etc/apache2/conf-available/course.conf \
    && a2enconf course

# إضافات المحرر (من Open VSX)
USER coder
RUN for ext in bmewburn.vscode-intelephense-client xdebug.php-debug \
               esbenp.prettier-vscode formulahendry.auto-rename-tag \
               ecmel.vscode-html-css; do \
      code-server --install-extension "$ext" || true; \
    done
USER root

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY --chown=coder:coder www/ /home/coder/www/

EXPOSE 80 8080
CMD ["/usr/bin/supervisord", "-n", "-c", "/etc/supervisor/supervisord.conf"]
