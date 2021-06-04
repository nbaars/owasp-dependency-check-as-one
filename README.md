## All in one ready to go Docker based image for OWASP DependencyCheck

An all in one Docker image for OWASP DependencyCheck fully initialised with the NIST database of the today. You can use this image directly in your pipeline without having to download initialised the database needed for the CLI to run.

### Introduction

Running DependencyCheck locally on your own machine works fine, run it once it will download/initialize the cache etc and the next time you run it, it will have the cache ready and it will run pretty fast.

However when you want to use it in a CI environment things become a bit more complicated, you don't want to download the database each and every time. For one it takes time, second if you do this too often it will result in `HTTP/429 - too many requests`. There are solutions available which include a database but then you still need to set up the central database, quote from the [website](https://jeremylong.github.io/DependencyCheck/data/database.html):

> WARNING: This discusses an advanced setup and you may run into issues.

If you are already running in a CI environment running with Docker images you can also create a ready-to-go image which includes the database and includes the scanner.

This image was created based on a personal itch, setting it up in a pipeline took too much time and running a Docker image on for example a Kubernetes cluster to which the client connects feels like too much effort to me.

### Benefits

- Easy to use
- Every day there is a new image waiting to be used in your CI environment
- Scanner runs offline
- Fast
- No need to setup a database with persistent storage etc to hold the configuration
- No need to configure a central database as described [here](https://jeremylong.github.io/DependencyCheck/data/database.html).

### Updates

The Github actions for this project run every day the images will be tagged by date as follows: `yyyyMMdd` and `latest` will always point to today. The repository contains a trigger which will run each day at 0:00 UTC. 
So make sure you are fine with running OWASP dependency check with a 1 day old database at max!

### Limitations

It is a all in one image, the scanner and database are combined into one you cannot for example run the Maven plugin for OWASP DependencyCheck with this image.

The OSS Index Analyzer is enabled by default, this one is needed during the reporting phase. It will be cached with the aid of the local Maven repository. You can mount it in the Docker image to take advantage of the caching. If you only need the output of the analysis job you can pass `disableOssIndex` while running the analyzer.

## Usage

### Standalone

Use: 

```
docker pull nbaars/owasp-dependency-check-as-one:latest

docker run -v ${HOME}/.m2:/home/owasp/.m2 -v ${PWD}/demo-project:/dependency-check/demo nbaars/owasp-dependency-check-as-one:latest /dependency-check/demo/mvnw dependency:copy-dependencies && /dependency-check/bin/dependency-check.sh --scan /dependency-check/demo/
```

You can pass any command-line option you are used to pass.

If your project includes a Maven wrapper you can run:

```
docker pull nbaars/owasp-dependency-check-as-one:latest

docker run -v ${HOME}/.m2/:/home/owasp/.m2 -v ${PWD}/demo-project:/dependency-check/demo nbaars/owasp-dependency-check-as-one:latest /bin/sh -c 'cd /dependency-check/demo/; ./mvnw org.owasp:dependency-check-maven:6.1.6:aggregate -DautoUpdate=false -DdataDirectory=/dependency-check/data'
```


### Gitlab

In your pipeline use the following:

```

```

### Using this image during Docker build (multistage)

You can also use this image in your own Docker image you create to for example build your project. Copy the folder `/dependency-check` to your image. Make sure your base image does contain a JVM as Dependency Check needs it.
You can check the Dockerfile as this image uses a multistage as well.