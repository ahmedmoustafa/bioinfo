# bioinfo

`bioinfo` is a [Docker](https://www.docker.com/) container for bioinformatics tools.

The list of the installed tools and packages can be found [here](Tools.md)

## Installation

### Option 1: Building from `Dockerfile`
`git clone https://github.com/ahmedmoustafa/bioinfo.git`

`cd bioinfo/`

`sudo docker build -t bioinfo .`

`sudo docker run -it bioinfo /bin/bash`

### Option 2: Pulling from Docker Hub
`docker pull cairogenes/bioinfo`

`sudo docker run -it cairogenes/bioinfo /bin/bash`

---
