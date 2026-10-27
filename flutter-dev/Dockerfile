FROM debian:bookworm-slim

# منع الأسئلة التفاعلية أثناء التثبيت
ENV DEBIAN_FRONTEND=noninteractive

# 1. تثبيت الحزم الأساسية وأداة ADB فقط (بدون Android Studio الكامل)
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    ca-certificates \
    sudo \
    adb \
    && rm -rf /var/lib/apt/lists/*

# 2. تثبيت code-server
RUN curl -fsSL https://code-server.dev/install.sh | sh

# 3. إنشاء مستخدم غير جذري (لتجنب مشاكل صلاحيات Flutter)
RUN useradd -m -s /bin/bash devuser && \
    echo "devuser ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER devuser
WORKDIR /home/devuser

# 4. تحميل وتثبيت Flutter (فرع stable وبعمق 1 لتقليل الحجم)
RUN git clone --depth 1 -b stable https://github.com/flutter/flutter.git /home/devuser/flutter

# إضافة Flutter و Dart إلى مسار النظام (PATH)
ENV PATH="/home/devuser/flutter/bin:/home/devuser/flutter/bin/cache/dart-sdk/bin:${PATH}"

# 5. تهيئة Flutter وتفعيل دعم الويب وتحميل أدوات Dart مسبقاً
RUN flutter config --no-analytics && \
    flutter config --enable-web && \
    flutter precache --web

# تثبيت إضافات Dart و Flutter تلقائياً داخل code-server
RUN code-server --install-extension Dart-Code.dart-code && \
    code-server --install-extension Dart-Code.flutter

# فتح منافذ code-server (8080) ومنفذ معاينة تطبيق Flutter (3000)
EXPOSE 8080 3000

# تشغيل code-server عند بدء الحاوية
CMD ["code-server", "--bind-addr", "0.0.0.0:8080", "--auth", "password", "/home/devuser"]
