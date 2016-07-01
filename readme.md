# Dumper: 

Download 30GB of postgres backup from heroku with ease!

A super fast, heroku postgres dump downloader that supports pause and continue.
Automatically regenerates new dump links and resumes download automatically.

# Dependencies

Dumper is just a bash script that expects the [heroku-toolbelt](https://toolbelt.heroku.com/) and [aria2](https://aria2.github.io/) to be available on your path.

# Setup

Open dumper.sh and add the desired download location, and heroku app name:

```
DOWNLOAD_LOCATION="/path/to/dump"
APP_NAME="heroku_app_name"
```

# Usage

Download the latest dump:

```
sh dumper.sh
```

![download dump gif](.assets/dumper_start.gif?raw=true "Download dump")

In case the download is interrupted, you can continue the download by:

```
sh dumper.sh
```

![download dump gif](.assets/dumper_restart.gif?raw=true "Continue Download")

```
sh dumper.sh
```


Download a specific dump:

```
sh dumper.sh a335
```


# Todo

- pass download path and app_name as argument or flag (or in any other way that doesn't evolve editing the script)
