# stagit-docker
Stagit, containerized

## Usage

You will find a basic example in the `example` repository.

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



