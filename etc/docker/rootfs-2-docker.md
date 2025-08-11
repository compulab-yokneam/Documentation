# Turning a root filesystem (rootfs) into a docker container

* Create a Dockerfile:<br>A Dockerfile defines the steps to build a Docker image.<br>For a rootfs, you can use a FROM scratch instruction and then ADD your rootfs content.
```
FROM scratch
ADD . / 
# Add any necessary commands to set up the environment,
# like setting the entrypoint or running initial scripts.
CMD ["/bin/bash"] # Or your desired entrypoint
```

* Build the Docker Image:<br>Navigate to the directory containing your rootfs and the Dockerfile, then build the image.
```
docker build -t your-image-name .
```

* Run the Container:<br>Once the image is built, you can run a container from it.
```
docker run --interactive --tty --privileged your-image-name
```

* Usefull information for the future use:
<br>https://developer.tenten.co/how-to-migrate-docker-container-to-another-server-in-ubuntu-2204
