import os
import tempfile
from datetime import date, timedelta
from pathlib import Path

import pytest

os.environ["AUDIT_DB_PATH"] = str(Path(tempfile.mkdtemp()) / "test_audit.db")

from fastapi.testclient import TestClient  # noqa: E402

from database import get_connection, set_audit_context  # noqa: E402
from main import app  # noqa: E402

TODAY = date.today()
RANGE = {"start_date": str(TODAY - timedelta(days=30)), "end_date": str(TODAY)}


@pytest.fixture(scope="module")
def client():
    with TestClient(app) as c:
        yield c


def test_health(client):
    assert client.get("/api/health").json() == {"status": "ok"}


def test_report_contains_all_action_types(client):
    report = client.get("/api/report", params=RANGE).json()
    by_action = report["summary"]["by_action"]
    assert report["summary"]["total"] == len(report["records"]) > 0
    assert all(by_action[a] > 0 for a in ("INSERT", "UPDATE", "DELETE"))


def test_filters(client):
    rows = client.get("/api/audit-logs", params={**RANGE, "table": "loans", "action": "UPDATE"}).json()
    assert rows and all(r["table"] == "loans" and r["action"] == "UPDATE" for r in rows)


def test_trigger_logs_live_change(client):
    with get_connection() as conn:
        set_audit_context(conn, "tester")
        conn.execute("UPDATE customers SET city = 'Test City' WHERE id = (SELECT MIN(id) FROM customers)")
        conn.execute("DELETE FROM audit_context")
    rows = client.get("/api/audit-logs", params={**RANGE, "table": "customers"}).json()
    last = rows[-1]
    assert last["user"] == "tester" and last["action"] == "UPDATE"
    assert "-> Test City" in last["changes"]


def test_invalid_range(client):
    res = client.get("/api/report", params={"start_date": "2026-02-10", "end_date": "2026-02-01"})
    assert res.status_code == 400


def test_download_csv_and_pdf(client):
    csv_res = client.get("/api/report/download", params={**RANGE, "format": "csv"})
    assert csv_res.status_code == 200
    assert "attachment" in csv_res.headers["content-disposition"]
    assert csv_res.text.startswith("Audit Log Report")

    pdf_res = client.get("/api/report/download", params={**RANGE, "format": "pdf"})
    assert pdf_res.status_code == 200
    assert pdf_res.content.startswith(b"%PDF")
