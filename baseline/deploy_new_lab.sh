#!/bin/bash
# =========================================================================
# DEPLOY NEW LAB ENVIRONMENT WRAPPER
# Run as: postgres user (or via sudo)
# =========================================================================

set -e # Exit immediately if any command fails

echo "=== STEP 1: Terminating active connections to creditcards database ==="
psql -d postgres -c "
SELECT pg_terminate_backend(pg_stat_activity.pid)
FROM pg_stat_activity
WHERE pg_stat_activity.datname = 'creditcards'
  AND pid <> pg_backend_pid();"

echo "=== STEP 2: Dropping existing creditcards database ==="
psql -d postgres -c "DROP DATABASE IF EXISTS creditcards;"

echo "=== STEP 3: Creating fresh creditcards database ==="
psql -d postgres -c "CREATE DATABASE creditcards;"

echo "=== STEP 4: Executing schema definition and seeding workload ==="
psql -d creditcards -f ./setup_schema.sql

echo "========================================================================="
echo " SUCCESS: Lab has been completely reset and loaded on a clean slate!"
echo "========================================================================="
