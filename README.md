![Alt text](http://i.imgur.com/MHQCm40.png "")
## Installation:

### [Docker Hub](https://hub.docker.com/r/emby/embyserver/):
We recommend you install directly from the [Docker Hub](https://hub.docker.com/r/emby/embyserver/). Before starting the install procedure please verify the following prerequisites are fulfilled:
* ensure the user running installation command can run docker

Start the installation by issuing the following command from within a terminal:
```
docker run -it --rm -v /usr/local/bin:/target \
    emby/embyserver instl
```

Optionally, you can also install a systemd service file. Before installing the systemd service file, you might want specify which user you wish the deamon to run as, specifically if it differs from the user running the installation. You can do this by reinstalling emby with the following command:
```
docker run -it --rm -v /usr/local/bin:/target -e "APP_USER=username" \
    emby/embyserver instl
```

If the user you specify does not have a valid home directory you will probably want to specify an alternate location for emby to store its library database, like so:
```
docker run -it --rm -v /usr/local/bin:/target \
    -e "APP_USER=username" \
    -e "APP_CONFIG=/var/lib/emby" \
    emby/embyserver instl
```
Above, change the `username` to the name of the user you wish to run the daemon as, and adjust `/var/lib/emby` to wherever it is you wish to have emby store the media library database. Afterward, proceed with the service file installation:
```
docker run -it --rm -v /etc/systemd/system:/target \
   emby/embyserver instl service
```
If you installed the systemd service file, you can enable Emby server to automatically start when the system boots by executing the following command:
```
sudo systemctl enable emby-server.service
```
### [GitHub](https://github.com/MediaBrowser/Emby.Build):
Installation from GitHub is recommended only for the purposes of troubleshooting and development. To install emby from GitHub can be done as follows:
```
git clone https://github.com/MediaBrowser/Emby.Build
cd Emby.Build/docker-containers/stable
make instl
```

Additionally, you can install the systemd service file after executing the above by issuing the following:
```
make service
```
## Set up:

Once Emby has been installed you can simply execute the binary from a terminal:
```
emby-server
```

The first time you run the Emby server docker it will prompt you for the locations of your media files. Enter one location per line. This will ensure that the container gets access to the host's file system from within the containerized environment.

## Updating:
If you have installed our systemd service file, you can simply update by executing the following command:
```
systemctl restart emby-server.service
```
Additionally you can update by:
```
docker exec emby-server update
```

Or by:
```
docker pull emby/embyserver
docker stop emby-server
emby-server
```

Additionally, if you wish for your server to automatically update from within the container you can achieve this by adding a [`crontab`](https://en.wikipedia.org/wiki/Cron) entry. Like so:
```
echo "0 2 * * * docker exec emby-server update" | sudo tee -a /var/spool/cron/crontabs/root
```
On unRAID you can add the above line to your `go` file to have the container automatically update.

## unRAID:
We officially now host our own templates on GitHub. You can find them [here](https://github.com/MediaBrowser/Emby.Build/tree/master/unraid-templates/emby).

### Installtion:
Please navigate to the Docker settings page on unRAID's Web-UI and under repositories add:
```
https://github.com/MediaBrowser/Emby.Build/tree/master/unraid-templates/emby
```
For more information on adding templates to unRAID please visit the [unRAID forums](https://lime-technology.com/forum/).

## Rockstor:
We officially host our [Rock-on App](https://github.com/MediaBrowser/Emby.Build/tree/master/rockstor-plugins/embyserver.json) on GitHub.

### Installation:
Upload our json file to `/opt/rockstor/rockons-metastore/` and hit update in the Web-UI and install our brand new Rock-On!

## Technical information:
Our new image and installation process setups Emby server to run with the permissions of the user executing `emby-server`. So, Emby's data is set to save within the user's home directory under the name `.emby-server`.

You may overwrite the default settings by passing the appropriate environment variable:
* APP_USER - name of user to create within container for purposes of running emby-server, UID, GID are more important.
* APP_UID - UID assigned to APP_USER upon creation.
* APP_GID - GID assigned to APP_USER upon creation.
* APP_CONFIG - the directory which Emby should use to save metadata and configuration.

Please read Docker documentation on [environment variables](https://docs.docker.com/engine/reference/run/#env-environment-variables) for more information.

### Supported Tags and Respective Dockerfile | links:
* latest (latest/stable [Dockerfile](https://github.com/MediaBrowser/Emby.Build/blob/master/docker-containers/stable/Dockerfile))
* beta (beta [Dockerfile](https://github.com/MediaBrowser/Emby.Build/blob/master/docker-containers/beta/Dockerfile))
* dev (dev [Dockerfile](https://github.com/MediaBrowser/Emby.Build/blob/master/docker-containers/dev/Dockerfile))

### Manual setup:
Of course you can always run docker image manually. Please be aware that if you wish your data to remain persistent you need to provide a location for the `/config` volume. For example,
```
docker run -d -v /home/user/embydata:/config emby/embyserver
```
All the information from above regarding user UID and GID still applies when executing a docker run command.

## Migrating your data from an existing installation:
Before proceeding please ensure you have made a backup of your emby data (i.e. ```tar cvf embydata.tar /var/lib/emby-server```). Additionally, please verify that you are mounting your emby data as described above.

In the following example we will demonstrate how to migrate your database using the default setting that emby is deployed with. By default on Linux distributions Emby Server keeps it's data in ```/var/lib/emby-server```, while the Docker container keeps it's data in ```/config```. That being said one could migrate their database as follows:

```
docker exec -ti emby-server bash
s6-svc -d /run/s6/services/emby-server
migrate_db /config/data/library.db /var/lib/emby-server /config
s6-svc -u /run/s6/services/emby-server
exit
```
