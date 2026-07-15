#!/bin/bash

# =========================================================================
# ONE-SHOT CONFIGURATION RESET & POPULATION
# Run inside: /var/lib/pgsql/postgres-lab01/conf.d
# =========================================================================

echo "Change to the directory:"
cd /var/lib/pgsql/postgres-lab01/conf.d

echo "=== 1. Emptying all existing configuration files ==="
> 00-extensions.conf
> 01-performance.conf
> 02-logging.conf
> 03-vacuum.conf
> 04-wal.conf

echo "=== 2. Writing 00-extensions.conf ==="
cat << 'EOF' > 00-extensions.conf
# ============================================================
# Shared Libraries and Extensions
# ============================================================
shared_preload_libraries = 'pg_stat_statements, pg_wait_sampling, pg_cron'
EOF

echo "=== 3. Writing 01-performance.conf ==="
cat << 'EOF' > 01-performance.conf
# ============================================================
# PostgreSQL Performance & Extension Configuration
# Purpose: pg_profile & pg_stat_statements engine dependencies
# ============================================================

# pg_stat_statements Config
pg_stat_statements.max = 10000
pg_stat_statements.track = all
pg_stat_statements.track_planning = on
pg_stat_statements.save = on

# Core Engine Statistics Tracking
track_activities = on
track_counts = on
track_io_timing = on
track_wal_io_timing = on

# pg_cron Config
cron.database_name = 'postgres'
cron.timezone = 'Europe/Amsterdam'
EOF

echo "=== 4. Writing 02-logging.conf ==="
cat << 'EOF' > 02-logging.conf
# ============================================================
# PostgreSQL Logging Configuration
# Purpose: Production-grade performance troubleshooting logs
# ============================================================

# Log Storage and Destination
logging_collector = on
log_destination = 'stderr'
log_directory = 'log'

# Naming and Rotation
log_filename = 'postgresql-%Y-%m-%d_%H%M%S.log'
log_rotation_age = 1d
log_rotation_size = 1000MB
log_truncate_on_rotation = off

# Log Content Identity
log_line_prefix = '%m [%p] %q%u@%d [query_id=%Q] app=%a client=%h '
compute_query_id = on

# Slow Query Logging
log_min_duration_statement = 1000ms

# Lock, Wait, and Deadlock Auditing
log_lock_waits = on
deadlock_timeout = '1s'

# Temporary File / Spill Logging
log_temp_files = 0

# Checkpoint Logging
log_checkpoints = on

# Autovacuum Logging
log_autovacuum_min_duration = 100ms

# Error Statement Logging
log_min_error_statement = error

# General Message Level
log_min_messages = warning

# Connection Logging
log_connections = on
log_disconnections = on

# Statement Logging
log_statement = 'none'
log_duration = off
EOF

echo "=== 5. Writing 03-vacuum.conf (Declarative Placeholder) ==="
cat << 'EOF' > 03-vacuum.conf
# ============================================================
# Autovacuum Resource Allocation
# Left at default parameters for active lab tuning scenarios
# ============================================================
# autovacuum_max_workers = 3
# autovacuum_vacuum_scale_factor = 0.2
# autovacuum_analyze_scale_factor = 0.1
EOF

echo "=== 6. Writing 04-wal.conf (Declarative Placeholder) ==="
cat << 'EOF' > 04-wal.conf
# ============================================================
# Write-Ahead Logging (WAL) settings
# Left at default parameters for checkpoint frequency labs
# ============================================================
# max_wal_size = 1GB
# min_wal_size = 80MB
# checkpoint_completion_target = 0.9
EOF

echo "========================================================================="
echo " CONFIGURATION REBUILD COMPLETE! "
# Define ANSI color codes
GREEN='\033[1;32m' # 1;32m makes it Bold Green
NC='\033[0m'       # No Color (Resets the terminal)
echo " Please run the below command to restart the database:"
echo -e " Please run: ${GREEN}/usr/pgsql-16/bin/pg_ctl restart -D /var/lib/pgsql/postgres-lab01${NC} to apply changes."
echo "========================================================================="

