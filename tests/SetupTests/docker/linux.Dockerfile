# Use the official Ubuntu 22.04 LTS image as a parent image
FROM ubuntu:22.04

# Update the system and install any packages you need
RUN apt-get update & apt-get install -y git

# Run your application when the container launches
CMD ["ls", "/antiphon"]
