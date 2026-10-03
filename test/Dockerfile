FROM codercom/code-server:latest

USER root

# System packages
RUN apt-get update && \
    apt-get install -y \
        git \
        curl \
        wget \
        vim \
        nano \
        unzip \
        build-essential \
        ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# Install Node.js 22 LTS
RUN curl -fsSL https://deb.nodesource.com/setup_22.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Verify installations
RUN node --version && \
    npm --version && \
    git --version

# Create workspace
RUN mkdir -p /workspace && \
    chown -R coder:coder /workspace

USER coder

WORKDIR /workspace

EXPOSE 8080

CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "/workspace"]
