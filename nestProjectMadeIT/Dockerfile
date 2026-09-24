FROM node:24-slim

# تثبيت الأدوات الأساسية
RUN apt-get update && apt-get install -y \
    curl \
    git \
    sudo \
    && rm -rf /var/lib/apt/lists/*

# تثبيت code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# تثبيت Nest CLI بشكل عام (اختياري بس مفيد)
RUN npm install -g @nestjs/cli
RUN npm install -g typescript tsx @types/node

# مجلد العمل / المشروع
WORKDIR /home/coder/project

# بورت code-server
EXPOSE 8080
# بورت NestJS
EXPOSE 3000

# شغل code-server بدون باسورد (تقدر تضيف باسورد لاحقاً)
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "none", "/home/coder/project"]
