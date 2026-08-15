#!/usr/bin/env bash

# ============================================
# Termux Dependency Installer - Optimized
# ============================================

set -e  # Error হলে থামবে

# Directories
LOG_DIR="$PWD/logs"
DB_DIR="$PWD/db"
ILOG="$LOG_DIR/install.log"
ERROR_LOG="$LOG_DIR/error.log"

# Colors for better output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
WHITE='\033[1;37m'
BOLD='\033[1m'
NC='\033[0m' # No Color

mkdir -p "$LOG_DIR" "$DB_DIR"
> "$ILOG"    # Clear log
> "$ERROR_LOG"

# ============================================
# Banner Function
# ============================================

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║                                                          ║"
    echo "║    __  __     _    _    _ _   ___                       ║"
    echo "║    |  \/  |___| |_ (_)__| (_) | _ )_ _ ___             ║"
    echo "║    | |\/| / -_) ' \| / _\` | | | _ \ '_/ _ \\            ║"
    echo "║    |_|  |_\___|_||_|_\__,_|_| |___/_| \___/            ║"
    echo "║                                                          ║"
    echo "║    ╔══════════════════════════════════════════════════╗  ║"
    echo "║    ║       Termux Dependency Installer v2.0         ║  ║"
    echo "║    ╚══════════════════════════════════════════════════╝  ║"
    echo "║                                                          ║"
    echo "║    🔧 Installing: Python, PHP, Pip Packages             ║"
    echo "║    📦 Extra: curl, wget, git, nano, tree, htop, jq     ║"
    echo "║                                                          ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${YELLOW}[!] Press Ctrl+C to cancel at any time${NC}\n"
    sleep 2
}

# ============================================
# Helper Functions
# ============================================

print_status() {
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓${NC} $1 - Installed"
        echo "$1 - Installed" >> "$ILOG"
    else
        echo -e "${RED}✗${NC} $1 - Failed!"
        echo "$1 - Failed!" >> "$ILOG"
        echo "$1 - Failed at $(date)" >> "$ERROR_LOG"
    fi
}

print_header() {
    echo -e "\n${BLUE}════════════════════════════════════════${NC}"
    echo -e "${MAGENTA}${BOLD}$1${NC}"
    echo -e "${BLUE}════════════════════════════════════════${NC}\n"
}

print_progress() {
    echo -ne "${YELLOW}[•]${NC} $1 ... "
}

check_internet() {
    echo -e "${YELLOW}[*] Checking Internet Connection...${NC}"
    if ping -c 1 8.8.8.8 &> /dev/null || curl -s --max-time 5 https://google.com &> /dev/null; then
        echo -e "${GREEN}✓ Internet Connected${NC}\n"
        return 0
    else
        echo -e "${RED}✗ No Internet Connection!${NC}"
        echo "No Internet - Exiting" >> "$ERROR_LOG"
        exit 1
    fi
}

update_packages() {
    echo -e "${YELLOW}[*] Updating Package Lists...${NC}"
    apt update -y &>> "$ILOG"
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✓ Package lists updated${NC}\n"
    else
        echo -e "${RED}✗ Failed to update!${NC}"
        exit 1
    fi
}

upgrade_packages() {
    echo -e "${YELLOW}[*] Upgrading existing packages...${NC}"
    apt upgrade -y &>> "$ILOG"
    echo -e "${GREEN}✓ Upgrade completed${NC}\n"
}

# ============================================
# Installation Functions
# ============================================

install_apt_pkg() {
    local pkg=$1
    print_progress "Installing $pkg"
    apt install -y "$pkg" &>> "$ILOG"
    print_status "$pkg"
}

install_pip_pkg() {
    local pkg=$1
    print_progress "Installing $pkg (pip)"
    pip install -U "$pkg" &>> "$ILOG"
    print_status "$pkg"
}

