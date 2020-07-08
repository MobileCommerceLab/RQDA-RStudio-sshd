# RQDA in Docker

RQDA (R Qualitative Data Analysis) installed on the `rstudio/r-base` image. Because RQDA uses GTK for its UI, the tool must be accessed via X11. This image allows you to connect to X11 using SSH X11 forwarding.

## Prerequisites

Your host system needs Docker and an X11 windowing system.
These instructions are for MacOS and Linux systems only.
It may be possible to use Windows Subsystem for Linux alongside an X11 server in Windows, but this is not officially supported.

## Setup

Configure your host to allow X11 forwarding to localhost by adding the following to `~/.ssh/config`:

```
Host localhost
  ForwardX11Trusted yes
  ForwardX11 yes
  XAuthLocation /opt/X11/bin/xauth
```

**Important:** Copy the `dot_env_example` file to `.env`, and set the permissions with `chmod 600 .env`:

```bash
cp dot_env_example .env
chmod 600 .env
```

Then, edit the `.env` file -- enter a strong password of your choice for the root account. You may also configure the address and port that the service will be bound to here.

## Usage

If you want to pull the image from Docker Hub, first run:

```
docker-compose pull
```

Next, if you're on a Mac, just double-click on the `run_RQDA.command` script. If
you're on Linux, just run the `run_RQDA.command` script from the
command-line. If you're on Windows, you'll have to start the Docker container,
then SSH with X11 forwarding.

When prompted, enter the root password that you chose earlier.

RStudio should open in X11. Next, type the following to start RQDA:

```
library(RQDA)
RQDA()
```

For usage details, see the [RQDA project page](http://rqda.r-forge.r-project.org/index.html). I recommend saving the project into `/root/rstudio`, since that directory is volume mapped.

A few useful commands:

```
help(package="RQDA")
summaryCodings()
```

## Why does this exist?

Setting up RQDA can be time consuming.
