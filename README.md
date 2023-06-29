
# MongoDB tutorial

Based on [MongoDB Manual](https://www.mongodb.com/docs/manual/).

## Installation with Vagrant

**MongoDB 6.0 Community Edition** installation
on **Ubuntu 22** is implemented in script
[provision/provision.sh](provision/provision.sh)
in function `install_mongodb()`. Please use Vagrant
to start virtual machine with installed MongoDB instance:

```
cd vagrant/
vagrant up
```

You will get running virtual machine with IP address
specified in [vagrant/Vagrantfile](vagrant/Vagrantfile).
Login to the Ubuntu's shell:

```
vagrant ssh
```

Open shell:

```
mongosh
```

Validate:

```
db.runCommand(
   {
      hello: 1
   }
)
```

## Installation with Docker

Pull the image:

```
docker pull mongodb/mongodb-community-server
```

Run image as container:

```
docker run --name mongo -d mongodb/mongodb-community-server:latest
```

Check if it's running:

```
docker container ls
```

Open shell:

```
docker exec -it mongo mongosh
```

Validate:

```
db.runCommand(
   {
      hello: 1
   }
)
```

## Installed instance

The most important details about running instance of MongoDB:

- Linux user: `mongodb`
- Data directory: `/var/lib/mongodb`
- Logs directory: `/var/log/mongodb`
- Config file: `/etc/mongod.conf`
- Process name: `mongod`
- Default port: `27017`
- CLI client: `mongosh` *[[documentation](https://www.mongodb.com/docs/mongodb-shell/)]*

Check your built-in init system:

```
ps --no-headers -o comm 1
```

Result may be one of them:

- `systemd` - **systemd** `systemctl`
- `init` - **System V Init** `service`

Commands for **systemd** without description:

```
sudo systemctl start mongod
sudo systemctl status mongod
sudo systemctl enable mongod
sudo systemctl stop mongod
sudo systemctl restart mongod
```

In case of `Failed to start mongod.service: Unit mongod.service not found` do:

```
sudo systemctl daemon-reload
```

Commands for **System V Init** without description:

```
sudo service mongod start
sudo service mongod status
sudo service mongod stop
sudo service mongod restart
```

Track logs:

```
sudo tail -f /var/log/mongodb/mongod.log
```

## IP binding

Exposing the service to your host machine can be done
by changing option [bindIp](https://www.mongodb.com/docs/manual/reference/configuration-options/#mongodb-setting-net.bindIp)
in your config file `/etc/mongod.conf`:

```
# network interfaces
net:
  port: 27017
  bindIp: 0.0.0.0
```

where:

- `127.0.0.1` is set by default after installation
- `0.0.0.0` (all IPv4 addresses) is set by [provision/provision.sh](provision/provision.sh) script

Later restart is required. **There is no authentication by default.**

## Executables

Metapackage `mongodb-org` delivers following components:

- [mongod](https://www.mongodb.com/docs/manual/reference/program/mongod/#mongodb-binary-bin.mongod) - database daemon
- [mongos](https://www.mongodb.com/docs/manual/reference/program/mongos/#mongodb-binary-bin.mongos) - daemon interface between the client and the sharded cluster
- [mongosh](https://www.mongodb.com/docs/mongodb-shell/#mongodb-binary-bin.mongosh) - MongoDB Shell
- [mongodump](https://www.mongodb.com/docs/database-tools/mongodump/#mongodb-binary-bin.mongodump) - creates binary export of a database's contents
- [mongorestore](https://www.mongodb.com/docs/database-tools/mongorestore/#mongodb-binary-bin.mongorestore) - opposite to `mongodump`
- [bsondump](https://www.mongodb.com/docs/database-tools/bsondump/#mongodb-binary-bin.bsondump) - converts BSON files into human-readable formats
- [mongoimport](https://www.mongodb.com/docs/database-tools/mongoimport/#mongodb-binary-bin.mongoimport) - imports the content created by `mongoexport`
- [mongoexport](https://www.mongodb.com/docs/database-tools/mongoexport/#mongodb-binary-bin.mongoexport) - creates JSON or CSV from data in MongoDB
- [mongostat](https://www.mongodb.com/docs/database-tools/mongostat/#mongodb-binary-bin.mongostat) - quick overview for `mongod` or `mongos`
- [mongotop](https://www.mongodb.com/docs/database-tools/mongotop/#mongodb-binary-bin.mongotop) - tracks amount of time for reading and writing data
- [mongofiles](https://www.mongodb.com/docs/database-tools/mongofiles/#mongodb-binary-bin.mongofiles) - manipulates files stored in [GridFS](https://www.mongodb.com/docs/manual/core/gridfs/) objects for storing big files exceeding the BSON-document size limit of 16MB 

## Removing MongoDB

```
sudo service mongod stop
sudo apt-get purge mongodb-org*
sudo rm -r /var/log/mongodb
sudo rm -r /var/lib/mongodb
```
