# docker-stagit
Stagit, containerized.

This only handles the web part. To be able to clone you will need to use something like [git-http-backend](https://git-scm.com/docs/git-http-backend).

## Features

- [x] filter out repos that contain a `.private` file in their root
- [x] automatically rebuild when a repo is changed
- [ ] gracefully stopping

## Usage

[example](example/)

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

