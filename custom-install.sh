#!/usr/bin/env bash

set -ex

# Install PHP8.4
sudo add-apt-repository ppa:ondrej/php
sudo apt install php8.4 php8.4-cli

# Install PHP8.4 extensions
sudo apt install php8.4 php8.4-common php8.4-fpm php8.4-cli php8.4-mysql php8.4-pgsql php8.4-sqlite3 php8.4-curl php8.4-gd php8.4-mbstring php8.4-xml php8.4-zip php8.4-bcmath php8.4-intl php8.4-soap php8.4-ldap php8.4-imap php8.4-opcache php8.4-readline php8.4-xdebug php8.4-dev php8.4-enchant php8.4-gmp php8.4-imagick php8.4-memcached php8.4-redis php8.4-tidy php8.4-uuid php8.4-pspell php8.4-snmp php8.4-sybase php8.4-odbc php8.4-dba php8.4-bz2

perl -e 'do "./modify-files.pl"; php();'

# Install composer (v2.8.6) May need to be changed when a new version is released
# refer to https://getcomposer.org/download/ if that is the case
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === 'dac665fdc30fdd8ec78b38b9800061b4150413ff2e3b6f88543c636f7cd84f6db9189d43a81e5503cda447da73c7e5b6') { echo 'Installer verified'.PHP_EOL; } else { echo 'Installer corrupt'.PHP_EOL; unlink('composer-setup.php'); exit(1); }"
php composer-setup.php
php -r "unlink('composer-setup.php');"

sudo mv composer.phar /usr/local/bin/composer

# Install ddev and Docker only on native Linux and not on WSL
if uname -r | ! grep -qi "microsoft"; then

    # Install Docker-cli
    # https://docs.docker.com/engine/install/debian/#install-using-the-repository
    sudo install -m 0755 -d /etc/apt/keyrings
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
    sudo chmod a+r /etc/apt/keyrings/docker.asc

    echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt-get update

    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    
    # Install ddev
    sudo sh -c 'echo ""'
    sudo apt-get update && sudo apt-get install -y curl
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://pkg.ddev.com/apt/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/ddev.gpg > /dev/null
    sudo chmod a+r /etc/apt/keyrings/ddev.gpg
    sudo sh -c 'echo ""'
    echo "deb [signed-by=/etc/apt/keyrings/ddev.gpg] https://pkg.ddev.com/apt/ * *" | sudo tee /etc/apt/sources.list.d/ddev.list >/dev/null
    sudo sh -c 'echo ""'
    sudo apt-get update && sudo apt-get install -y ddev

    # Install trusted certificate
    mkcert -install

    # Install DBeaver
    wget https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb
    sudo dpkg -x dbeaver-ce_latest_amd64.deb dbeaver

    # Add dbeaver as ddev command
    mkdir -p ~/.ddev/commands
    touch ~/.ddev/commands/dbeaver

    echo -e '#!/bin/bash\n\ndbeaver -host db -port 3306 -user db -password db' > ~/.ddev/commands/dbeaver
    
    chmod +x ~/.ddev/commands/dbeaver
fi

# Download and install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# in lieu of restarting the shell
\. "$HOME/.nvm/nvm.sh"

# Install node & npm:
nvm install 22

# Install bun
curl -fsSL https://bun.sh/install | bash
