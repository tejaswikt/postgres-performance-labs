# PostgreSQL 16 Performance Tuning & Diagnostics Labs 🚀

Welcome to the ultimate hands-on PostgreSQL performance tuning playground! This repository contains production-mimicking database schemas and automated scripts designed to help you master PostgreSQL diagnostics.

You will learn how to transition from reactive firefighting to proactive database engineering using three core layers of analysis:
1. **Raw Engine Log Auditing** (using native Linux commands like grep/awk)
2. **Interactive Traffic Visualization** (via pgBadger)
3. **Macro Workload Profiling** (via pg_profile)

---

## 🏗️ Lab Architecture & Schema

The sandbox utilizes a mock financial transaction system containing four highly dependent tables inside the `consumer` schema:

* **`consumer.customers`** (Parent customer accounts)
* **`consumer.credit_cards`** (Assigned credit cards mapping to customers)
* **`consumer.transactions`** (Real-time transactions mapping to active cards)
* **`consumer.payments`** (Direct debit billing payments)

---

## ⚙️ Prerequisites

To run these labs, ensure your sandbox meets the following:
* **PostgreSQL 16** (or newer)
* Active configuration matching the recommended production logging parameters (see `/baseline` configurations)
* Superuser access (`postgres` user) on your server/Vagrant box

---

## 🚀 Quick Start (Clean Slate Reset)

Run this single, combined command on your PostgreSQL server to instantly clone the repository, drop any old database structures, recreate the fresh schema, and load the optimized **Happy Flow** dataset:

```bash
git clone [https://github.com/tejaswikt/postgres-performance-labs.git](https://github.com/tejaswikt/postgres-performance-labs.git) && \
cd postgres-performance-labs/baseline/ && \
chmod +x deploy_new_lab.sh && \
./deploy_new_lab.sh
