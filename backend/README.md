# FastAPI Backend for Zaker AI

This folder contains the backend for the Zaker AI MVP.

## Setup

```bash
cd backend
python -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Run server

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

## Endpoints

- `GET /api/health`
- `GET /api/projects`
- `POST /api/projects`
- `POST /api/upload`
- `POST /api/ask`

