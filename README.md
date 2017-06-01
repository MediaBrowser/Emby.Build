# Emby-Server
![Alt text](http://i.imgur.com/MHQCm40.png "")
- [Introduction](#introduction)
  - [Supported Tags](#supported-tags)
  - [Contributing](#contributing)
  - [Issues](#issues)
- [Getting started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
    - [Docker Hub](#docker-hub)
        - [Installation as current user](#installation-as-current-user)
        - [Installation as other user](#installation-as-other-user)
    - [GitHub](#github)
    - [Initial Configuration](#initial-configuration)
- [Maintenance](#maintenance)
  - [Upgrading](#upgrading)
  - [Automatic Upgrades](#automatic-upgrades)
  - [Removal](#removal)
  - [Shell Access](#shell-access)
- [unRAID](#unraid)
  - [Installation](#unraid-installation)
  - [Automatic Upgrades](#unraid-automatic-upgrades)
- [Technical Information](#technical-information)
  - [Environment Variables](#environment-variables)
     - [Adjusting Variables](#adjusting-variables)
  - [Volumes](#volumes)
- [Manual Run and Installation](#manual-run-and-installation)
- [License](#license)
- [Donation](#donation)


# Introduction:

Emby Server is a home media server built on top of other popular open source
technologies such as Service Stack, jQuery, jQuery mobile, and Mono.

It features a REST-based API with built-in documention to facilitate client
development. We also have client libraries for our API to enable rapid
development.

This subfolder contains all necessary files to build a [Docker](https://www.docker.com/) image for [embyserver](https://github.com/mediabrowser/emby).

## Supported Tags:

#### Image - emby/embyserver
* latest - latest stable release  
* x86_64 - latest stable release for x86_64  
* armv7 - latest stable release for armv7 or armhf  
* aarch64 - latest stable release for armv8 or aarch64  
* x86_64_${VERSION} - $VERSION stable release for x86_64  
* armv7_${VERSION} - $VERSION stable release for armv7 or armhf  
* aarch64_${VERSION} - $VERSION stable release for armv8 or aarch64  

#### Image - emby/embyserver_beta
* latest - latest beta release  
* x86_64 - latest beta release for x86_64  
* armv7 - latest beta release for armv7 or armhf  
* aarch64 - latest beta release for armv8 or aarch64  
* x86_64_${VERSION} - $VERSION beta release for x86_64  
* armv7_${VERSION} - $VERSION beta release for armv7 or armhf  
* aarch64_${VERSION} - $VERSION beta release for armv8 or aarch64  

## Contributing:

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## Issues:

Before reporting your issue please try updating Docker to the latest version
and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

If the above recommendations do not help then [report your issue](../../issues/new) along with the following information:

- Output of the `docker version` and `docker info` commands
- The `docker run` command or `docker-compose.yml` used to start the image. Mask out the sensitive bits.
- Please state if you are using [Boot2Docker](http://www.boot2docker.io), [VirtualBox](https://www.virtualbox.org), etc.


# Getting started:

## Installation:

### [Docker Hub](https://hub.docker.com/r/emby/embyserver/):
It is recommended you install directly from the [Docker Hub](https://hub.docker.com/r/emby/embyserver/).

The installation process and scripts are very versatile and can be adjusted by
passing the right combination of variables and arguments to each of the
commands.

The following examples should cover most scenarios, in each, a wrapper script
will be installed on the host that should ease creation and management of the
containerized application. When executing the script it will create a container
named `embyserver`. Additionally, the script will ensure that this container gets
setup with the appropriate environment variables and volumes each time it is
executed.

#### Installation as current user:
Start the installation by issuing the following command from within a terminal:
```sh
docker run -it --rm -v /usr/local/bin:/target \
    emby/embyserver instl
```

Optionally, you can also install a systemd service file by executing:
```sh
docker run -it --rm -v /etc/systemd/system:/target  \
    emby/embyserver instl service
```

To enable the systemd service for `embyserver` execute the following:
```sh
sudo systemctl enable embyserver@${USERNAME}
```

#### Installation as other user:
In the following instructions adjust each command replacing `username` with the
name of the user you wish to install and run the container as.

To install the application execute and, again, adjust the command replacing
`username` accordingly.
```sh
docker run -it --rm -v /usr/local/bin:/target \
    -e "APP_USER=username" \
    emby/embyserver instl
```

Note, if the user is a system account, the command will need further
adjustment. This is because by default the script stores settings and
configuration in a hidden folder within the executing user's home directory.
This can be overridden by passing the appropriate environment variable
(`APP_CONFIG`) to the `instl` script, such as in the example below:
```sh
docker run -it --rm -v /usr/local/bin:/target \
    -e "APP_USER=username" \
    -e "APP_CONFIG=/var/lib/embyserver" \
    emby/embyserver instl
```

Optionally, proceed to installing the systemd service:
```sh
docker run -it --rm -v /etc/systemd/system:/target \
   emby/embyserver instl service
```

Additionally, you can enable the service on boot by executing:
```sh
sudo systemctl enable embyserver@username.service
```

### [GitHub](https://github.com/MediaBrowser/Emby.Build):
Installation from GitHub is recommended only for the purposes of
troubleshooting and development. To install from GitHub execute the
following:
```sh
git clone https://github.com/MediaBrowser/Emby.Build
cd docker-containers/stable
make instl
```

Additionally, you can install the systemd service file after executing the
above by issuing the following:
```sh
make service
```

### Initial Configuration:

Once the embyserver wrapper script for docker has been installed you just need to
execute the wrapper script from within a terminal:
```sh
emby-server
```
On the first run the wrapper script will prompt for system paths that
you wish made accessible from within the container. Enter one path per line.

#### Adding more volumes after first run:
Volumes which should be mounted within the container at runtime are kept in the
volume configuration file found under the `APP_CONFIG` folder on the host. The
location will vary depending on the type of installation.

If the wrapper script was installed as the executing user the volume
configuration file can be found at:
`${HOME}/.embyserver/.embyserver.volumes`
Otherwise at:
`${APP_CONFIG}/.embyserver.volumes`

# Maintenance:

## Upgrading:

You can upgrade the version of embyserver found within the container by executing
one of the following commands:
```sh
emby-server update
```

Or by executing:
```sh
docker exec emby-server update
```

You can update the container itself by executing:
```sh
docker pull emby/embyserver
docker stop emby-server
emby-server
```

If you wish the docker container to automatically update upon creation, set the
environment variable `EDGE` to `1`. Please read the `Technical Details` section
for the various ways this can be achieved.

## Automatic Upgrades:

In order to have the container periodically check and upgrade the embyserver binary
one needs to add  a [`crontab`](https://en.wikipedia.org/wiki/Cron) entry. Like
so:
```
echo "0 2 * * * docker exec emby-server update" | sudo tee -a /var/spool/cron/crontabs/root
```
or
```
echo "0 2 * * * emby-server update" | sudo tee -a /var/spool/cron/crontabs/root
```
## Removal:

```bash
docker run -it --rm \
  --volume /usr/local/bin:/target \
  emby/embyserver uninstl
```

## Shell Access:

For debugging and maintenance purposes you may want access the containers
shell. If you are using Docker version `1.3.0` or higher you can access
a running containers shell by starting `bash` using `docker exec`:

```sh
emby-server console
```

## Logs:
```sh
emby-server logs
```

## Status of service within container:
```sh
emby-server status
```


# unRAID:

You can find the template for this container on GitHub. Located [here](https://github.com/hurricanehrndz/container-templates/tree/master/unraid-templates/emby).

## unRAID Installation:

Please navigate to the Docker settings page on unRAID's Web-UI and under repositories add:
```
https://github.com/MediaBrowser/Emby.Build/tree/master/unraid-templates/emby
```
For more information on adding templates to unRAID please visit the [unRAID forums](https://lime-technology.com/forum/).

## unRAID Automatic Upgrades:

On unRAID, execute the following to have the container periodically update
itself. Additionally, add the same line of code to your `go` file to make the
change persistent.
```sh
echo "0 2 * * * docker exec emby-server update" | sudo tee -a /var/spool/cron/crontabs/root
```


# Technical information:

By default the containerized application has been set to run with UID and GID
`1000`. If using the automatic install method from Docker, the container is set
to run with the UID and GID of of the user executing the `embyserver` wrapper
script.  Additionally, the wrapper script saves embyserver's configuration and
settings in a hidden sub folder in the executing user's home directory. Most
default settings can be adjusted by passing the appropriate environment
variable. Here is a list of any and all applicable environment variables that
can be override by the end user.

## Environment Variables:

You can adjust some of the default settings set for container/application by
passing any or all of the following environment variable:  

| ENV VAR      | Definition                                                                     |
| ------------ | ------------------------------------------------------------------------------ |
| APP_USER     | Name of user the service will run as.\[4\]                                     |
| APP_UID      | UID assigned to APP_USER upon creation, or will query APP_USER's ID.\[3\]      |
| APP_GID      | GID assigned to APP_USER upon creation, or will query APP_USER's GID.\[3\]     |
| APP_CONFIG   | Location where application will store settings and database on host.\[1\]      |
| APP_GCONFIG  | Location where application will store settings and database within guest.\[4\] |
| UMASK        | umask assigned to service, default set to 002.\[4\]                            |
| EDGE         | Update the containerized service, default set to 0(Off).\[4\]                  |

\[1\]: Variable is applicable only during install.  
\[2\]: Variable is applicable during install, when invoking installed wrapper script or systemd service.  
\[3\]: Variable is applicable only when invoking docker run directly.  
\[4\]: Variable is applicable in all scenarios.  

### Adjusting Variables:

In order to pass any of the applicable variables during install or when
invoking `docker run` directly  please read Docker's documentation on [environment variables](https://docs.docker.com/engine/reference/run/#env-environment-variables) for clarification if the following examples are not clear.

In the following examples will use the environment variable `EDGE`. `EDGE` has
been chosen since it is applicable during all scenarios.

To pass the `EDGE` variable will invoking `docker run` append the following
prior to the image name. Any and all other applicable variables can be done in
the same manner.
```sh
--env=EDGE=1
```

To pass the environment variable during the other scenarios do so like in one
of the examples below:

From the commandline when calling the wrapper script:
```
EDGE=1 emby-server
```

By adjusting the systemd service:
```ini
[Service]
Type=simple
Environment=EDGE=1
...
```

## Volumes:

* `/config`  - Folder for configuration and settings.


# Manual Run and Installation:

Of course you can always run the docker image manually. Please be aware that if
you wish your data to remain persistent you need to provide a location for the
`/config` volume. For example,
```
docker run -d --net=host -v /*your_config_location*:/config \
                         -e TZ=America/Edmonton
                         --name=emby-server emby/embyserver
```
All the information mention previously regarding user UID and GID still applies
when executing a docker run command.


# License:

Code released under the [MIT license](./LICENSE).


# Donation:

[@hurricanehrndz](https://github.com/hurricanehrndz): [![PayPal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=74S5RK533DD6C)
