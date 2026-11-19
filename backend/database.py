"""Simulated database for the Audit Log Report system.

SQLite is used so the project runs with zero setup. Business tables
(customers, loans, payments) are audited automatically by database
triggers: every INSERT, UPDATE and DELETE writes a row to `audit_log`
with the old and new values stored as JSON.
"""

import os
import random
import sqlite3
from contextlib import contextmanager
from datetime import datetime, timedelta
from pathlib import Path

TIMESTAMP_FORMAT = "%Y-%m-%d %H:%M:%S"
DEFAULT_DB_PATH = Path(__file__).parent / "audit_demo.db"

# Audited tables and the columns captured in the audit trail.
AUDITED_TABLES = {
    "customers": ["name", "phone", "city"],
    "loans": ["customer_id", "loan_type", "amount", "interest_rate", "status"],
    "payments": ["loan_id", "amount", "paid_on"],
}

SCHEMA = """
CREATE TABLE customers (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    phone       TEXT NOT NULL,
    city        TEXT NOT NULL
);

CREATE TABLE loans (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id    INTEGER NOT NULL REFERENCES customers(id),
    loan_type      TEXT NOT NULL,
    amount         REAL NOT NULL,
    interest_rate  REAL NOT NULL,
    status         TEXT NOT NULL DEFAULT 'Pending'
);

CREATE TABLE payments (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    loan_id   INTEGER NOT NULL REFERENCES loans(id),
    amount    REAL NOT NULL,
    paid_on   TEXT NOT NULL
);

CREATE TABLE audit_log (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    table_name  TEXT NOT NULL,
    record_id   INTEGER NOT NULL,
    action      TEXT NOT NULL CHECK (action IN ('INSERT', 'UPDATE', 'DELETE')),
    old_data    TEXT,
    new_data    TEXT,
    changed_by  TEXT NOT NULL,
    changed_at  TEXT NOT NULL
);

CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);

-- Holds the "current user" and an optional fixed clock for the triggers.
-- The application sets it before each change; seeding uses it to spread
-- the sample activity over past dates.
CREATE TABLE audit_context (
    id         INTEGER PRIMARY KEY CHECK (id = 1),
    user_name  TEXT NOT NULL,
    ts         TEXT
);
"""

_USER_SQL = "COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system')"
_TS_SQL = (
    "COALESCE((SELECT ts FROM audit_context WHERE id = 1), "
    "strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime'))"
)


def _json_of(prefix: str, columns: list[str]) -> str:
    pairs = ", ".join(f"'{col}', {prefix}.{col}" for col in columns)
    return f"json_object('id', {prefix}.id, {pairs})"


def _trigger_sql(table: str, columns: list[str]) -> str:
    new_json, old_json = _json_of("NEW", columns), _json_of("OLD", columns)
    insert = (
        "INSERT INTO audit_log "
        "(table_name, record_id, action, old_data, new_data, changed_by, changed_at) "
    )
    return f"""
CREATE TRIGGER trg_{table}_insert AFTER INSERT ON {table} BEGIN
    {insert} VALUES ('{table}', NEW.id, 'INSERT', NULL, {new_json}, {_USER_SQL}, {_TS_SQL});
END;
CREATE TRIGGER trg_{table}_update AFTER UPDATE ON {table} BEGIN
    {insert} VALUES ('{table}', NEW.id, 'UPDATE', {old_json}, {new_json}, {_USER_SQL}, {_TS_SQL});
END;
CREATE TRIGGER trg_{table}_delete AFTER DELETE ON {table} BEGIN
    {insert} VALUES ('{table}', OLD.id, 'DELETE', {old_json}, NULL, {_USER_SQL}, {_TS_SQL});
END;
"""


def get_db_path() -> Path:
    return Path(os.environ.get("AUDIT_DB_PATH", DEFAULT_DB_PATH))


@contextmanager
def get_connection():
    conn = sqlite3.connect(get_db_path())
    conn.row_factory = sqlite3.Row
    try:
        yield conn
        conn.commit()
    finally:
        conn.close()


def set_audit_context(conn: sqlite3.Connection, user: str, ts: str | None = None) -> None:
    conn.execute(
        "INSERT OR REPLACE INTO audit_context (id, user_name, ts) VALUES (1, ?, ?)",
        (user, ts),
    )


def init_db(reset: bool = False) -> None:
    """Create the schema and sample data if the database does not exist yet."""
    path = get_db_path()
    if reset and path.exists():
        path.unlink()
    if path.exists():
        return
    with get_connection() as conn:
        conn.executescript(SCHEMA)
        for table, columns in AUDITED_TABLES.items():
            conn.executescript(_trigger_sql(table, columns))
        _seed(conn)
        conn.execute("DELETE FROM audit_context")


# --------------------------------------------------------------------------
# Sample data: ~30 days of realistic loan-office activity.
# --------------------------------------------------------------------------

