# Zaker AI

Zaker AI هو مشروع MVP عربي يهدف إلى محاكاة تجربة NotebookLM على الهاتف، مع دعم:

- رفع المستندات (PDF/Text/Markdown)
- تلخيص ذكي عربي
- أسئلة وأجوبة من داخل الملف
- محادثة مع المستندات
- حفظ المشاريع
- واجهة موبايل عربية

## البنية

- `backend/` : خدمة API بالبايثون (FastAPI)
- `mobile/` : تطبيق Flutter لإنشاء APK
- `README.md` : هذا الملف

## المميزات الأساسية في هذا الإصدار

- إنشاء مشروع جديد
- رفع ملف نصي أو Markdown
- استخراج نص بسيط من الملف
- تلخيص المحتوى
- سؤال/جواب من النص
- واجهة موبايل جاهزة للإضافة

## المتطلبات

### Backend

- Python 3.11+
- pip

### Mobile

- Flutter SDK
- Android Studio / Xcode

## التشغيل السريع

### 1) تشغيل الـ Backend

```bash
cd backend
python -m venv .venv
source .venv/bin/activate  # أو .venv\Scripts\activate في Windows
pip install -r requirements.txt
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

### 2) تشغيل الـ Mobile

```bash
cd mobile
flutter pub get
flutter run
```

## المتغيرات البيئية

أنشئ ملف `.env` داخل مجلد `backend` مستنداً إلى `backend/.env.example`:

```env
OPENAI_API_KEY=your_api_key_here
GEMINI_API_KEY=your_gemini_key_here
APP_ENV=development
```

> ملاحظة: في هذا الإصدار الأساسي، إذا لم يتم تعيين مفتاح AI فسيُرجع النظام ردوداً تجريبية (mock) حتى يتم ربط النموذج الفعلي لاحقاً.

## مسار API

- Health: `GET /api/health`
- List projects: `GET /api/projects`
- Create project: `POST /api/projects`
- Upload file: `POST /api/upload`
- Ask document: `POST /api/ask`

## الإصدارات القادمة

- دعم PDF parsing حقيقي
- OCR للصور
- ربط Gemini/OpenAI
- بحث ذكي داخل الملفات
- تحويل النص إلى audio
- اشتراكات ومنصة Premium
- دعم PDF/Word/PowerPoint

## فريق التطوير

- المشروع في طور البناء الأولي كـ MVP
- مناسب كقاعدة قوية لتوسيع المشروع إلى نسخة كاملة مشابهة لـ NotebookLM

## ملاحظة مهمة

هذا المشروع هو نقطة انطلاق للمشروع الحقيقي. لا يزال يحتاج إلى:

- ربط API فعلي بالذكاء الاصطناعي
- تحسين استخراج المحتوى من PDF
- إضافة نظام auth
- تحسين تجربة المستخدم على الهاتف

## الخطة التالية

سنستمر في بناء:

1. Backend أقوى
2. Mobile UI عربي
3. ربط AI
4. دعم الملفات
5. APK جاهز

