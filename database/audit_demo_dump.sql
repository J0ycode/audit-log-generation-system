BEGIN TRANSACTION;
CREATE TABLE audit_context (
    id         INTEGER PRIMARY KEY CHECK (id = 1),
    user_name  TEXT NOT NULL,
    ts         TEXT
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
INSERT INTO "audit_log" VALUES(1,'customers',1,'INSERT',NULL,'{"id":1,"name":"Arun Nair","phone":"9896233790","city":"Kozhikode"}','admin','2026-10-20 10:27:00');
INSERT INTO "audit_log" VALUES(2,'customers',2,'INSERT',NULL,'{"id":2,"name":"Meera Joseph","phone":"9249827706","city":"Palakkad"}','ravi.kumar','2026-10-20 13:02:00');
INSERT INTO "audit_log" VALUES(3,'customers',3,'INSERT',NULL,'{"id":3,"name":"Rahul Das","phone":"9734036506","city":"Kollam"}','admin','2026-10-20 14:24:00');
INSERT INTO "audit_log" VALUES(4,'customers',4,'INSERT',NULL,'{"id":4,"name":"Fathima Basheer","phone":"9200604502","city":"Thrissur"}','admin','2026-10-20 15:10:00');
INSERT INTO "audit_log" VALUES(5,'customers',5,'INSERT',NULL,'{"id":5,"name":"Joseph Mathew","phone":"9702632297","city":"Thrissur"}','admin','2026-10-20 17:39:00');
INSERT INTO "audit_log" VALUES(6,'customers',6,'INSERT',NULL,'{"id":6,"name":"Lakshmi Varma","phone":"9732719211","city":"Kozhikode"}','suresh.pillai','2026-10-21 09:14:00');
INSERT INTO "audit_log" VALUES(7,'loans',1,'INSERT',NULL,'{"id":1,"customer_id":3,"loan_type":"Weekly Loan","amount":81000.0,"interest_rate":15.0,"status":"Pending"}','ravi.kumar','2026-10-21 09:47:00');
INSERT INTO "audit_log" VALUES(8,'loans',2,'INSERT',NULL,'{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Pending"}','ravi.kumar','2026-10-21 11:36:00');
INSERT INTO "audit_log" VALUES(9,'loans',3,'INSERT',NULL,'{"id":3,"customer_id":3,"loan_type":"Personal Loan","amount":164000.0,"interest_rate":15.0,"status":"Pending"}','admin','2026-10-21 15:20:00');
INSERT INTO "audit_log" VALUES(10,'loans',4,'INSERT',NULL,'{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":41000.0,"interest_rate":15.0,"status":"Pending"}','admin','2026-10-22 09:51:00');
INSERT INTO "audit_log" VALUES(11,'loans',5,'INSERT',NULL,'{"id":5,"customer_id":3,"loan_type":"Daily Loan","amount":170000.0,"interest_rate":15.0,"status":"Pending"}','admin','2026-10-22 13:34:00');
INSERT INTO "audit_log" VALUES(12,'customers',7,'INSERT',NULL,'{"id":7,"name":"Nikhil Raj","phone":"9410727955","city":"Kochi"}','ravi.kumar','2026-10-22 17:09:00');
INSERT INTO "audit_log" VALUES(13,'loans',2,'UPDATE','{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Pending"}','{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Approved"}','admin','2026-10-23 09:55:00');
INSERT INTO "audit_log" VALUES(14,'loans',6,'INSERT',NULL,'{"id":6,"customer_id":5,"loan_type":"Gold Loan","amount":172000.0,"interest_rate":18.0,"status":"Pending"}','anita.menon','2026-10-23 13:34:00');
INSERT INTO "audit_log" VALUES(15,'loans',7,'INSERT',NULL,'{"id":7,"customer_id":2,"loan_type":"Daily Loan","amount":185000.0,"interest_rate":15.0,"status":"Pending"}','ravi.kumar','2026-10-23 15:31:00');
INSERT INTO "audit_log" VALUES(16,'loans',8,'INSERT',NULL,'{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Pending"}','admin','2026-10-24 09:53:00');
INSERT INTO "audit_log" VALUES(17,'loans',8,'UPDATE','{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Pending"}','{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Approved"}','ravi.kumar','2026-10-24 13:04:00');
INSERT INTO "audit_log" VALUES(18,'loans',9,'INSERT',NULL,'{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":159000.0,"interest_rate":15.0,"status":"Pending"}','anita.menon','2026-10-24 14:47:00');
INSERT INTO "audit_log" VALUES(19,'customers',6,'DELETE','{"id":6,"name":"Lakshmi Varma","phone":"9732719211","city":"Kozhikode"}',NULL,'ravi.kumar','2026-10-25 09:23:00');
INSERT INTO "audit_log" VALUES(20,'customers',5,'UPDATE','{"id":5,"name":"Joseph Mathew","phone":"9702632297","city":"Thrissur"}','{"id":5,"name":"Joseph Mathew","phone":"9509760584","city":"Thrissur"}','ravi.kumar','2026-10-25 10:49:00');
INSERT INTO "audit_log" VALUES(21,'customers',7,'DELETE','{"id":7,"name":"Nikhil Raj","phone":"9410727955","city":"Kochi"}',NULL,'anita.menon','2026-10-25 15:18:00');
INSERT INTO "audit_log" VALUES(22,'loans',10,'INSERT',NULL,'{"id":10,"customer_id":5,"loan_type":"Personal Loan","amount":55000.0,"interest_rate":15.0,"status":"Pending"}','anita.menon','2026-10-26 09:49:00');
INSERT INTO "audit_log" VALUES(23,'loans',5,'DELETE','{"id":5,"customer_id":3,"loan_type":"Daily Loan","amount":170000.0,"interest_rate":15.0,"status":"Pending"}',NULL,'admin','2026-10-26 14:38:00');
INSERT INTO "audit_log" VALUES(24,'customers',5,'UPDATE','{"id":5,"name":"Joseph Mathew","phone":"9509760584","city":"Thrissur"}','{"id":5,"name":"Joseph Mathew","phone":"9509760584","city":"Kochi"}','anita.menon','2026-10-26 16:26:00');
INSERT INTO "audit_log" VALUES(25,'loans',11,'INSERT',NULL,'{"id":11,"customer_id":2,"loan_type":"Personal Loan","amount":24000.0,"interest_rate":15.0,"status":"Pending"}','admin','2026-10-27 09:31:00');
INSERT INTO "audit_log" VALUES(26,'customers',8,'INSERT',NULL,'{"id":8,"name":"Lakshmi Varma","phone":"9916690353","city":"Kottayam"}','admin','2026-10-27 12:04:00');
INSERT INTO "audit_log" VALUES(27,'loans',12,'INSERT',NULL,'{"id":12,"customer_id":5,"loan_type":"Daily Loan","amount":118000.0,"interest_rate":15.0,"status":"Pending"}','ravi.kumar','2026-10-27 13:38:00');
INSERT INTO "audit_log" VALUES(28,'loans',7,'UPDATE','{"id":7,"customer_id":2,"loan_type":"Daily Loan","amount":185000.0,"interest_rate":15.0,"status":"Pending"}','{"id":7,"customer_id":2,"loan_type":"Daily Loan","amount":185000.0,"interest_rate":15.0,"status":"Approved"}','ravi.kumar','2026-10-27 15:56:00');
INSERT INTO "audit_log" VALUES(29,'loans',13,'INSERT',NULL,'{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Pending"}','suresh.pillai','2026-10-28 09:57:00');
INSERT INTO "audit_log" VALUES(30,'customers',9,'INSERT',NULL,'{"id":9,"name":"Nikhil Raj","phone":"9133729406","city":"Kozhikode"}','admin','2026-10-28 12:19:00');
INSERT INTO "audit_log" VALUES(31,'loans',13,'UPDATE','{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Pending"}','{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Approved"}','ravi.kumar','2026-10-28 13:25:00');
INSERT INTO "audit_log" VALUES(32,'customers',3,'UPDATE','{"id":3,"name":"Rahul Das","phone":"9734036506","city":"Kollam"}','{"id":3,"name":"Rahul Das","phone":"9562837684","city":"Kollam"}','ravi.kumar','2026-10-28 17:57:00');
INSERT INTO "audit_log" VALUES(33,'loans',3,'DELETE','{"id":3,"customer_id":3,"loan_type":"Personal Loan","amount":164000.0,"interest_rate":15.0,"status":"Pending"}',NULL,'suresh.pillai','2026-10-29 09:26:00');
INSERT INTO "audit_log" VALUES(34,'customers',4,'UPDATE','{"id":4,"name":"Fathima Basheer","phone":"9200604502","city":"Thrissur"}','{"id":4,"name":"Fathima Basheer","phone":"9675832441","city":"Thrissur"}','suresh.pillai','2026-10-29 10:27:00');
INSERT INTO "audit_log" VALUES(35,'loans',14,'INSERT',NULL,'{"id":14,"customer_id":4,"loan_type":"Gold Loan","amount":150000.0,"interest_rate":18.0,"status":"Pending"}','suresh.pillai','2026-10-29 12:08:00');
INSERT INTO "audit_log" VALUES(36,'customers',10,'INSERT',NULL,'{"id":10,"name":"Sneha Thomas","phone":"9200140141","city":"Thrissur"}','admin','2026-10-29 13:28:00');
INSERT INTO "audit_log" VALUES(37,'loans',15,'INSERT',NULL,'{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Pending"}','suresh.pillai','2026-10-29 15:23:00');
INSERT INTO "audit_log" VALUES(38,'loans',9,'UPDATE','{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":159000.0,"interest_rate":15.0,"status":"Pending"}','{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":159000.0,"interest_rate":15.0,"status":"Approved"}','suresh.pillai','2026-10-29 15:54:00');
INSERT INTO "audit_log" VALUES(39,'loans',11,'UPDATE','{"id":11,"customer_id":2,"loan_type":"Personal Loan","amount":24000.0,"interest_rate":15.0,"status":"Pending"}','{"id":11,"customer_id":2,"loan_type":"Personal Loan","amount":24000.0,"interest_rate":15.0,"status":"Approved"}','ravi.kumar','2026-10-30 09:09:00');
INSERT INTO "audit_log" VALUES(40,'customers',11,'INSERT',NULL,'{"id":11,"name":"Vivek Menon","phone":"9670292350","city":"Thrissur"}','anita.menon','2026-10-30 10:10:00');
INSERT INTO "audit_log" VALUES(41,'loans',9,'UPDATE','{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":159000.0,"interest_rate":15.0,"status":"Approved"}','{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":70000.0,"interest_rate":14.5,"status":"Approved"}','admin','2026-10-30 11:09:00');
INSERT INTO "audit_log" VALUES(42,'customers',12,'INSERT',NULL,'{"id":12,"name":"Divya Krishnan","phone":"9805849060","city":"Kottayam"}','ravi.kumar','2026-10-30 12:40:00');
INSERT INTO "audit_log" VALUES(43,'loans',16,'INSERT',NULL,'{"id":16,"customer_id":5,"loan_type":"Vehicle Loan","amount":111000.0,"interest_rate":14.0,"status":"Pending"}','anita.menon','2026-10-30 17:37:00');
INSERT INTO "audit_log" VALUES(44,'loans',1,'UPDATE','{"id":1,"customer_id":3,"loan_type":"Weekly Loan","amount":81000.0,"interest_rate":15.0,"status":"Pending"}','{"id":1,"customer_id":3,"loan_type":"Weekly Loan","amount":81000.0,"interest_rate":15.0,"status":"Approved"}','anita.menon','2026-10-31 09:42:00');
INSERT INTO "audit_log" VALUES(45,'customers',13,'INSERT',NULL,'{"id":13,"name":"Abdul Rahman","phone":"9474745382","city":"Kochi"}','admin','2026-10-31 14:06:00');
INSERT INTO "audit_log" VALUES(46,'loans',7,'UPDATE','{"id":7,"customer_id":2,"loan_type":"Daily Loan","amount":185000.0,"interest_rate":15.0,"status":"Approved"}','{"id":7,"customer_id":2,"loan_type":"Daily Loan","amount":185000.0,"interest_rate":15.0,"status":"Disbursed"}','anita.menon','2026-10-31 16:41:00');
INSERT INTO "audit_log" VALUES(47,'loans',17,'INSERT',NULL,'{"id":17,"customer_id":2,"loan_type":"Personal Loan","amount":37000.0,"interest_rate":15.0,"status":"Pending"}','anita.menon','2026-11-01 09:00:00');
INSERT INTO "audit_log" VALUES(48,'loans',13,'UPDATE','{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Approved"}','{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Disbursed"}','anita.menon','2026-11-01 10:49:00');
INSERT INTO "audit_log" VALUES(49,'loans',13,'UPDATE','{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Disbursed"}','{"id":13,"customer_id":5,"loan_type":"Daily Loan","amount":68000.0,"interest_rate":15.0,"status":"Closed"}','suresh.pillai','2026-11-01 13:34:00');
INSERT INTO "audit_log" VALUES(50,'customers',14,'INSERT',NULL,'{"id":14,"name":"Priya George","phone":"9381272327","city":"Thrissur"}','anita.menon','2026-11-01 17:40:00');
INSERT INTO "audit_log" VALUES(51,'payments',1,'INSERT',NULL,'{"id":1,"loan_id":7,"amount":19500.0,"paid_on":"2026-11-02"}','suresh.pillai','2026-11-02 09:35:00');
INSERT INTO "audit_log" VALUES(52,'payments',2,'INSERT',NULL,'{"id":2,"loan_id":7,"amount":14000.0,"paid_on":"2026-11-02"}','anita.menon','2026-11-02 10:23:00');
INSERT INTO "audit_log" VALUES(53,'loans',18,'INSERT',NULL,'{"id":18,"customer_id":9,"loan_type":"Daily Loan","amount":168000.0,"interest_rate":15.0,"status":"Pending"}','anita.menon','2026-11-02 11:13:00');
INSERT INTO "audit_log" VALUES(54,'loans',16,'DELETE','{"id":16,"customer_id":5,"loan_type":"Vehicle Loan","amount":111000.0,"interest_rate":14.0,"status":"Pending"}',NULL,'ravi.kumar','2026-11-02 13:02:00');
INSERT INTO "audit_log" VALUES(55,'customers',4,'UPDATE','{"id":4,"name":"Fathima Basheer","phone":"9675832441","city":"Thrissur"}','{"id":4,"name":"Fathima Basheer","phone":"9675832441","city":"Palakkad"}','ravi.kumar','2026-11-02 13:44:00');
INSERT INTO "audit_log" VALUES(56,'customers',4,'UPDATE','{"id":4,"name":"Fathima Basheer","phone":"9675832441","city":"Palakkad"}','{"id":4,"name":"Fathima Basheer","phone":"9675832441","city":"Thrissur"}','ravi.kumar','2026-11-02 16:30:00');
INSERT INTO "audit_log" VALUES(57,'loans',6,'UPDATE','{"id":6,"customer_id":5,"loan_type":"Gold Loan","amount":172000.0,"interest_rate":18.0,"status":"Pending"}','{"id":6,"customer_id":5,"loan_type":"Gold Loan","amount":178000.0,"interest_rate":17.5,"status":"Pending"}','anita.menon','2026-11-03 09:22:00');
INSERT INTO "audit_log" VALUES(58,'loans',8,'UPDATE','{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Approved"}','{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Disbursed"}','anita.menon','2026-11-03 13:16:00');
INSERT INTO "audit_log" VALUES(59,'loans',19,'INSERT',NULL,'{"id":19,"customer_id":12,"loan_type":"Vehicle Loan","amount":77000.0,"interest_rate":14.0,"status":"Pending"}','anita.menon','2026-11-04 09:25:00');
INSERT INTO "audit_log" VALUES(60,'payments',3,'INSERT',NULL,'{"id":3,"loan_id":8,"amount":21500.0,"paid_on":"2026-11-04"}','admin','2026-11-04 10:14:00');
INSERT INTO "audit_log" VALUES(61,'loans',15,'UPDATE','{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Pending"}','{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Approved"}','admin','2026-11-04 15:05:00');
INSERT INTO "audit_log" VALUES(62,'loans',8,'UPDATE','{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Disbursed"}','{"id":8,"customer_id":1,"loan_type":"Personal Loan","amount":64000.0,"interest_rate":15.0,"status":"Closed"}','ravi.kumar','2026-11-05 09:00:00');
INSERT INTO "audit_log" VALUES(63,'customers',14,'UPDATE','{"id":14,"name":"Priya George","phone":"9381272327","city":"Thrissur"}','{"id":14,"name":"Priya George","phone":"9532074125","city":"Thrissur"}','admin','2026-11-05 12:10:00');
INSERT INTO "audit_log" VALUES(64,'loans',20,'INSERT',NULL,'{"id":20,"customer_id":12,"loan_type":"Vehicle Loan","amount":155000.0,"interest_rate":14.0,"status":"Pending"}','ravi.kumar','2026-11-05 15:11:00');
INSERT INTO "audit_log" VALUES(65,'loans',14,'UPDATE','{"id":14,"customer_id":4,"loan_type":"Gold Loan","amount":150000.0,"interest_rate":18.0,"status":"Pending"}','{"id":14,"customer_id":4,"loan_type":"Gold Loan","amount":150000.0,"interest_rate":18.0,"status":"Approved"}','admin','2026-11-06 09:25:00');
INSERT INTO "audit_log" VALUES(66,'loans',18,'UPDATE','{"id":18,"customer_id":9,"loan_type":"Daily Loan","amount":168000.0,"interest_rate":15.0,"status":"Pending"}','{"id":18,"customer_id":9,"loan_type":"Daily Loan","amount":168000.0,"interest_rate":15.0,"status":"Approved"}','suresh.pillai','2026-11-06 12:39:00');
INSERT INTO "audit_log" VALUES(67,'loans',2,'UPDATE','{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Approved"}','{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Disbursed"}','admin','2026-11-06 14:35:00');
INSERT INTO "audit_log" VALUES(68,'loans',21,'INSERT',NULL,'{"id":21,"customer_id":10,"loan_type":"Vehicle Loan","amount":166000.0,"interest_rate":14.0,"status":"Pending"}','anita.menon','2026-11-06 17:05:00');
INSERT INTO "audit_log" VALUES(69,'loans',20,'DELETE','{"id":20,"customer_id":12,"loan_type":"Vehicle Loan","amount":155000.0,"interest_rate":14.0,"status":"Pending"}',NULL,'suresh.pillai','2026-11-07 09:29:00');
INSERT INTO "audit_log" VALUES(70,'loans',18,'UPDATE','{"id":18,"customer_id":9,"loan_type":"Daily Loan","amount":168000.0,"interest_rate":15.0,"status":"Approved"}','{"id":18,"customer_id":9,"loan_type":"Daily Loan","amount":168000.0,"interest_rate":15.0,"status":"Disbursed"}','suresh.pillai','2026-11-07 14:12:00');
INSERT INTO "audit_log" VALUES(71,'loans',22,'INSERT',NULL,'{"id":22,"customer_id":1,"loan_type":"Weekly Loan","amount":152000.0,"interest_rate":15.0,"status":"Pending"}','suresh.pillai','2026-11-07 15:36:00');
INSERT INTO "audit_log" VALUES(72,'loans',15,'UPDATE','{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Approved"}','{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Disbursed"}','admin','2026-11-08 09:58:00');
INSERT INTO "audit_log" VALUES(73,'loans',14,'UPDATE','{"id":14,"customer_id":4,"loan_type":"Gold Loan","amount":150000.0,"interest_rate":18.0,"status":"Approved"}','{"id":14,"customer_id":4,"loan_type":"Gold Loan","amount":200000.0,"interest_rate":17.5,"status":"Approved"}','suresh.pillai','2026-11-08 14:14:00');
INSERT INTO "audit_log" VALUES(74,'loans',21,'UPDATE','{"id":21,"customer_id":10,"loan_type":"Vehicle Loan","amount":166000.0,"interest_rate":14.0,"status":"Pending"}','{"id":21,"customer_id":10,"loan_type":"Vehicle Loan","amount":134000.0,"interest_rate":13.5,"status":"Pending"}','ravi.kumar','2026-11-09 09:16:00');
INSERT INTO "audit_log" VALUES(75,'loans',15,'UPDATE','{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Disbursed"}','{"id":15,"customer_id":3,"loan_type":"Gold Loan","amount":107000.0,"interest_rate":18.0,"status":"Closed"}','anita.menon','2026-11-09 11:48:00');
INSERT INTO "audit_log" VALUES(76,'loans',23,'INSERT',NULL,'{"id":23,"customer_id":2,"loan_type":"Vehicle Loan","amount":116000.0,"interest_rate":14.0,"status":"Pending"}','admin','2026-11-09 15:01:00');
INSERT INTO "audit_log" VALUES(77,'loans',1,'UPDATE','{"id":1,"customer_id":3,"loan_type":"Weekly Loan","amount":81000.0,"interest_rate":15.0,"status":"Approved"}','{"id":1,"customer_id":3,"loan_type":"Weekly Loan","amount":81000.0,"interest_rate":15.0,"status":"Disbursed"}','suresh.pillai','2026-11-10 09:21:00');
INSERT INTO "audit_log" VALUES(78,'customers',15,'INSERT',NULL,'{"id":15,"name":"Sanjay Iyer","phone":"9997356828","city":"Kollam"}','suresh.pillai','2026-11-10 13:05:00');
INSERT INTO "audit_log" VALUES(79,'loans',24,'INSERT',NULL,'{"id":24,"customer_id":13,"loan_type":"Personal Loan","amount":183000.0,"interest_rate":15.0,"status":"Pending"}','suresh.pillai','2026-11-10 15:27:00');
INSERT INTO "audit_log" VALUES(80,'loans',4,'UPDATE','{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":41000.0,"interest_rate":15.0,"status":"Pending"}','{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":146000.0,"interest_rate":14.5,"status":"Pending"}','ravi.kumar','2026-11-11 09:46:00');
INSERT INTO "audit_log" VALUES(81,'customers',16,'INSERT',NULL,'{"id":16,"name":"Anjali Pillai","phone":"9295130056","city":"Kochi"}','admin','2026-11-11 13:37:00');
INSERT INTO "audit_log" VALUES(82,'loans',19,'UPDATE','{"id":19,"customer_id":12,"loan_type":"Vehicle Loan","amount":77000.0,"interest_rate":14.0,"status":"Pending"}','{"id":19,"customer_id":12,"loan_type":"Vehicle Loan","amount":77000.0,"interest_rate":14.0,"status":"Approved"}','suresh.pillai','2026-11-11 16:20:00');
INSERT INTO "audit_log" VALUES(83,'loans',2,'UPDATE','{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Disbursed"}','{"id":2,"customer_id":1,"loan_type":"Personal Loan","amount":33000.0,"interest_rate":15.0,"status":"Closed"}','suresh.pillai','2026-11-12 09:48:00');
INSERT INTO "audit_log" VALUES(84,'payments',4,'INSERT',NULL,'{"id":4,"loan_id":1,"amount":10000.0,"paid_on":"2026-11-12"}','ravi.kumar','2026-11-12 13:17:00');
INSERT INTO "audit_log" VALUES(85,'payments',5,'INSERT',NULL,'{"id":5,"loan_id":1,"amount":20500.0,"paid_on":"2026-11-12"}','admin','2026-11-12 15:29:00');
INSERT INTO "audit_log" VALUES(86,'payments',6,'INSERT',NULL,'{"id":6,"loan_id":18,"amount":25000.0,"paid_on":"2026-11-12"}','suresh.pillai','2026-11-12 17:50:00');
INSERT INTO "audit_log" VALUES(87,'customers',14,'DELETE','{"id":14,"name":"Priya George","phone":"9532074125","city":"Thrissur"}',NULL,'ravi.kumar','2026-11-13 09:49:00');
INSERT INTO "audit_log" VALUES(88,'payments',6,'DELETE','{"id":6,"loan_id":18,"amount":25000.0,"paid_on":"2026-11-12"}',NULL,'suresh.pillai','2026-11-13 13:31:00');
INSERT INTO "audit_log" VALUES(89,'payments',7,'INSERT',NULL,'{"id":7,"loan_id":1,"amount":20500.0,"paid_on":"2026-11-13"}','admin','2026-11-13 16:05:00');
INSERT INTO "audit_log" VALUES(90,'payments',8,'INSERT',NULL,'{"id":8,"loan_id":18,"amount":13000.0,"paid_on":"2026-11-13"}','anita.menon','2026-11-13 16:56:00');
INSERT INTO "audit_log" VALUES(91,'loans',17,'UPDATE','{"id":17,"customer_id":2,"loan_type":"Personal Loan","amount":37000.0,"interest_rate":15.0,"status":"Pending"}','{"id":17,"customer_id":2,"loan_type":"Personal Loan","amount":172000.0,"interest_rate":14.5,"status":"Pending"}','suresh.pillai','2026-11-13 17:32:00');
INSERT INTO "audit_log" VALUES(92,'customers',16,'UPDATE','{"id":16,"name":"Anjali Pillai","phone":"9295130056","city":"Kochi"}','{"id":16,"name":"Anjali Pillai","phone":"9295130056","city":"Kottayam"}','ravi.kumar','2026-11-14 09:27:00');
INSERT INTO "audit_log" VALUES(93,'loans',12,'UPDATE','{"id":12,"customer_id":5,"loan_type":"Daily Loan","amount":118000.0,"interest_rate":15.0,"status":"Pending"}','{"id":12,"customer_id":5,"loan_type":"Daily Loan","amount":118000.0,"interest_rate":15.0,"status":"Approved"}','suresh.pillai','2026-11-14 14:04:00');
INSERT INTO "audit_log" VALUES(94,'loans',23,'DELETE','{"id":23,"customer_id":2,"loan_type":"Vehicle Loan","amount":116000.0,"interest_rate":14.0,"status":"Pending"}',NULL,'anita.menon','2026-11-14 15:18:00');
INSERT INTO "audit_log" VALUES(95,'loans',12,'UPDATE','{"id":12,"customer_id":5,"loan_type":"Daily Loan","amount":118000.0,"interest_rate":15.0,"status":"Approved"}','{"id":12,"customer_id":5,"loan_type":"Daily Loan","amount":76000.0,"interest_rate":14.5,"status":"Approved"}','suresh.pillai','2026-11-15 09:01:00');
INSERT INTO "audit_log" VALUES(96,'payments',9,'INSERT',NULL,'{"id":9,"loan_id":1,"amount":15500.0,"paid_on":"2026-11-15"}','anita.menon','2026-11-15 11:54:00');
INSERT INTO "audit_log" VALUES(97,'payments',10,'INSERT',NULL,'{"id":10,"loan_id":1,"amount":5000.0,"paid_on":"2026-11-15"}','ravi.kumar','2026-11-15 16:34:00');
INSERT INTO "audit_log" VALUES(98,'payments',11,'INSERT',NULL,'{"id":11,"loan_id":7,"amount":20000.0,"paid_on":"2026-11-16"}','suresh.pillai','2026-11-16 09:14:00');
INSERT INTO "audit_log" VALUES(99,'customers',16,'DELETE','{"id":16,"name":"Anjali Pillai","phone":"9295130056","city":"Kottayam"}',NULL,'suresh.pillai','2026-11-16 12:40:00');
INSERT INTO "audit_log" VALUES(100,'loans',4,'UPDATE','{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":146000.0,"interest_rate":14.5,"status":"Pending"}','{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":146000.0,"interest_rate":14.5,"status":"Approved"}','anita.menon','2026-11-16 15:28:00');
INSERT INTO "audit_log" VALUES(101,'loans',25,'INSERT',NULL,'{"id":25,"customer_id":12,"loan_type":"Daily Loan","amount":82000.0,"interest_rate":15.0,"status":"Pending"}','ravi.kumar','2026-11-16 17:32:00');
INSERT INTO "audit_log" VALUES(102,'loans',9,'UPDATE','{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":70000.0,"interest_rate":14.5,"status":"Approved"}','{"id":9,"customer_id":4,"loan_type":"Daily Loan","amount":70000.0,"interest_rate":14.5,"status":"Disbursed"}','ravi.kumar','2026-11-17 09:53:00');
INSERT INTO "audit_log" VALUES(103,'customers',8,'DELETE','{"id":8,"name":"Lakshmi Varma","phone":"9916690353","city":"Kottayam"}',NULL,'admin','2026-11-17 12:43:00');
INSERT INTO "audit_log" VALUES(104,'loans',21,'DELETE','{"id":21,"customer_id":10,"loan_type":"Vehicle Loan","amount":134000.0,"interest_rate":13.5,"status":"Pending"}',NULL,'admin','2026-11-17 17:24:00');
INSERT INTO "audit_log" VALUES(105,'loans',4,'UPDATE','{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":146000.0,"interest_rate":14.5,"status":"Approved"}','{"id":4,"customer_id":5,"loan_type":"Weekly Loan","amount":146000.0,"interest_rate":14.5,"status":"Disbursed"}','admin','2026-11-18 09:11:00');
CREATE TABLE customers (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    name        TEXT NOT NULL,
    phone       TEXT NOT NULL,
    city        TEXT NOT NULL
);
INSERT INTO "customers" VALUES(1,'Arun Nair','9896233790','Kozhikode');
INSERT INTO "customers" VALUES(2,'Meera Joseph','9249827706','Palakkad');
INSERT INTO "customers" VALUES(3,'Rahul Das','9562837684','Kollam');
INSERT INTO "customers" VALUES(4,'Fathima Basheer','9675832441','Thrissur');
INSERT INTO "customers" VALUES(5,'Joseph Mathew','9509760584','Kochi');
INSERT INTO "customers" VALUES(9,'Nikhil Raj','9133729406','Kozhikode');
INSERT INTO "customers" VALUES(10,'Sneha Thomas','9200140141','Thrissur');
INSERT INTO "customers" VALUES(11,'Vivek Menon','9670292350','Thrissur');
INSERT INTO "customers" VALUES(12,'Divya Krishnan','9805849060','Kottayam');
INSERT INTO "customers" VALUES(13,'Abdul Rahman','9474745382','Kochi');
INSERT INTO "customers" VALUES(15,'Sanjay Iyer','9997356828','Kollam');
CREATE TABLE loans (
    id             INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id    INTEGER NOT NULL REFERENCES customers(id),
    loan_type      TEXT NOT NULL,
    amount         REAL NOT NULL,
    interest_rate  REAL NOT NULL,
    status         TEXT NOT NULL DEFAULT 'Pending'
);
INSERT INTO "loans" VALUES(1,3,'Weekly Loan',81000.0,15.0,'Disbursed');
INSERT INTO "loans" VALUES(2,1,'Personal Loan',33000.0,15.0,'Closed');
INSERT INTO "loans" VALUES(4,5,'Weekly Loan',146000.0,14.5,'Disbursed');
INSERT INTO "loans" VALUES(6,5,'Gold Loan',178000.0,17.5,'Pending');
INSERT INTO "loans" VALUES(7,2,'Daily Loan',185000.0,15.0,'Disbursed');
INSERT INTO "loans" VALUES(8,1,'Personal Loan',64000.0,15.0,'Closed');
INSERT INTO "loans" VALUES(9,4,'Daily Loan',70000.0,14.5,'Disbursed');
INSERT INTO "loans" VALUES(10,5,'Personal Loan',55000.0,15.0,'Pending');
INSERT INTO "loans" VALUES(11,2,'Personal Loan',24000.0,15.0,'Approved');
INSERT INTO "loans" VALUES(12,5,'Daily Loan',76000.0,14.5,'Approved');
INSERT INTO "loans" VALUES(13,5,'Daily Loan',68000.0,15.0,'Closed');
INSERT INTO "loans" VALUES(14,4,'Gold Loan',200000.0,17.5,'Approved');
INSERT INTO "loans" VALUES(15,3,'Gold Loan',107000.0,18.0,'Closed');
INSERT INTO "loans" VALUES(17,2,'Personal Loan',172000.0,14.5,'Pending');
INSERT INTO "loans" VALUES(18,9,'Daily Loan',168000.0,15.0,'Disbursed');
INSERT INTO "loans" VALUES(19,12,'Vehicle Loan',77000.0,14.0,'Approved');
INSERT INTO "loans" VALUES(22,1,'Weekly Loan',152000.0,15.0,'Pending');
INSERT INTO "loans" VALUES(24,13,'Personal Loan',183000.0,15.0,'Pending');
INSERT INTO "loans" VALUES(25,12,'Daily Loan',82000.0,15.0,'Pending');
CREATE TABLE payments (
    id        INTEGER PRIMARY KEY AUTOINCREMENT,
    loan_id   INTEGER NOT NULL REFERENCES loans(id),
    amount    REAL NOT NULL,
    paid_on   TEXT NOT NULL
);
INSERT INTO "payments" VALUES(1,7,19500.0,'2026-11-02');
INSERT INTO "payments" VALUES(2,7,14000.0,'2026-11-02');
INSERT INTO "payments" VALUES(3,8,21500.0,'2026-11-04');
INSERT INTO "payments" VALUES(4,1,10000.0,'2026-11-12');
INSERT INTO "payments" VALUES(5,1,20500.0,'2026-11-12');
INSERT INTO "payments" VALUES(7,1,20500.0,'2026-11-13');
INSERT INTO "payments" VALUES(8,18,13000.0,'2026-11-13');
INSERT INTO "payments" VALUES(9,1,15500.0,'2026-11-15');
INSERT INTO "payments" VALUES(10,1,5000.0,'2026-11-15');
INSERT INTO "payments" VALUES(11,7,20000.0,'2026-11-16');
CREATE INDEX idx_audit_log_changed_at ON audit_log(changed_at);
CREATE TRIGGER trg_customers_insert AFTER INSERT ON customers BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('customers', NEW.id, 'INSERT', NULL, json_object('id', NEW.id, 'name', NEW.name, 'phone', NEW.phone, 'city', NEW.city), COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_customers_update AFTER UPDATE ON customers BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('customers', NEW.id, 'UPDATE', json_object('id', OLD.id, 'name', OLD.name, 'phone', OLD.phone, 'city', OLD.city), json_object('id', NEW.id, 'name', NEW.name, 'phone', NEW.phone, 'city', NEW.city), COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_customers_delete AFTER DELETE ON customers BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('customers', OLD.id, 'DELETE', json_object('id', OLD.id, 'name', OLD.name, 'phone', OLD.phone, 'city', OLD.city), NULL, COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_loans_insert AFTER INSERT ON loans BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('loans', NEW.id, 'INSERT', NULL, json_object('id', NEW.id, 'customer_id', NEW.customer_id, 'loan_type', NEW.loan_type, 'amount', NEW.amount, 'interest_rate', NEW.interest_rate, 'status', NEW.status), COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_loans_update AFTER UPDATE ON loans BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('loans', NEW.id, 'UPDATE', json_object('id', OLD.id, 'customer_id', OLD.customer_id, 'loan_type', OLD.loan_type, 'amount', OLD.amount, 'interest_rate', OLD.interest_rate, 'status', OLD.status), json_object('id', NEW.id, 'customer_id', NEW.customer_id, 'loan_type', NEW.loan_type, 'amount', NEW.amount, 'interest_rate', NEW.interest_rate, 'status', NEW.status), COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_loans_delete AFTER DELETE ON loans BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('loans', OLD.id, 'DELETE', json_object('id', OLD.id, 'customer_id', OLD.customer_id, 'loan_type', OLD.loan_type, 'amount', OLD.amount, 'interest_rate', OLD.interest_rate, 'status', OLD.status), NULL, COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_payments_insert AFTER INSERT ON payments BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('payments', NEW.id, 'INSERT', NULL, json_object('id', NEW.id, 'loan_id', NEW.loan_id, 'amount', NEW.amount, 'paid_on', NEW.paid_on), COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_payments_update AFTER UPDATE ON payments BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('payments', NEW.id, 'UPDATE', json_object('id', OLD.id, 'loan_id', OLD.loan_id, 'amount', OLD.amount, 'paid_on', OLD.paid_on), json_object('id', NEW.id, 'loan_id', NEW.loan_id, 'amount', NEW.amount, 'paid_on', NEW.paid_on), COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
CREATE TRIGGER trg_payments_delete AFTER DELETE ON payments BEGIN
    INSERT INTO audit_log (table_name, record_id, action, old_data, new_data, changed_by, changed_at)  VALUES ('payments', OLD.id, 'DELETE', json_object('id', OLD.id, 'loan_id', OLD.loan_id, 'amount', OLD.amount, 'paid_on', OLD.paid_on), NULL, COALESCE((SELECT user_name FROM audit_context WHERE id = 1), 'system'), COALESCE((SELECT ts FROM audit_context WHERE id = 1), strftime('%Y-%m-%d %H:%M:%S', 'now', 'localtime')));
END;
DELETE FROM "sqlite_sequence";
INSERT INTO "sqlite_sequence" VALUES('audit_log',105);
INSERT INTO "sqlite_sequence" VALUES('customers',16);
INSERT INTO "sqlite_sequence" VALUES('loans',25);
INSERT INTO "sqlite_sequence" VALUES('payments',11);
COMMIT;