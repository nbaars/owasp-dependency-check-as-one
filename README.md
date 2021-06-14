## All in one ready to go Docker-based image for OWASP DependencyCheck

An all-in-one Docker image for OWASP DependencyCheck fully initialized with the NIST database of the day. You can use this image directly in your pipeline without having to download and wait for an initialized database.

### Introduction

Running DependencyCheck locally on your machine works fine, run it once it will download/initialize the cache, etc and the next time you run it, it will have the cache ready and it will run pretty fast.

However, when you want to use it in a CI environment things become a bit more complicated, you don't want to download the database each and every time. For one it takes time, second, if you do this too often it will result in `HTTP/429 - too many requests`. There are solutions available that include a database but then you still need to set up the central database, a quote from the [website](https://jeremylong.github.io/DependencyCheck/data/database.html):

> WARNING: This discusses an advanced setup and you may run into issues.

If you are already running in a CI environment running with Docker images you can also create a ready-to-go image that includes the database and includes the scanner.

This image was created based on a personal itch, setting it up in a pipeline took too much time, and running a Docker image on for example a Kubernetes cluster to which the client connects feels like too much effort to me.

### Benefits

- Easy to use
- Every day there is a new image waiting to be used in your CI environment
- No need to mount the directory which contains a copy of the database to run the Docker image it is all available in the image  
- Scanner runs offline (database is contained in the image)
- Fast (no need to wait to download the CVEs)
- No need to set up a database with persistent storage etc to hold the configuration.
- No need to configure a central database as described [here](https://jeremylong.github.io/DependencyCheck/data/database.html).

### Updates

The Github actions for this project run every day the images will be tagged by date as follows: `yyyyMMdd` and `latest` will always point to today. This repository contains a trigger that will run each day at 0:00 UTC. 
So make sure you are fine with running OWASP dependency check with a 1-day old database at max!

### Limitations

The image is at most 1 day old, if you need to update more often you cannot use this image. Make sure to discuss this upfront with your security team.

## Usage

### Standalone

Use: 

```
docker pull nbaars/owasp-dependency-check-as-one:latest

docker run -v ${HOME}/.m2:/home/owasp/.m2 -v ${PWD}/demo-project:/workspace nbaars/owasp-dependency-check-as-one:latest ./mvnw dependency:copy-dependencies && dependency-check --data /data --scan /workspace --noupdate
```

Important are the two mount points, the first one mounts the local `.m2` directory, this will prevent DependencyCheck from downloading Maven artifacts over and over. When using a CI tool it is recommended to mount the `.m2` cache. The project to be scanned is mapped in `/workspace` which is the working directory set in the Dockerfile.

You can pass any command-line option you are used to.

If your project includes a Maven wrapper you can run:

```
docker pull nbaars/owasp-dependency-check-as-one:latest

docker run -v ${HOME}/.m2/:/home/owasp/.m2 -v ${PWD}/demo-project:/workspace nbaars/owasp-dependency-check-as-one:latest ./mvnw org.owasp:dependency-check-maven:6.1.6:aggregate -DautoUpdate=false -DdataDirectory=/data
```


### Gitlab

TBD


### Github actions

If you want to use this image in Github, use the following:

```

```

### Using this image during Docker build (multistage)

You can also use this image in your own Docker image you create to for example build your project. Copy the folder `/dependency-check` to your image. Make sure your base image does contain a JVM as Dependency Check needs it.
You can check the Dockerfile as this image uses a multistage as well.