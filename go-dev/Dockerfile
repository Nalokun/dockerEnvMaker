FROM golang:latest

ARG USERNAME=developer
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    bash \
    ca-certificates \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Install code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# Create developer user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
    && useradd --uid ${USER_UID} --gid ${USER_GID} -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/${USERNAME}

# Create Go directories with correct permissions
RUN mkdir -p \
    /workspace \
    /home/${USERNAME}/go \
    /home/${USERNAME}/.config/code-server \
    && chown -R ${USERNAME}:${USERNAME} \
        /workspace \
        /home/${USERNAME}

USER ${USERNAME}

ENV GOPATH=/home/${USERNAME}/go
ENV PATH=/home/${USERNAME}/go/bin:${PATH}

WORKDIR /workspace

# Install Go language server
RUN go install golang.org/x/tools/gopls@latest

# Install Go extension
RUN code-server --install-extension golang.go

EXPOSE 8080

CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "/workspace"]

