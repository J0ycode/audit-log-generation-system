"""Audit report building and export (CSV / PDF)."""

import csv
import io
import json
import sqlite3
from collections import Counter
from datetime import date, datetime, timedelta

from fpdf import FPDF

ACTIONS = ("INSERT", "UPDATE", "DELETE")


def _describe(action: str, old: dict | None, new: dict | None) -> str:
    """Turn the stored JSON snapshots into a human-readable change summary."""
    if action == "INSERT":
        return "Created: " + ", ".join(f"{k}={v}" for k, v in new.items() if k != "id")
    if action == "DELETE":
        return "Deleted: " + ", ".join(f"{k}={v}" for k, v in old.items() if k != "id")
    changed = [f"{k}: {old.get(k)} -> {v}" for k, v in new.items() if old.get(k) != v]
    return "; ".join(changed) or "No field changes"


def fetch_logs(
    conn: sqlite3.Connection,
    start_date: date,
    end_date: date,
    table: str | None = None,
    action: str | None = None,
) -> list[dict]:
    sql = "SELECT * FROM audit_log WHERE changed_at >= ? AND changed_at < ?"
    params: list = [f"{start_date} 00:00:00", f"{end_date + timedelta(days=1)} 00:00:00"]
    if table:
        sql += " AND table_name = ?"
        params.append(table)
    if action:
        sql += " AND action = ?"
        params.append(action)
    sql += " ORDER BY changed_at, id"

    records = []
    for row in conn.execute(sql, params):
        old = json.loads(row["old_data"]) if row["old_data"] else None
        new = json.loads(row["new_data"]) if row["new_data"] else None
        records.append({
            "id": row["id"],
            "timestamp": row["changed_at"],
            "table": row["table_name"],
            "record_id": row["record_id"],
            "action": row["action"],
            "user": row["changed_by"],
            "changes": _describe(row["action"], old, new),
            "old_data": old,
            "new_data": new,
        })
    return records


def build_report(conn, start_date: date, end_date: date, table=None, action=None) -> dict:
    records = fetch_logs(conn, start_date, end_date, table, action)
    by_action = Counter(r["action"] for r in records)
    return {
        "title": "Audit Log Report",
        "start_date": start_date.isoformat(),
        "end_date": end_date.isoformat(),
        "filters": {"table": table, "action": action},
        "generated_at": datetime.now().strftime("%Y-%m-%d %H:%M:%S"),
        "summary": {
            "total": len(records),
            "by_action": {a: by_action.get(a, 0) for a in ACTIONS},
            "by_table": dict(Counter(r["table"] for r in records)),
            "by_user": dict(Counter(r["user"] for r in records)),
        },
        "records": records,
    }


CSV_COLUMNS = ["#", "Date/Time", "Table", "Record ID", "Action", "User", "Changes"]


def _rows(report: dict):
    for i, r in enumerate(report["records"], start=1):
        yield [i, r["timestamp"], r["table"], r["record_id"], r["action"], r["user"], r["changes"]]


def to_csv(report: dict) -> str:
    buffer = io.StringIO()
    writer = csv.writer(buffer)
    writer.writerow([report["title"]])
    writer.writerow(["Period", f"{report['start_date']} to {report['end_date']}"])
    writer.writerow(["Generated at", report["generated_at"]])
    writer.writerow(["Total activities", report["summary"]["total"]])
    for action, count in report["summary"]["by_action"].items():
        writer.writerow([f"{action} count", count])
    writer.writerow([])
    writer.writerow(CSV_COLUMNS)
    writer.writerows(_rows(report))
    return buffer.getvalue()


def to_pdf(report: dict) -> bytes:
    pdf = FPDF(orientation="L", format="A4")
    pdf.set_auto_page_break(auto=True, margin=12)
    pdf.add_page()

    pdf.set_font("Helvetica", "B", 16)
    pdf.cell(0, 10, report["title"], new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Helvetica", "", 10)
    pdf.cell(0, 6, f"Period: {report['start_date']} to {report['end_date']}",
             new_x="LMARGIN", new_y="NEXT")
    pdf.cell(0, 6, f"Generated at: {report['generated_at']}", new_x="LMARGIN", new_y="NEXT")
    filters = {k: v for k, v in report["filters"].items() if v}
    if filters:
        text = ", ".join(f"{k}={v}" for k, v in filters.items())
        pdf.cell(0, 6, f"Filters: {text}", new_x="LMARGIN", new_y="NEXT")
    pdf.ln(3)

    summary = report["summary"]
    pdf.set_font("Helvetica", "B", 11)
    pdf.cell(0, 7, "Summary", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Helvetica", "", 9)
    with pdf.table(col_widths=(40, 25), width=65, align="LEFT", text_align="LEFT") as table:
        table.row(["Total activities", str(summary["total"])])
        for action, count in summary["by_action"].items():
            table.row([action, str(count)])
    pdf.ln(5)

    pdf.set_font("Helvetica", "B", 11)
    pdf.cell(0, 7, "Activity Details", new_x="LMARGIN", new_y="NEXT")
    pdf.set_font("Helvetica", "", 8)
    with pdf.table(col_widths=(8, 30, 18, 14, 16, 22, 140), text_align="LEFT") as table:
        table.row(CSV_COLUMNS)
        for row in _rows(report):
            table.row([str(v) for v in row])
    return bytes(pdf.output())
