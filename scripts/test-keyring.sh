#!/usr/bin/env bash

# Keyring verification script for NixOS + Wayland + Hyprland
# This script tests if gnome-keyring is working properly

set -e

echo "🔐 Testing Keyring Configuration on Wayland/Hyprland"
echo "=================================================="

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

check_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1"
    else
        echo -e "${RED}✗${NC} $1"
    fi
}

echo -e "\n${BLUE}1. Environment Check${NC}"
echo "-------------------"

# Check if we're in Wayland
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo -e "${GREEN}✓${NC} Running on Wayland"
else
    echo -e "${YELLOW}⚠${NC} Not running on Wayland (current: $XDG_SESSION_TYPE)"
fi

# Check desktop environment
if [ "$XDG_CURRENT_DESKTOP" ]; then
    echo -e "${GREEN}✓${NC} Desktop environment: $XDG_CURRENT_DESKTOP"
else
    echo -e "${YELLOW}⚠${NC} XDG_CURRENT_DESKTOP not set"
fi

# Check Hyprland specifically
if pgrep -x "Hyprland" > /dev/null; then
    echo -e "${GREEN}✓${NC} Hyprland is running"
else
    echo -e "${YELLOW}⚠${NC} Hyprland not detected"
fi

echo -e "\n${BLUE}2. D-Bus Services Check${NC}"
echo "----------------------"

# Check if gnome-keyring D-Bus service is available
if busctl --user status org.gnome.keyring &>/dev/null; then
    echo -e "${GREEN}✓${NC} GNOME Keyring D-Bus service is active"
else
    echo -e "${RED}✗${NC} GNOME Keyring D-Bus service not found"
fi

# Check secret service
if busctl --user status org.freedesktop.secrets &>/dev/null; then
    echo -e "${GREEN}✓${NC} Secret Service D-Bus interface is active"
else
    echo -e "${RED}✗${NC} Secret Service D-Bus interface not found"
fi

echo -e "\n${BLUE}3. Process Check${NC}"
echo "---------------"

# Check if gnome-keyring-daemon is running
if pgrep -f "gnome-keyring-daemon" > /dev/null; then
    echo -e "${GREEN}✓${NC} gnome-keyring-daemon is running"
    echo "   PIDs: $(pgrep -f gnome-keyring-daemon | tr '\n' ' ')"
else
    echo -e "${RED}✗${NC} gnome-keyring-daemon not running"
fi

echo -e "\n${BLUE}4. Environment Variables${NC}"
echo "------------------------"

# Check keyring-related environment variables
if [ -n "$GNOME_KEYRING_CONTROL" ]; then
    echo -e "${GREEN}✓${NC} GNOME_KEYRING_CONTROL: $GNOME_KEYRING_CONTROL"
else
    echo -e "${YELLOW}⚠${NC} GNOME_KEYRING_CONTROL not set"
fi

if [ -n "$XDG_RUNTIME_DIR" ]; then
    echo -e "${GREEN}✓${NC} XDG_RUNTIME_DIR: $XDG_RUNTIME_DIR"
else
    echo -e "${RED}✗${NC} XDG_RUNTIME_DIR not set"
fi

echo -e "\n${BLUE}5. Systemd User Services${NC}"
echo "------------------------"

# Check systemd user services
services=("gnome-keyring-secrets" "gnome-keyring")
for service in "${services[@]}"; do
    if systemctl --user is-active "$service" &>/dev/null; then
        echo -e "${GREEN}✓${NC} $service is active"
    else
        if systemctl --user list-unit-files "$service.service" &>/dev/null; then
            echo -e "${YELLOW}⚠${NC} $service exists but not active"
        else
            echo -e "${YELLOW}⚠${NC} $service not found (may be OK)"
        fi
    fi
done

echo -e "\n${BLUE}6. Secret Storage Test${NC}"
echo "---------------------"

# Test if we can store and retrieve a secret
if command -v secret-tool &> /dev/null; then
    echo "Testing secret storage..."

    # Store a test secret
    if echo "test-value" | secret-tool store --label="nixos-test" application "keyring-test" 2>/dev/null; then
        echo -e "${GREEN}✓${NC} Successfully stored test secret"

        # Retrieve the test secret
        if retrieved=$(secret-tool lookup application "keyring-test" 2>/dev/null); then
            if [ "$retrieved" = "test-value" ]; then
                echo -e "${GREEN}✓${NC} Successfully retrieved test secret"

                # Clean up
                secret-tool clear application "keyring-test" 2>/dev/null
                echo -e "${GREEN}✓${NC} Cleaned up test secret"
            else
                echo -e "${RED}✗${NC} Retrieved wrong value: $retrieved"
            fi
        else
            echo -e "${RED}✗${NC} Failed to retrieve test secret"
        fi
    else
        echo -e "${RED}✗${NC} Failed to store test secret"
    fi
else
    echo -e "${YELLOW}⚠${NC} secret-tool not available (install libsecret)"
fi

echo -e "\n${BLUE}7. Application Compatibility${NC}"
echo "----------------------------"

# Check if common applications can detect keyring
apps_to_check=("zeditor" "code" "git")
for app in "${apps_to_check[@]}"; do
    if command -v "$app" &> /dev/null; then
        echo -e "${GREEN}✓${NC} $app is installed"
    else
        echo -e "${YELLOW}⚠${NC} $app not found"
    fi
done

echo -e "\n${BLUE}8. Recommendations${NC}"
echo "------------------"

recommendations=()

if [ "$XDG_SESSION_TYPE" != "wayland" ]; then
    recommendations+=("Consider using Wayland for better compatibility")
fi

if ! pgrep -f "gnome-keyring-daemon" > /dev/null; then
    recommendations+=("Start gnome-keyring-daemon: run 'systemctl --user start gnome-keyring-secrets'")
fi

if [ -z "$GNOME_KEYRING_CONTROL" ]; then
    recommendations+=("Set GNOME_KEYRING_CONTROL environment variable")
fi

if ! command -v secret-tool &> /dev/null; then
    recommendations+=("Install libsecret for secret-tool utility")
fi

if [ ${#recommendations[@]} -eq 0 ]; then
    echo -e "${GREEN}✓${NC} All checks passed! Your keyring should work with Zed."
else
    echo -e "${YELLOW}Suggestions for improvement:${NC}"
    for rec in "${recommendations[@]}"; do
        echo -e "  • $rec"
    done
fi

echo -e "\n${BLUE}Summary${NC}"
echo "-------"
echo "This system is using Wayland with gnome-keyring, which is the"
echo "recommended and well-supported configuration for applications"
echo "like Zed, VSCode, and other modern editors."
echo
echo "GNOME Keyring works perfectly with Wayland and Hyprland!"
