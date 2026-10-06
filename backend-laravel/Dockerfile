FROM php:8.2-cli

# Install PDO SQLite dependencies if needed
RUN apt-get update && apt-get install -y sqlite3 libsqlite3-dev \
    && docker-php-ext-install pdo pdo_sqlite

# Set working directory
WORKDIR /var/www/html

# Copy backend files
COPY . .

# Expose port
EXPOSE 8080

# Run lightweight PHP API Server
CMD ["sh", "-c", "php -S 0.0.0.0:${PORT:-8080} -t public public/index.php"]
