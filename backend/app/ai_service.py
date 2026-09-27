# This file is intentionally left simple for this MVP.
# In production, add OpenAI/Gemini requests here.

from typing import Optional


def build_mock_summary(text: str, max_length: int = 300) -> str:
    if not text.strip():
        return "لا يوجد نص لتحليلِه حتى الآن."

    preview = text.strip()
    if len(preview) > max_length:
        preview = preview[:max_length] + "..."

    return (
        "ملخص تجريبي: هذا النص يتحدث عن فكرة رئيسية مع تفاصيل داعمة. "
        "في النسخة الكاملة، سيتم تحليل كل فقرة وتلخيصها بشكل ذكي وموجز.\n\n"
        f"المحتوى المختصر: {preview}"
    )


def build_answer_from_text(question: str, text: str) -> str:
    if not text.strip():
        return "لا توجد بيانات داخل الملف حتى الآن."

    return (
        f"السؤال: {question}\n\n"
        "الإجابة التجريبية: هذا الملف يحتوي على فكرة رئيسية ومعلومات داعمة، "
        "ويحتاج إلى ربط خدمة الذكاء الاصطناعي الفعلية للحصول على إجابة دقيقة ومفصلة."
    )
