"""Generate the sample audit report deliverable (last 30 days) as CSV and PDF."""

from datetime import date, timedelta
from pathlib import Path

from database import get_connection, init_db
from reports import build_report, to_csv, to_pdf

OUT_DIR = Path(__file__).resolve().parent.parent / "sample_report"


def main() -> None:
    init_db()
    end = date.today()
    start = end - timedelta(days=29)
    with get_connection() as conn:
        report = build_report(conn, start, end)

    OUT_DIR.mkdir(exist_ok=True)
    (OUT_DIR / "audit_report_sample.csv").write_text(to_csv(report), encoding="utf-8")
    (OUT_DIR / "audit_report_sample.pdf").write_bytes(to_pdf(report))
    print(f"Wrote {report['summary']['total']} records to {OUT_DIR}")


if __name__ == "__main__":
    main()
