FROM jenkins/jenkins:lts-jdk17

USER root

# Instalar dependencias necesarias
RUN apt-get update && apt-get install -y apt-transport-https \
  ca-certificates curl gnupg2 \
  software-properties-common

# Añadir el repositorio de Docker
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN apt-key fingerprint 0EBFCD88
RUN add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable"
RUN apt-get update && apt-get install -y docker-ce-cli
RUN apt-get update && apt-get install -y wget 
RUN apt-get update

# Instalar docker-compose
RUN curl -L "https://github.com/docker/compose/releases/download/2.27.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
    chmod +x /usr/local/bin/docker-compose

# Verificar si el grupo 'docker' existe, si no, crearlo con un GID único
RUN if ! getent group docker; then groupadd -g 1001 docker; fi

# Añadir el usuario Jenkins al grupo docker
RUN usermod -aG docker jenkins



# Cambiar al usuario jenkins
USER jenkins

# Instalar plugins de Jenkins
RUN jenkins-plugin-cli --plugins "docker-plugin workflow-aggregator credentials-binding git"

# Exponer puertos de Jenkins
EXPOSE 8080
EXPOSE 50000
