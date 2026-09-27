from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel
from typing import List, Optional
import os, uuid

app = FastAPI(title="Zaker AI API", version="0.1.0")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

projects: List[dict] = []


class ProjectCreate(BaseModel):
    name: str


class AskRequest(BaseModel):
    project_id: str
    question: str


@app.get("/api/health")
def health_check():
    return {"status": "ok", "app": "Zaker AI", "version": "0.1.0"}


@app.get("/api/projects")
def list_projects():
    return {"projects": projects}


@app.post("/api/projects")
def create_project(payload: ProjectCreate):
    if not payload.name.strip():
        raise HTTPException(status_code=400, detail="Project name is required")

    project = {
        "id": str(uuid.uuid4()),
        "name": payload.name.strip(),
        "text": "",
        "created_at": __import__("datetime").datetime.utcnow().isoformat() + "Z",
    }
    projects.append(project)
    return {"project": project}


@app.post("/api/upload")
async def upload_file(file: UploadFile = File(...), project_id: Optional[str] = None):
    if not file.filename:
        raise HTTPException(status_code=400, detail="File is required")

    safe_name = file.filename
    content = await file.read()
    text = content.decode("utf-8", errors="ignore")

    if not project_id:
        project = {
            "id": str(uuid.uuid4()),
            "name": safe_name,
            "text": text,
            "created_at": __import__("datetime").datetime.utcnow().isoformat() + "Z",
        }
        projects.append(project)
        return {"project": project, "message": "Uploaded and created project"}

    for project in projects:
        if project["id"] == project_id:
            project["text"] = text
            project["name"] = safe_name
            return {"project": project, "message": "File attached to project"}

    raise HTTPException(status_code=404, detail="Project not found")


@app.post("/api/ask")
def ask_document(payload: AskRequest):
    project = next((p for p in projects if p["id"] == payload.project_id), None)
    if not project:
        raise HTTPException(status_code=404, detail="Project not found")

    text = project.get("text", "")
    if not text.strip():
        return {
            "answer": "لا يوجد محتوى داخل هذا المشروع بعد. قم بتحميل ملف أولاً.",
            "source": "mock"
        }

    question = payload.question.strip()
    answer = (
        f"بناءً على المحتوى الموجود في المشروع '{project['name']}', "
        f"الإجابة المتوقعة على السؤال: '{question}' هي أن المحتوى يركز على الفكرة الأساسية "
        f"الموجودة في النص. إذا ربطت خدمة الذكاء الاصطناعي الفعلية، ستظهر إجابة دقيقة مستندة لهذا الملف."
    )

    return {"answer": answer, "source": "mock", "document_name": project["name"]}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run("app.main:app", host="0.0.0.0", port=8000, reload=True)
