#!/bin/bash
# ============================================
# install_java.sh - Java Installation Script
# Author: Farah Naaz
# Description: Downloads and installs OpenJDK 1.8,
#              adds java to PATH, logs all steps
# ============================================

LOG_DIR="/opt/logs"
LOG_FILE="$LOG_DIR/script_logs.log"

# Create log directory
mkdir -p "$LOG_DIR"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "===== Java Installation Script Started ====="

# Step a: Download OpenJDK 1.8
log "Step 1: Downloading OpenJDK 1.8..."
sudo apt-get update -y >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    log "Package list updated successfully."
else
    log "ERROR: Failed to update package list."
    exit 1
fi

# Step b: Install Java
log "Step 2: Installing OpenJDK 1.8..."
sudo apt-get install -y openjdk-8-jdk >> "$LOG_FILE" 2>&1
if [ $? -eq 0 ]; then
    log "OpenJDK 1.8 installed successfully."
else
    log "ERROR: Java installation failed."
    exit 1
fi

# Step c: Set JAVA_HOME and update PATH
log "Step 3: Setting JAVA_HOME and updating PATH..."
JAVA_PATH=$(update-alternatives --list java | grep "java-8" | head -1)

if [ -z "$JAVA_PATH" ]; then
    JAVA_PATH="/usr/lib/jvm/java-8-openjdk-amd64/bin/java"
fi

JAVA_HOME_DIR=$(dirname $(dirname "$JAVA_PATH"))

# Add to current session
export JAVA_HOME="$JAVA_HOME_DIR"
export PATH="$PATH:$JAVA_HOME/bin"

# Add to .bashrc for persistence
if ! grep -q "JAVA_HOME" ~/.bashrc; then
    echo "" >> ~/.bashrc
    echo "# Java configuration added by install_java.sh" >> ~/.bashrc
    echo "export JAVA_HOME=$JAVA_HOME_DIR" >> ~/.bashrc
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> ~/.bashrc
    log "JAVA_HOME added to .bashrc: $JAVA_HOME_DIR"
else
    log "JAVA_HOME already exists in .bashrc. Skipping."
fi

source ~/.bashrc

# Step d: Verify installation
log "Step 4: Verifying Java installation..."
JAVA_VERSION=$(java -version 2>&1)
log "Java version: $JAVA_VERSION"

log "===== Java Installation Completed Successfully ====="
log "Log file saved at: $LOG_FILE"
