FROM codercom/code-server:latest

USER root

RUN apt-get update && \
    apt-get install -y python3 python3-pip python3-venv git && \
    rm -rf /var/lib/apt/lists/*

RUN python3 --version && \
    pip3 --version && \
    git --version

USER coder
