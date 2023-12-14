# Use the official Ubuntu 22.04 LTS image as a parent image
FROM ubuntu:22.04

# Set the working directory in the container to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Update the system and install any packages you need
RUN apt-get update

# Make port 80 available to the world outside this container
EXPOSE 80

# Run your application when the container launches
CMD ["echo", "hello-world"]
