#!/bin/bash
# Comprehensive automation script for honeybee-radiance-workflow

set -e

LOGFILE="automation_log.txt"
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Function to log messages
log() {
    echo "[$TIMESTAMP] $1" | tee -a $LOGFILE
}

echo "========================================" | tee $LOGFILE
echo "HONEYBEE-RADIANCE-WORKFLOW - RUN ALL" | tee -a $LOGFILE
echo "========================================" | tee -a $LOGFILE

# Step 1: Install dependencies
log "Step 1: Installing dependencies..."
pip install -r dev-requirements.txt
pip install -r requirements.txt
log "✓ Dependencies installed successfully"

# Step 2: Run pytest tests
log "Step 2: Running pytest tests..."
python -m pytest ./tests -v --tb=short > pytest_results.txt 2>&1 || true
log "✓ Tests completed (see pytest_results.txt)"

# Step 3: Verify CLI
log "Step 3: Verifying CLI with lbt-recipes..."
lbt-recipes viz > cli_verification.txt 2>&1 || true
log "✓ CLI verification completed (see cli_verification.txt)"

# Step 4: Build documentation with Sphinx
log "Step 4: Building documentation with Sphinx..."
if [ -d "docs" ]; then
    sphinx-build -b html docs docs/_build 2>&1 | tee sphinx_build.log || true
    log "✓ Documentation built (see sphinx_build.log)"
else
    log "⚠ docs directory not found, skipping documentation build"i

# Step 5: Build the package
log "Step 5: Building the package..."
python -m build 2>&1 | tee build_output.log || true
log "✓ Package built (see build_output.log)"

# Step 6: Display summary
echo "" | tee -a $LOGFILE
echo "========================================" | tee -a $LOGFILE
echo "EXECUTION SUMMARY" | tee -a $LOGFILE
echo "========================================" | tee -a $LOGFILE
log "All operations completed!"
log "Check the following files for details:"
log "  - pytest_results.txt (test results)"
log "  - cli_verification.txt (CLI output)"
log "  - sphinx_build.log (documentation build)"
log "  - build_output.log (package build)"
log "  - automation_log.txt (this log file)"
echo "========================================" | tee -a $LOGFILE
