# bioinfo
---

bioinfo is a [Docker](https://www.docker.com/) container for bioinformatics tools.

## Installation

### Building from the `Dockerfile`
`git clone https://github.com/ahmedmoustafa/bioinfo.git`
`cd bioinfo/`
`sudo docker build -t bioinfo .`
`sudo docker run -it bioinfo /bin/bash`

### Through Docker Hub
Step 1. Pulling the image
`docker pull cairogenes/bioinfo`

Step 2. Running the image
`sudo docker run -it cairogenes/bioinfo /bin/bash`

---
