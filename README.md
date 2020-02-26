# bioinfo

bioinfo is a [Docker](https://www.docker.com/) container for bioinformatics tools. The list of the installed tools and packages can be found [here](Tools.md)

## Installation

### Building from `Dockerfile`
`git clone https://github.com/ahmedmoustafa/bioinfo.git`

`cd bioinfo/`

`sudo docker build -t bioinfo .`

`sudo docker run -it bioinfo /bin/bash`

### Pulling from Docker Hub
Step 1. Pulling the image

`docker pull cairogenes/bioinfo`

Step 2. Running the image

`sudo docker run -it cairogenes/bioinfo /bin/bash`

---
