# Use a imagem base do Ubuntu
FROM ubuntu:latest


# Atualize os repositórios de pacotes e instale os pacotes necessários
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    unzip \
    vim \
    gnupg \
    software-properties-common

# Instalar o AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" && \
    unzip awscliv2.zip && \
    ./aws/install && \
    rm -rf awscliv2.zip aws

# Adicionar o repositório HashiCorp para instalar o Terraform
RUN curl -fsSL https://apt.releases.hashicorp.com/gpg | apt-key add - && \
    apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" && \
    apt-get update && \
    apt-get install -y terraform

# Limpar o cache do apt-get para reduzir o tamanho da imagem
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN mkdir /iac
VOLUME /iac

# Comando padrão ao iniciar o contêiner
CMD ["/bin/bash"]
