# Use Alpine as the base image
FROM alpine:latest

# Install OpenSSH server and necessary tools
RUN apk update && apk add --no-cache openssh-server sudo

# Set build-time arguments (USER_NAME and USER_PASSWORD)
ARG USER_NAME=user
ARG USER_PASSWORD=password

# Add a new user and set the password for the user
RUN adduser -D ${USER_NAME} && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# Optionally give the new user sudo privileges (uncomment to enable)
# RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Set up SSH to allow login for the new user and disable root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN echo "AllowUsers ${USER_NAME}" >> /etc/ssh/sshd_config

# Generate SSH keys for the server
RUN ssh-keygen -A

# Create a directory for shared files and assign ownership to the user
RUN mkdir /shared-files && chown ${USER_NAME}:${USER_NAME} /shared-files

# Expose port 22 for SSH
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

