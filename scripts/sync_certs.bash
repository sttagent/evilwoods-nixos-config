#!/usr/bin/env bash
set -euo pipefail

# Configuration variables - edit these for your use case
LOCAL_FILE="/mnt/storage/containers/service-data/traefik/volumes/certs/acme.json"
REMOTE_HOST="root@100.92.79.106"
REMOTE_FILE="/var/lib/traefik/certs/acme.json"
SERVICE_NAME="traefik"  # Service to restart after sync
SSH_OPTIONS="-o StrictHostKeyChecking=accept-new"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if local file exists
if [[ ! -f "$LOCAL_FILE" ]]; then
    log_error "Local file does not exist: $LOCAL_FILE"
    exit 1
fi

# Calculate SHA256 of local file
log_info "Calculating SHA256 of local file: $LOCAL_FILE"
LOCAL_HASH=$(sha256sum "$LOCAL_FILE" | awk '{print $1}')
log_info "Local hash: $LOCAL_HASH"

# Calculate SHA256 of remote file
log_info "Calculating SHA256 of remote file: $REMOTE_HOST:$REMOTE_FILE"
REMOTE_HASH=$(ssh $SSH_OPTIONS "$REMOTE_HOST" "sha256sum '$REMOTE_FILE' 2>/dev/null || echo 'NOTFOUND'" | awk '{print $1}')

if [[ "$REMOTE_HASH" == "NOTFOUND" ]]; then
    log_warn "Remote file does not exist: $REMOTE_FILE"
    log_warn "Will copy local file to remote"
else
    log_info "Remote hash: $REMOTE_HASH"
fi

# Compare hashes
if [[ "$LOCAL_HASH" == "$REMOTE_HASH" ]]; then
    log_info "Files are identical. No sync needed."
    exit 0
fi

log_warn "Files are different. Syncing from local to remote..."

# Create backup of remote file if it exists
if [[ "$REMOTE_HASH" != "NOTFOUND" ]]; then
    BACKUP_FILE="${REMOTE_FILE}.backup.$(date +%Y%m%d_%H%M%S)"
    log_info "Creating backup of remote file: $BACKUP_FILE"
    ssh $SSH_OPTIONS "$REMOTE_HOST" "cp '$REMOTE_FILE' '$BACKUP_FILE'" || {
        log_error "Failed to create backup"
        exit 1
    }
fi

# Ensure remote directory exists
REMOTE_DIR=$(dirname "$REMOTE_FILE")
log_info "Ensuring remote directory exists: $REMOTE_DIR"
ssh $SSH_OPTIONS "$REMOTE_HOST" "mkdir -p '$REMOTE_DIR'" || {
    log_error "Failed to create remote directory"
    exit 1
}

# Copy file to remote
log_info "Copying file to remote..."
scp $SSH_OPTIONS "$LOCAL_FILE" "$REMOTE_HOST:$REMOTE_FILE" || {
    log_error "Failed to copy file to remote"
    exit 1
}

log_info "File synced successfully"

# Verify the sync
log_info "Verifying sync..."
REMOTE_HASH_NEW=$(ssh $SSH_OPTIONS "$REMOTE_HOST" "sha256sum '$REMOTE_FILE'" | awk '{print $1}')

if [[ "$LOCAL_HASH" != "$REMOTE_HASH_NEW" ]]; then
    log_error "Sync verification failed! Hashes don't match after copy."
    exit 1
fi

log_info "Sync verified successfully"

# Restart service
log_info "Restarting service: $SERVICE_NAME"
ssh $SSH_OPTIONS "$REMOTE_HOST" "sudo systemctl restart '$SERVICE_NAME'" || {
    log_error "Failed to restart service"
    exit 1
}

log_info "Service restarted successfully"
log_info "Certificate sync complete!"
