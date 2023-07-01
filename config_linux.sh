#!/usr/bin/bash

##*** Alterar o servidor DNS temporáriamente ***
#echo "nameserver 8.8.8.8" | sudo tee -a /etc/resolv.conf > /dev/null


echo "deb [arch=amd64,arm64,armhf] http://deb.volian.org/volian/ scar main" | sudo tee /etc/apt/sources.list.d/volian-archive-scar-unstable.list
wget -qO - https://deb.volian.org/volian/scar.key | sudo tee /etc/apt/trusted.gpg.d/volian-archive-scar-unstable.gpg > /dev/null
sudo apt update && sudo apt install nala -y

sudo nala fetch

sudo nala install chrome-gnome-shell gnome-shell-extensions gnome-tweaks ca-certificates ubuntu-restricted-extras build-essential -y

sudo nala install numlockx net-tools vim gedit gdebi git curl apache2 synapse flameshot tree gnupg lsb-release -y

## habilitar o mode de reescrita de url do apache
sudo a2enmode rewrite 
sudo service apache2 restart

sudo nala install snapd gparted preload vsftpd filezilla neofetch vlc gimp redis supervisor -y

sudo nala update 
sudo snap install wonderwall

##*** php8.2 ***
sudo apt install -y lsb-release gnupg2 ca-certificates apt-transport-https software-properties-common

sudo add-apt-repository ppa:ondrej/php
sudo nala install php8.2 libapache2-mod-php8.2 php8.2-dev php8.2-common php8.2-xml php8.2-gd php8.2-opcache php8.2-mbstring php8.2-zip php8.2-mysql php8.2-pgsql php8.2-curl php8.2-xdebug php8.2-redis unzip -y

wget https://xdebug.org/files/xdebug-3.2.1.tgz
sudo nala install autoconf automake
tar -xvzf xdebug-3.2.1.tgz
sudo rm -rf xdebug-3.2.1.tgz
cd xdebug-3.2.1
phpize
./configure
make
sudo cp -r modules/xdebug.so /usr/lib/php/20220829
echo "xdebug.mode=develop,debug" | sudo tee -a /etc/php/8.2/apache2/conf.d/20-xdebug.ini
echo "xdebug.client_port=80" | sudo tee -a /etc/php/8.2/apache2/conf.d/20-xdebug.ini
echo "xdebug.start_with_request=yes" | sudo tee -a /etc/php/8.2/apache2/conf.d/20-xdebug.ini
cd /home/$USER


##*** Composer ***
curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer
sudo touch /home/$USER/.config/composer/composer.json
sudo chown -R $USER: /home/$USER/.config/composer
sudo chmod 775 /home/$USER/.config/composer/composer.json

echo '{
	"require": {
		"php": "^8.0",
		"laravel/installer": "^4.1"
	}
}' >> /home/$USER/.config/composer/composer.json

cd /home/$USER/.config/composer/
composer install
cd ~/

##---Setar variável de ambiente do composer global---
echo 'export PATH="$PATH:$HOME/.config/composer/vendor/bin"' >> ~/.bashrc
source ~/.bashrc

##--- Atualizar versão do composer ---
#Executar esse comando dentro do diretório /home/$USER/.config/composer
#composer self-update

##*** Instalar o nodejs e o npm
sudo nala install dirmngr apt-transport-https lsb-release ca-certificates -y
curl -sL https://deb.nodesource.com/setup_18.x | sudo -E bash -

sudo nala install nodejs -y
sudo nala update 

##*** Instalação do VUE-JS ***
sudo npm install -g @vue/cli -y


##*** Instalar GRUB ***
sudo nala install grub-customizer -y

#Desinstalar
#sudo add-apt-repository ppa:danielrichter2007/grub-customizer -r -y
#sudo nala remove grub-customizer --auto-remove


##*** Link para a pasta FTP do Apache ***
sudo mkdir -m755 /var/www/html/ftp 
sudo mkdir -m755 /home/$USER/ftp 
sudo chown -R $USER: /var/www/html/ftp 
sudo chown -R $USER: /home/$USER/ftp 
sudo ln -s /var/www/html/ftp /home/$USER/ftp/public


#Acrescentar no final do arquivo /etc/vsftpd.conf
echo 'write_enable=YES' | sudo tee -a /etc/vsftpd.conf
echo 'chroot_local_user=YES' | sudo tee -a /etc/vsftpd.conf
echo 'allow_writeable_chroot=YES' | sudo tee -a /etc/vsftpd.conf
echo 'user_sub_token=$USER' | sudo tee -a /etc/vsftpd.conf
echo 'local_root=/home/$USER/ftp/public' | sudo tee -a /etc/vsftpd.conf
sudo service vsftpd restart


##***link para a pasta de projetos para o apache
mkdir -m755 /var/www/html/projetos -p
sudo chown -R $USER: /var/www/html/projetos
sudo ln -s /var/www/html/projetos /home/$USER/projetos

