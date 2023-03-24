# stagit-docker
Stagit, containerized.

This only handles the web part. To be able to clone you will need another tool which has read and write access to the repos directory (I'll make my own dockerized one soon)

## Usage

You will find a basic example in the [example](example/).

TL;DR:

```yaml
version: "3"

services:
  stagit:
    image: ghcr.io/tarneaux/stagit:latest
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

