# stagit-docker
Stagit, containerized.

This only handles the web part. To be able to clone you will need another tool which has read and write access to the repos directory (I'll make my own dockerized one soon)

## Features

- [x] filter out repos that contain a `.private` file in their root
- [ ] automatically rebuild when a repo is changed

> :warning: For now, you will have to restart the container each time you make a change to a repo. Consider this a WIP.

## Usage

You will find a basic example in the [example](example/).

TL;DR:

Create a repos directory. Put your repos in there.

The config directory is optional. It contains the files as described by the `stagit` manpage:

- `favicon.png`: favicon image.

- `logo.png`: 32x32 logo.

- `style.css`: CSS stylesheet.


```yaml
version: "3"

services:
  stagit:
    image: ghcr.io/tarneaux/stagit:latest
    restart: unless-stopped
    ports:
      - "8080:80"
    volumes:
      # The directory where your repositories are stored
      - ./repos:/repos
      - ./config:/config
    environment:
      BASEURL: http://localhost:8080
```


For more information, see the `stagit` manpage.

