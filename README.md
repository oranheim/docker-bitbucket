# Descoped Atlassian Bitbucket Server

## About

Bitbucket Server is a Git Repository server.

For all other aspects about configuring, using and administering bitbucket please see [The Official Bitbucket Server Documentation](https://confluence.atlassian.com/bitbucketserver/bitbucket-server-documentation-home-776639749.html).

## How to use?

The examples shown below assume you will use a MySQL database.

> Please pay attention to the IP addresses used in the examples below. The IP `192.168.1.2` refers to your host OS. The IP `172.17.0.2` refers to the MySQL database and the IP `172.17.0.3` to the newly installed Bitbucket guest OS. To figure out the IP in your guest OS you can either connect to a running instance by issuing `docker exec -it [container-name] /bin/bash` and do `ifconfig` or locate the IP from `docker inspect [container-name]`.


### Prerequisites

* MySQL 5.5 or 5.6 (please notice that Bitbucket is not compatible with MySQL 5.7)
* PostgreSQL 8.4+

> Important notice: The Postgres driver is shipped with the bitbucket distribution, whereas the MySQL driver will be downloaded when running the image.


#### Database Setup

MySQL setup (assuming that MySQL isn't installed yet):

```
$ docker run -d -p 3306:3306 --name mysql -v /var/mysql:/var/lib/mysql -e MYSQL_ROOT_PASSWORD=[db-password] mysql/mysql-server:5.6
$ mysql -h 172.17.0.2 -u root -p[db-password]
CREATE DATABASE IF NOT EXISTS bitbucket CHARACTER SET utf8 COLLATE utf8_bin;
```

If you use a default Docker installation with no images installed, the assigned IP for MySQL will be: `172.17.0.2`.

Optionally you may configure security constraints by:

```
GRANT ALL PRIVILEGES ON bitbucket.* TO '[appuser]'@'172.17.0.3' IDENTIFIED BY '[apppassword]' with grant option;
```

> Please notice that the `[appuser]` and `[apppassword]` must be configured to what is appropriate for your system.


### Installation

Run docker using port 7990 on your host (if available):

```
docker run -p 7990:7990 descoped/bitbucket
```


Run with data outside the container using a volume:

```
$ docker run --name bitbucket -v /var/bitbucket:/var/atlassian-home -e CONTEXT_PATH=ROOT -e DATABASE_URL=mysql://[username]:[password]@172.17.0.2/bitbucket -p 7990:7990 -p 7999:7999 descoped/bitbucket
```


To stop the running instance:

```
$ docker bitbucket stop
```


To start running instance:

```
$ docker bitbucket start
```


#### Docker Volume

The mappable VOLUME is: `/var/atlassian-home`

#### Browser URL:

```
http://192.168.1.2:7990/
```


The host IP is assumed to be `192.168.1.2`.


### Configuration

#### Database connection

The connection to the database can be specified with an URL of the format:
```
[database type]://[username]:[password]@[host]:[port]/[database name]
```


Where ```database type``` is either ```mysql``` or ```postgresql``` and the full URL look like this:

**MySQL:**

```
mysql://<username>:<password>@172.17.0.2/bitbucket
```


**PostgreSQL:**

```
postgresql://<username>:<password>@172.17.0.2/bitbucket
```


### Environement variables

Configuration options are set by setting environment variables when running the image. What follows it a table of the supported variables:

Variable     | Function
-------------|------------------------------
CONTEXT_PATH | Context path of the Bitbucket webapp. You can set this to add a path prefix to the url used to access the webapp. i.e. setting this to ```bitbucket``` will change the url to http://192.168.1.2:7990/bitbucket/. The value ```ROOT``` is reserved to mean that you don't want a context path prefix. Defaults to ```ROOT```
DATABASE_URL | Connection URL specifying where and how to connect to a database dedicated to Bitbucket. This variable is optional and if specified will cause the Bitbucket setup wizard to skip the database setup set.


## Source code

If you want to contribute to this project or make use of the source code; you'll find it on [GitHub](https://github.com/descoped/docker-bitbucket).

### Building the image

```
docker build -t descoped/bitbucket .
```


### Further reading

* Reference to [base image](https://hub.docker.com/r/descoped/atlassian-base/)
