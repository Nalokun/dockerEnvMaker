أكيد، هذا ملخص عملي لأوامر n8n وDocker وCloudflare Tunnel التي استخدمناها، مرتبًا لتتمكن من حفظه والرجوع إليه لاحقًا على جهاز Linux.

# 📌 مرجع سريع: n8n + Docker + Cloudflare Tunnel

## 1. الدخول إلى مجلد المشروع

bash
```
cd ~/Downloads/n8n
```

## 2. أوامر تشغيل وإيقاف n8n

| المهمة | الأمر |
| --- | --- |
| تشغيل n8n والنفق | `docker compose up -d` |
| إيقاف الخدمات | `docker compose stop` |
| إعادة تشغيل الخدمات | `docker compose restart` |
| عرض حالة الحاويات | `docker compose ps` |
| عرض سجلات n8n | `docker compose logs -f n8n` |
| عرض سجلات Cloudflare | `docker compose logs -f cloudflared` |
| عرض آخر 100 سطر من السجلات | `docker compose logs --tail=100 cloudflared` |

## 3. استخراج رابط Cloudflare المجاني

bash
```
docker compose logs --tail=100 cloudflared | grep trycloudflare
```

سيظهر رابط شبيه بهذا:

`https://experts-horizon-necessary-meets.trycloudflare.com`

استخدم الرابط الفعلي الذي يظهر على جهازك؛ فقد يتغير عند إنشاء نفق جديد.

## 4. إعداد Webhooks

داخل ملف `compose.yaml`، ضمن `environment` لخدمة `n8n`:

yaml
```
- N8N_WEBHOOK_URL=https://YOUR-URL.trycloudflare.com/
- N8N_PROXY_HOPS=1
```

استبدل `YOUR-URL` بالرابط الحالي، ثم طبّق الإعدادات:

bash
```
docker compose up -d n8n
```

مهم: لا تكرر متغير `N8N_WEBHOOK_URL` إذا كان موجودًا مسبقًا؛ عدّل قيمته فقط.

## 5. التأكد من عمل n8n

bash
```
docker compose ps
```

ثم:

bash
```
curl -I http://localhost:5678
```

إذا أردت عرض سجلات n8n الأخيرة:

bash
```
docker compose logs --tail=50 n8n
```

## 6. اختبار Webhook باستخدام curl

أنشئ عقدة Webhook في n8n بهذه الإعدادات:

- Method: `POST`
- Path: `test-api`
- اضغط `Listen for Test Event`.

ثم نفّذ:

bash
```
curl -X POST \
  'https://YOUR-URL.trycloudflare.com/webhook-test/test-api' \
  -H 'Content-Type: application/json' \
  -d '{"message":"Hello n8n"}'
```

استبدل `YOUR-URL` بالرابط الفعلي. بعد نجاح الاختبار، فعّل الـ Workflow واستخدم مسار الإنتاج `/webhook/` بدلًا من `/webhook-test/`.

## 7. ماذا أفعل عندما أعود إلى الجهاز لاحقًا؟

الخطوة 1: تشغيل المشروع

bash
```
cd ~/Downloads/n8n
docker compose up -d
```

الخطوة 2: استخراج الرابط

bash
```
docker compose logs --tail=100 cloudflared | grep trycloudflare
```

الخطوة 3: التأكد من إعداد الرابط

قارن الرابط الحالي بقيمة `N8N_WEBHOOK_URL` في `compose.yaml`. إذا اختلفا، حدّث القيمة ثم نفّذ:

bash
```
docker compose up -d n8n
```

## 8. أوامر يجب الحذر منها

- لا تستخدم `docker compose down -v`؛ فقد يحذف بيانات n8n المخزنة في وحدات التخزين التابعة للمشروع.
- لا تحذف Volume الخاص بـ n8n، لأنه قد يحتوي على Workflows وبيانات اعتماد ومفتاح التشفير.
- لا تفترض أن رابط Cloudflare القديم ما زال يعمل؛ تحقق منه بعد إعادة تشغيل النفق.
- لا تشارك بيانات الاعتماد أو روابط Webhook السرية مع الآخرين.

## 9. احفظ هذا المرجع على جهازك

يمكنك إنشاء ملف نصي يحتوي على الأوامر الأساسية:

bash
```
cat > ~/n8n-commands.txt <<'EOF'
# n8n + Docker + Cloudflare Quick Tunnel

cd ~/Downloads/n8n

# تشغيل الخدمات
docker compose up -d

# حالة الحاويات
docker compose ps

# استخراج رابط Cloudflare
docker compose logs --tail=100 cloudflared | grep trycloudflare

# سجلات n8n
docker compose logs --tail=50 n8n

# سجلات Cloudflare
docker compose logs --tail=100 cloudflared

# فحص n8n محليًا
curl -I http://localhost:5678

# إعادة تشغيل n8n بعد تعديل compose.yaml
docker compose up -d n8n
EOF
```

لعرض المرجع في أي وقت:

bash
```
cat ~/n8n-commands.txt
```

بهذا أصبح لديك ملف مرجعي دائم على جهازك. وتذكّر أن Quick Tunnel مجاني ومناسب للتجربة، لكنه لا يضمن رابطًا ثابتًا أو تشغيلًا مستمرًا.
