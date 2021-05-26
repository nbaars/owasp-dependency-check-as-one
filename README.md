## All in one ready to go Docker based image for OWASP DependencyCheck

An all in one Docker image for OWASP DependencyCheck fully initialised with the NIST database of the today. You can use this image directly in your pipeline without having to download initialised the database needed for the CLI to run.

### Introduction

Running DependencyCheck locally on your own machine works fine, run it once it will download/initialize the cache etc and the next time you run it, it will have the cache ready and it will run pretty fast.

However when you want to use it in a CI environment things become a bit more complicated, you don't want to download the database each and every time. For one it takes time, second if you do this too often it will download `HTTP/429 - too many requests`. There are solutions available which include a database but then you still need to specify database connection strings while using the cli.

If you are already running in a CI environment running with Docker images you can also create a ready-to-go image which includes the database and includes the scanner.

This image was created based on a personal itch, setting it up in a pipeline took too much time and running a Docker image on for example a Kubernetes cluster to which the client connects feels like too much effort to me.

### Benefits

- Easy to use 
- Every day there is a new image waiting to be used in your CI environment
- Scanner runs offline
- Fast

### Updates

The Github actions for this project run every day the images will be tagged by date as follows: `yyyyMMdd` and `latest` will always point to today. The repository contains a trigger which will run each day at 0:00 UTC. 

### Limitations

It is a all in one image, the scanner and database are combined into one you cannot for example run the Maven plugin for OWASP DependencyCheck with this image. Please note a Maven plugin is on the road map.

## Usage

TODO: OSS-index

### Standalone

Use: 

```
docker pull nbaars/owasp-dependency-check-as-one:latest
docker run nbaars/owasp-dependency-check-as-one:latest -scan .
```

You can pass any command-line option you are used to pass.

### Gitlab

In your pipeline use the following:

```

```

### Github