# Use Alpine as the base image
FROM alpine:latest

# Install OpenSSH server, client, and necessary tools
RUN apk update && apk add --no-cache openssh-server openssh-client sudo vim nano

# Set build-time arguments (USER_NAME and USER_PASSWORD)
ARG USER_NAME=user
ARG USER_PASSWORD=password
ARG SHARED_FOLDER=/shared
ARG SCRIPTS_FOLDER=scripts
ARG DATA_FOLDER=data

# Add a new user and set the password for the user
RUN adduser -D ${USER_NAME} && echo "${USER_NAME}:${USER_PASSWORD}" | chpasswd

# Create a directory for shared files and assign ownership to the user
RUN mkdir ${SHARED_FOLDER} && chown ${USER_NAME}:${USER_NAME} ${SHARED_FOLDER}

# Create the directory for scripts
RUN mkdir -p ${SHARED_FOLDER}/${SCRIPTS_FOLDER} && chown root:root ${SHARED_FOLDER}/${SCRIPTS_FOLDER} && chmod 755 ${SHARED_FOLDER}/${SCRIPTS_FOLDER}

# Create the directory for data
RUN mkdir -p ${SHARED_FOLDER}/${DATA_FOLDER} && chown root:root ${SHARED_FOLDER}/${DATA_FOLDER} && chmod 755 ${SHARED_FOLDER}/${DATA_FOLDER}

# Create a symlink in the user's home directory pointing to the shared folder
RUN ln -s ${SHARED_FOLDER} /home/${USER_NAME}${SHARED_FOLDER}
# Optionally give the new user sudo privileges (uncomment to enable)
# RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# Allow user to execute scripts in the scripts folder with root privileges
RUN echo "${USER_NAME} ALL=(ALL) NOPASSWD: ${SHARED_FOLDER}/${SCRIPTS_FOLDER}/*" >> /etc/sudoers

# Set up SSH to allow login for the new user and disable root login
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config
RUN sed -i 's/#PasswordAuthentication yes/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN echo "AllowUsers ${USER_NAME}" >> /etc/ssh/sshd_config

# Generate SSH keys for the server
RUN ssh-keygen -A

# Expose port 22 for SSH
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