install_python() {
    print_header "🐍 Installing Python"
    
    # Check if Python already installed
    if command -v python3 &> /dev/null; then
        echo -e "${GREEN}✓ Python already installed: $(python3 --version)${NC}"
    else
        install_apt_pkg "python3"
    fi
    
    # Install pip if not present
    if ! command -v pip &> /dev/null && ! command -v pip3 &> /dev/null; then
        install_apt_pkg "python3-pip"
    else
        echo -e "${GREEN}✓ Pip already installed${NC}"
    fi
    
    # Upgrade pip
    print_progress "Upgrading pip"
    pip install --upgrade pip &>> "$ILOG"
    print_status "pip (upgraded)"
}

install_php() {
    print_header "🐘 Installing PHP"
    
    if command -v php &> /dev/null; then
        echo -e "${GREEN}✓ PHP already installed: $(php -v | head -1)${NC}"
    else
        install_apt_pkg "php"
    fi
}

install_python_packages() {
    print_header "📦 Installing Python Packages"
    
    local packages=("requests" "packaging" "psutil" "colorama" "tqdm" "pyfiglet" "termcolor")
    
    for pkg in "${packages[@]}"; do
        install_pip_pkg "$pkg"
    done
}

install_extra_tools() {
    print_header "🛠️  Installing Extra Tools"
    
    local extra_pkgs=("curl" "wget" "git" "nano" "tree" "htop" "openssl" "jq" "figlet" "toilet")
    
    for pkg in "${extra_pkgs[@]}"; do
        if ! command -v "$pkg" &> /dev/null; then
            install_apt_pkg "$pkg"
        else
            echo -e "${GREEN}✓${NC} $pkg already installed"
        fi
    done
}

setup_storage() {
    print_header "📁 Setting Up Storage"
    
    if [ -d "$HOME/storage" ]; then
        echo -e "${GREEN}✓ Storage already accessible${NC}"
    else
        echo -e "${YELLOW}[*] Granting storage permission...${NC}"
        termux-setup-storage &>> "$ILOG"
        echo -e "${GREEN}✓ Storage setup complete (restart may be needed)${NC}"
    fi
}

setup_bashrc() {
    print_header "⚙️  Setting Up .bashrc"
    
    local BASHRC="$HOME/.bashrc"
    local ALIASES="
# ==========================================
# Termux Custom Aliases
# ==========================================

# ---------- Basic Commands ----------
alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias cls='clear'
alias c='clear'
alias py='python3'
alias p='python3'

# ---------- Python ----------
alias pipup='pip list --outdated | cut -d\" \" -f1 | xargs -n1 pip install -U'
alias venv='python3 -m venv venv'
alias activate='source venv/bin/activate'

# ---------- Termux ----------
alias termux-reload='termux-reload-settings'
alias termux-wake='termux-wake-lock'
alias termux-sleep='termux-wake-unlock'

# ---------- System ----------
alias update='apt update && apt upgrade -y'
alias install='apt install'
alias remove='apt remove'
alias search='apt search'
alias clean='apt clean && apt autoremove -y'

# ---------- Custom PATH ----------
export PATH=\$HOME/.local/bin:\$PATH

# ---------- Custom Prompt ----------
export PS1='\[\033[1;32m\]\u\[\033[0m\]@\[\033[1;34m\]\h\[\033[0m\]:\[\033[1;33m\]\w\[\033[0m\]\$ '

# ---------- Welcome Message ----------
echo -e \"\033[1;32mWelcome to Termux, \$(whoami)! 🚀\033[0m\"
echo -e \"\033[1;36mType 'll' for detailed listing | 'update' to update packages\033[0m\"
"
    
    if ! grep -q "Termux Custom Aliases" "$BASHRC" 2>/dev/null; then
        echo "$ALIASES" >> "$BASHRC"
        echo -e "${GREEN}✓ .bashrc updated with useful aliases${NC}"
    else
        echo -e "${GREEN}✓ .bashrc already configured${NC}"
    fi
}

