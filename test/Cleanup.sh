#!/bin/bash

# ==========================================================
# سكربت تنظيف بيئة تطوير NestJS (Docker + code-server)
# ==========================================================

set -e

IMAGE_NAME="nestjs-dev"   # عدّل الاسم إذا سميت الصورة باسم مختلف
PROJECT_DIR="./project"

echo "==> إيقاف وحذف الكونتينرات والشبكات (docker compose down)..."
docker compose down -v 2>/dev/null || echo "   (لا يوجد docker-compose شغال هون أو تم إيقافه مسبقاً)"

echo ""
echo "==> البحث عن الصورة: $IMAGE_NAME"
if docker images -q "$IMAGE_NAME" | grep -q .; then
    docker rmi "$IMAGE_NAME"
    echo "   تم حذف الصورة."
else
    echo "   لا توجد صورة بهذا الاسم."
fi

echo ""
read -p "هل تريد حذف مجلد المشروع ($PROJECT_DIR) نهائياً؟ (y/N): " confirm_dir
if [[ "$confirm_dir" == "y" || "$confirm_dir" == "Y" ]]; then
    if [ -d "$PROJECT_DIR" ]; then
        rm -rf "$PROJECT_DIR"
        echo "   تم حذف $PROJECT_DIR."
    else
        echo "   المجلد غير موجود أصلاً."
    fi
else
    echo "   تم تجاهل حذف المجلد."
fi

echo ""
read -p "هل تريد تنظيف شامل لكل موارد Docker غير المستخدمة على الجهاز (system prune)؟ ⚠️ يؤثر على كل مشاريعك (y/N): " confirm_prune
if [[ "$confirm_prune" == "y" || "$confirm_prune" == "Y" ]]; then
    docker system prune -a --volumes -f
    echo "   تم التنظيف الشامل."
else
    echo "   تم تجاهل التنظيف الشامل."
fi

echo ""
echo "==> الوضع الحالي بعد التنظيف:"
echo "--- Containers ---"
docker ps -a
echo "--- Images ---"
docker images
echo "--- Volumes ---"
docker volume ls

echo ""
echo "✅ انتهى التنظيف."