USERS = ["admin", "ravi.kumar", "anita.menon", "suresh.pillai"]
CITIES = ["Kochi", "Thrissur", "Kozhikode", "Kollam", "Kottayam", "Palakkad"]
NAMES = [
    "Arun Nair", "Meera Joseph", "Rahul Das", "Fathima Basheer", "Joseph Mathew",
    "Lakshmi Varma", "Nikhil Raj", "Sneha Thomas", "Vivek Menon", "Divya Krishnan",
    "Abdul Rahman", "Priya George", "Sanjay Iyer", "Anjali Pillai", "Kiran Babu",
]
# Loan products and rates taken from the reference projection sheet.
LOAN_TYPES = {
    "Gold Loan": 18.0,
    "Vehicle Loan": 14.0,
    "Personal Loan": 15.0,
    "Weekly Loan": 15.0,
    "Daily Loan": 15.0,
}
NEXT_STATUS = {"Pending": "Approved", "Approved": "Disbursed", "Disbursed": "Closed"}


def _seed(conn: sqlite3.Connection) -> None:
    rng = random.Random(42)
    now = datetime.now()
    clock = (now - timedelta(days=29)).replace(hour=9, minute=0, second=0, microsecond=0)

    def tick() -> bool:
        nonlocal clock
        clock += timedelta(minutes=rng.randint(30, 300))
        if clock.hour >= 18:
            clock = (clock + timedelta(days=1)).replace(hour=9, minute=rng.randint(0, 59))
        set_audit_context(conn, rng.choice(USERS), clock.strftime(TIMESTAMP_FORMAT))
        return clock < now

    def ids(sql: str) -> list[int]:
        return [row[0] for row in conn.execute(sql)]

    def add_customer() -> bool:
        used = {row[0] for row in conn.execute("SELECT name FROM customers")}
        free = [n for n in NAMES if n not in used]
        if not free:
            return False
        conn.execute(
            "INSERT INTO customers (name, phone, city) VALUES (?, ?, ?)",
            (free[0], f"9{rng.randint(100000000, 999999999)}", rng.choice(CITIES)),
        )
        return True

    def add_loan() -> bool:
        customers = ids("SELECT id FROM customers")
        if not customers:
            return False
        loan_type = rng.choice(list(LOAN_TYPES))
        conn.execute(
            "INSERT INTO loans (customer_id, loan_type, amount, interest_rate) VALUES (?, ?, ?, ?)",
            (rng.choice(customers), loan_type, rng.randint(10, 200) * 1000, LOAN_TYPES[loan_type]),
        )
        return True

    def advance_loan() -> bool:
        rows = conn.execute("SELECT id, status FROM loans WHERE status != 'Closed'").fetchall()
        if not rows:
            return False
        loan_id, status = rng.choice(rows)
        conn.execute("UPDATE loans SET status = ? WHERE id = ?", (NEXT_STATUS[status], loan_id))
        return True

    def add_payment() -> bool:
        loans = ids("SELECT id FROM loans WHERE status = 'Disbursed'")
        if not loans:
            return False
        conn.execute(
            "INSERT INTO payments (loan_id, amount, paid_on) VALUES (?, ?, ?)",
            (rng.choice(loans), rng.randint(5, 50) * 500, clock.strftime("%Y-%m-%d")),
        )
        return True

    def edit_customer() -> bool:
        customers = ids("SELECT id FROM customers")
        if not customers:
            return False
        if rng.random() < 0.5:
            conn.execute(
                "UPDATE customers SET phone = ? WHERE id = ?",
                (f"9{rng.randint(100000000, 999999999)}", rng.choice(customers)),
            )
        else:
            conn.execute(
                "UPDATE customers SET city = ? WHERE id = ?",
                (rng.choice(CITIES), rng.choice(customers)),
            )
        return True

    def revise_loan() -> bool:
        loans = ids("SELECT id FROM loans WHERE status IN ('Pending', 'Approved')")
        if not loans:
            return False
        conn.execute(
            "UPDATE loans SET amount = ?, interest_rate = interest_rate - 0.5 WHERE id = ?",
            (rng.randint(10, 200) * 1000, rng.choice(loans)),
        )
        return True

    def reject_loan() -> bool:
        loans = ids("SELECT id FROM loans WHERE status = 'Pending'")
        if len(loans) < 2:
            return False
        conn.execute("DELETE FROM loans WHERE id = ?", (rng.choice(loans),))
        return True

    def reverse_payment() -> bool:
        payments = ids("SELECT id FROM payments")
        if len(payments) < 3:
            return False
        conn.execute("DELETE FROM payments WHERE id = ?", (rng.choice(payments),))
        return True

    def remove_customer() -> bool:
        customers = ids(
            "SELECT id FROM customers WHERE id NOT IN (SELECT customer_id FROM loans)"
        )
        if not customers:
            return False
        conn.execute("DELETE FROM customers WHERE id = ?", (rng.choice(customers),))
        return True

    # Opening activity: register customers and their first loan applications.
    for step in [add_customer] * 6 + [add_loan] * 5:
        tick()
        step()

    actions = [add_customer, add_loan, advance_loan, add_payment, edit_customer,
               revise_loan, reject_loan, reverse_payment, remove_customer]
    weights = [2, 3, 5, 5, 2, 1, 1, 1, 1]
    while tick():
        for action in rng.choices(actions, weights, k=3):
            if action():
                break