##*** Instalação manual do JAVA ***
#Link para download
#https://www.oracle.com/technetwork/pt/java/javase/downloads/jdk8-downloads-2133151.html

#Criar o diretório de instalação e dar permissão
sudo mkdir -m755 /usr/lib/jvm 

#Mover o arquivo para o diretório de instalação
#mv /Downloads/jdk-8u221-linux-x64.tar.gz /usr/lib/jvm

#Descompactar o arquivo
#cd /usr/lib/jvm/
#sudo tar -xzf jdk-8u251-linux-x64.tar.gz

#Registrar o Java
#sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk1.8.0_251/bin/java 10

#Verificar versão
#java -version

#Remover
#sudo update-alternatives --remove java /usr/java/jdk1.7.0_67/bin/java
#sudo update-alternatives --config java

##*** Instalar PostgreSQL ***
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
sudo nala update
sudo nala install postgresql -y


##*** Acessar pelo terminal
#sudo su postgres -c psql postgres

##*** Alterar a senha para o usuário
#ALTER USER postgres WITH PASSWORD 'postgres';

##*** Instalar o PgAdmin4 ***
sudo curl https://www.pgadmin.org/static/packages_pgadmin_org.pub | sudo apt-key add
sudo sh -c 'echo "deb https://ftp.postgresql.org/pub/pgadmin/pgadmin4/apt/$(lsb_release -cs) pgadmin4 main" > /etc/apt/sources.list.d/pgadmin4.list && apt update'
sudo nala install pgadmin4-desktop -y

##*** Montar partições NTFS na inicialização do Linux ***
#sudo blkid (mostra as partições ativas para descobrir o UUID)

#sudo gedit /etc/fstab
#Acrescentar no arquivo 
echo 'UUID=0711142DD5F4B876 /media/Arquivos ntfs-3g defaults 0 0' | sudo tee -a /etc/fstab

#Criar o diretório de montagem
sudo mkdir -m775 /media/arquivos
sudo chown -R $USER: /media/arquivos


##*** Habilitar o firewall na inicialização do sistema ***
sudo ufw enable
sudo ufw default deny incoming && sudo ufw default allow outgoing

#Permissão para as portas
sudo ufw allow 21/tcp
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 8080/tcp
sudo ufw allow 443/tcp
sudo ufw allow 8443/tcp
sudo ufw allow 9000/tcp
sudo ufw status verbose

##*** Instalar acesso seguro - servidor (ssh) ***
sudo nala install -y openssh-server
sudo systemctl enable ssh && sudo systemctl restart ssh

*** Instalar Mysql Server ***
sudo nala install mysql-server mysql-client -y

#sudo mysql -u root -p
#CREATE USER 'novousuario'@'localhost' IDENTIFIED BY 'password';
#GRANT ALL PRIVILEGES ON * . * TO 'novousuario'@'localhost';
#FLUSH PRIVILEGES;
#\q

#Permissão para usuário root entrar sem utilizar o sudo
#sudo mysql -u root -p
#ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '';
#FLUSH PRIVILEGES;
#\q 

##*** Instalar o phpmyadmin *** 
sudo nala install phpmyadmin -y

##--- config para phpmyadmin logar sem senha
#sudo vim /etc/phpmyadmin/config.inc.php


##*** Instalação do VSCode ***
sudo rm /etc/apt/preferences.d/nosnap.pref
sudo nala update
sudo snap install code --classic


## *** Instalar o Postman ***
sudo snap install postman


#*** Instalação do SQL SERVER ***
#wget -qO- https://packages.microsoft.com/keys/microsoft.asc | sudo nala-key add -
#sudo add-apt-repository "$(wget -qO- https://packages.microsoft.com/config/ubuntu/20.04/mssql-server-2019.list)"
#sudo nala update && sudo nala install mssql-server -y
#sudo /opt/mssql/bin/mssql-conf setup
#systemctl status mssql-server --no-pager

#*** Acesso por linha de comando ao SQL SERVER ***
#curl https://packages.microsoft.com/keys/microsoft.asc | sudo nala-key add -
#curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list | sudo tee /etc/apt/sources.list.d/msprod.list
#sudo nala update && sudo nala install mssql-tools unixodbc-dev -y

#*** Atualizar a versão ***
#sudo nala update && sudo nala install mssql-tools

#echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
#source ~/.bashrc

#*** Drivers sqlsrv para php
#sudo pecl install sqlsrv
#sudo pecl install pdo_sqlsrv

#echo "; priority=20" | sudo tee /etc/php/8.1/mods-available/sqlsrv.ini
#echo "extension=sqlsrv.so" | sudo tee /etc/php/8.1/mods-available/sqlsrv.ini

#echo "; priority=30" | sudo tee /etc/php/8.1/mods-available/pdo_sqlsrv.ini
#echo "extension=pdo_sqlsrv.so" | sudo tee /etc/php/8.1/mods-available/pdo_sqlsrv.ini

#sudo phpenmod sqlsrv pdo_sqlsrv
#sudo service apache2 restart

sudo nala update && sudo nala autoremove -y

