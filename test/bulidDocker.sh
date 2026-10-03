#!/bin/bash



set -e

PROJECT_DIR="./project"

echo "==> التأكد من وجود مجلد المشروع ($PROJECT_DIR)..."
mkdir -p "$PROJECT_DIR"

echo ""
echo "==> بناء الصورة (docker compose build)..."
docker compose build

echo ""
echo "==> تشغيل الكونتينر (docker compose up -d)..."
docker compose up -d
echo ""
echo "لمتابعة اللوجز مباشرة:"
echo "   docker compose logs -f"
echo ""
echo "لإيقاف التشغيل:"
echo "   docker compose down"
