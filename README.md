# virtualhost
Simple creation Virtual Host

```
$ cd /usr/local/bin
$ sudo wget -O virtualhost https://raw.githubusercontent.com/vitovtnet/virtualhost/master/vh.sh
$ sudo chmod +x virtualhost
$ sudo virtualhost create test.com /home/test 
```

### Usage

```
sudo virtualhost [create | delete] [domain] [optional host_dir]
```

# Setup shell script

Will install:
- Apache
- PHP 7.1
- MySQL
- Virtualhost creator
- Composer
- Redis

### Usage

```
$ cd /usr/local/bin
$ sudo wget -O setup https://raw.githubusercontent.com/vitovtnet/virtualhost/master/setup.sh
$ sudo chmod +x setup.sh
$ sudo setup

```

