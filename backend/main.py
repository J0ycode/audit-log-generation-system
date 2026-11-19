"""FastAPI backend for the Audit Log Report system.

Run:  uvicorn main:app --reload
Docs: http://localhost:8000/docs
"""

from contextlib import asynccontextmanager
from datetime import date
from typing import Literal

from fastapi import FastAPI, HTTPException, Query
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import Response

from database import AUDITED_TABLES, get_connection, init_db
from reports import build_report, fetch_logs, to_csv, to_pdf

TableName = Literal["customers", "loans", "payments"]
ActionName = Literal["INSERT", "UPDATE", "DELETE"]


@asynccontextmanager
async def lifespan(_: FastAPI):
    init_db()
    yield


app = FastAPI(title="Audit Log Report API", version="1.0.0", lifespan=lifespan)

# Open CORS so the Flutter web dashboard can call the API during the demo.
# Restrict allow_origins to the real dashboard URL before any non-local use.
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["GET"],
    allow_headers=["*"],
    expose_headers=["Content-Disposition"],
)


def _check_range(start_date: date, end_date: date) -> None:
    if start_date > end_date:
        raise HTTPException(status_code=400, detail="start_date must be on or before end_date")


@app.get("/api/health")
def health():
    return {"status": "ok"}


@app.get("/api/tables")
def list_tables():
    """Audited tables and their tracked columns."""
    return AUDITED_TABLES


@app.get("/api/audit-logs")
def get_audit_logs(
    start_date: date,
    end_date: date,
    table: TableName | None = None,
    action: ActionName | None = None,
):
    """Raw audit log records for a date range (inclusive)."""
    _check_range(start_date, end_date)
    with get_connection() as conn:
        return fetch_logs(conn, start_date, end_date, table, action)


@app.get("/api/report")
def get_report(
    start_date: date,
    end_date: date,
    table: TableName | None = None,
    action: ActionName | None = None,
):
    """Processed report: summary counts plus readable activity rows."""
    _check_range(start_date, end_date)
    with get_connection() as conn:
        return build_report(conn, start_date, end_date, table, action)


@app.get("/api/report/download")
def download_report(
    start_date: date,
    end_date: date,
    table: TableName | None = None,
    action: ActionName | None = None,
    format: Literal["csv", "pdf"] = Query("pdf"),
):
    """Download the report as a CSV or PDF file."""
    _check_range(start_date, end_date)
    with get_connection() as conn:
        report = build_report(conn, start_date, end_date, table, action)

    filename = f"audit_report_{start_date}_{end_date}.{format}"
    if format == "csv":
        content, media_type = to_csv(report).encode("utf-8"), "text/csv"
    else:
        content, media_type = to_pdf(report), "application/pdf"
    return Response(
        content=content,
        media_type=media_type,
        headers={"Content-Disposition": f'attachment; filename="{filename}"'},
    )
