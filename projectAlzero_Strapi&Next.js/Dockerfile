FROM node:24

# تحديث النظام وتثبيت أدوات البناء
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    ca-certificates \
    python3 \
    make \
    g++ \
    && rm -rf /var/lib/apt/lists/*

# تحديث npm
RUN npm install -g npm@latest

# تثبيت code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# إنشاء المستخدم
ARG USERNAME=coder
RUN useradd -m -s /bin/bash ${USERNAME} \
    && echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

# المستخدم والمجلد
USER ${USERNAME}
WORKDIR /home/${USERNAME}/project

# البورت
EXPOSE 8080

# تشغيل code-server
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none"]

