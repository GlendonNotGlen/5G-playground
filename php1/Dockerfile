FROM php:7.2-fpm
# Install curl
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*
RUN mkdir /app
COPY hello.php /app
COPY test.php /app
COPY 404.php /app
COPY flag-z3ybow20r3gms3dzdykitgzuxrandomstring.php /app