show_installed_versions() {
    echo -e "\n${YELLOW}📊 Installed Versions:${NC}"
    echo "────────────────────────────────────────────────────────"
    
    # Python
    if command -v python3 &> /dev/null; then
        echo -e "🐍 ${GREEN}Python${NC}  : $(python3 --version 2>&1 | cut -d' ' -f2)"
    fi
    
    # Pip
    if command -v pip &> /dev/null; then
        echo -e "📦 ${GREEN}Pip${NC}     : $(pip --version | cut -d' ' -f2)"
    fi
    
    # PHP
    if command -v php &> /dev/null; then
        echo -e "🐘 ${GREEN}PHP${NC}      : $(php -v 2>&1 | head -1 | cut -d' ' -f2)"
    fi
    
    # Git
    if command -v git &> /dev/null; then
        echo -e "📚 ${GREEN}Git${NC}      : $(git --version | cut -d' ' -f3)"
    fi
    
    echo "────────────────────────────────────────────────────────"
}

show_python_packages() {
    echo -e "\n${YELLOW}📦 Installed Python Packages:${NC}"
    echo "────────────────────────────────────────────────────────"
    pip list --format=columns 2>/dev/null | grep -E "requests|packaging|psutil|colorama|tqdm|pyfiglet|termcolor" || echo "Run: pip list"
    echo "────────────────────────────────────────────────────────"
}

show_tools() {
    echo -e "\n${YELLOW}🔧 Installed Tools:${NC}"
    echo "────────────────────────────────────────────────────────"
    local tools=("curl" "wget" "git" "nano" "tree" "htop" "openssl" "jq" "figlet" "toilet")
    for tool in "${tools[@]}"; do
        if command -v "$tool" &> /dev/null; then
            echo -e "✅ ${GREEN}$tool${NC}"
        fi
    done
    echo "────────────────────────────────────────────────────────"
}

show_summary() {
    print_header "📋 Installation Summary"
    
    echo -e "${GREEN}✅ All installations completed successfully!${NC}\n"
    
    show_installed_versions
    show_python_packages
    show_tools
    
    echo -e "\n${YELLOW}📄 Log Files:${NC}"
    echo "────────────────────────────────────────────────────────"
    echo -e "📝 Main Log    : $ILOG"
    echo -e "❌ Error Log   : $ERROR_LOG"
    
    echo -e "\n${GREEN}💡 Quick Tips:${NC}"
    echo "────────────────────────────────────────────────────────"
    echo "• 🔄 Restart Termux for all changes to take effect"
    echo "• 📖 Check logs: cat $ERROR_LOG"
    echo "• ⬆️  Update all pip packages: pipup"
    echo "• 🐍 Run Python: python3 or py"
    echo "• 📁 Access storage: cd ~/storage"
    echo "• 🔧 Update system: update"
    
    echo -e "\n${CYAN}✨ Happy Coding with Termux! ✨${NC}"
}

# ============================================
# Main Installation Process
# ============================================

main() {
    # Show Banner
    show_banner
    
    # Step 1: Check Internet
    check_internet
    
    # Step 2: Update & Upgrade
    update_packages
    upgrade_packages
    
    # Step 3: Install Python
    install_python
    
    # Step 4: Install PHP
    install_php
    
    # Step 5: Install Python Packages
    install_python_packages
    
    # Step 6: Extra Tools (Optional)
    echo -e "\n${YELLOW}[?] Install extra tools? (curl, wget, git, nano, tree, htop, jq, figlet)${NC}"
    echo -e "${YELLOW}[?] Press Enter to skip or type 'y' to install${NC}"
    read -t 10 -p "> " choice || choice="n"
    
    if [[ "$choice" == "y" || "$choice" == "Y" ]]; then
        install_extra_tools
    else
        echo -e "${BLUE}⏭️  Skipping extra tools${NC}"
    fi
    
    # Step 7: Setup Storage
    setup_storage
    
    # Step 8: Setup .bashrc
    setup_bashrc
    
    # Step 9: Show Summary
    show_summary
    
    # Final message
    echo -e "\n${GREEN}═══════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}${BOLD}🎉 Installation Completed Successfully! 🎉${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════${NC}\n"
    
    echo -e "${CYAN}📁 Log Saved: $ILOG${NC}"
}

# ============================================
# Run Main
# ============================================

# Trap Ctrl+C
trap 'echo -e "\n${RED}❌ Installation cancelled by user${NC}"; exit 1' INT

# Run with error handling
if main; then
    exit 0
else
    echo -e "${RED}❌ Installation failed! Check error log: $ERROR_LOG${NC}"
    exit 1
fi
