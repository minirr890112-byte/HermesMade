#!/bin/bash
# =============================================================================
# Hermes Pain Point Terminal Hints for r/learnpython
# Generated: 2026-05-01T23:12:24Z
# Source: Reddit r/learnpython scan - 73 posts, 29 classified pain points
# Category breakdown: Tooling(9) Environment(8) Docs(6) API(4) UX(2)
# Paste these into your ~/.zshrc or ~/.bashrc
# =============================================================================


# ─── Fix #1: int too large to convert to float ───
# Category: Environment | Reddit: https://reddit.com/r/learnpython/comments/1sx8x7b/
# Score: 2 | Comments: 16 | Design: auto-paste-hint
_hermes_fix_int_too_large_to_convert_to_float() {
    local err="$1"
    case "$err" in
        *"int too large to convert to float"*)
            cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════╗
║  💡 Python integer too large for float conversion       ║
╠══════════════════════════════════════════════════════════╣
║  Happens because ** and float literals (1e6) force      ║
║  Python to convert huge ints to float.                  ║
║                                                          ║
║  🔧 Quick fixes:                                         ║
║  1. Use integer division // instead of **               ║
║  2. Replace 1e6 with 1000000 (pure int)                 ║
║  3. Use decimal.Decimal from the start:                 ║
║     from decimal import Decimal                         ║
║     Decimal('1000000') * Decimal('2')**Decimal('50')   ║
║                                                          ║
║  📋 Copied to clipboard: from decimal import Decimal    ║
╚══════════════════════════════════════════════════════════╝
HERMES_HINT
            echo "from decimal import Decimal" | pbcopy 2>/dev/null ||             echo "from decimal import Decimal" | xclip -selection clipboard 2>/dev/null || true
            ;;
    esac
}


# ─── Fix #2: Can't install scikit-fmm package ───
# Category: Environment | Reddit: https://reddit.com/r/learnpython/comments/1t0z0ba/
# Score: 1 | Comments: 4 | Design: auto-paste-hint
_hermes_fix_cant_install_scikit-fmm_package() {
    local err="$1"
    case "$err" in
        *"Unknown compiler"*|*"metadata-generation-failed"*)
            cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════╗
║  💡 Missing C++ compiler on Windows - pip install fail  ║
╠══════════════════════════════════════════════════════════╣
║  scikit-fmm needs a C++ compiler to build from source.  ║
║                                                          ║
║  🔧 Fix (pick one):                                      ║
║  1. Install VS Build Tools:                             ║
║     winget install Microsoft.VisualStudio.2022.         ║
║     BuildTools --add Microsoft.VisualStudio.            ║
║     Workload.VCTools                                     ║
║  2. Use conda (bundles compilers):                      ║
║     conda install -c conda-forge scikit-fmm             ║
║  3. Pre-built wheels only:                              ║
║     pip install scikit-fmm --only-binary=:all:          ║
║                                                          ║
║  📋 Copied: conda install -c conda-forge scikit-fmm     ║
╚══════════════════════════════════════════════════════════╝
HERMES_HINT
            echo "conda install -c conda-forge scikit-fmm" | pbcopy 2>/dev/null ||             echo "conda install -c conda-forge scikit-fmm" | xclip -selection clipboard 2>/dev/null || true
            ;;
    esac
}


# ─── Fix #3: Built my first real Python script with AI help. Deployment nearly killed me. ───
# Category: Environment | Reddit: https://reddit.com/r/learnpython/comments/1sx19rh/
# Score: 0 | Comments: 11 | Design: one-click-button
_hermes_fix_built_my_first_real_python_script_with_a() {
    local err="$1"
    case "$err" in
        *"dependency error"*|*"broken environment"*)
            cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════╗
║  💡 Keep your Python script running 24/7 on a VPS       ║
╠══════════════════════════════════════════════════════════╣
║  🔧 systemd service - save as /etc/systemd/system/      ║
║     myscript.service:                                    ║
║                                                          ║
║  [Unit]                                                  ║
║  Description=My Python App                              ║
║  After=network.target                                    ║
║  [Service]                                               ║
║  User=ubuntu                                            ║
║  WorkingDirectory=/home/ubuntu/app                      ║
║  ExecStart=/home/ubuntu/app/venv/bin/python main.py     ║
║  Restart=always                                         ║
║  RestartSec=10                                          ║
║  [Install]                                               ║
║  WantedBy=multi-user.target                             ║
║                                                          ║
║  Then: sudo systemctl daemon-reload &&                  ║
║        sudo systemctl enable --now myscript              ║
║                                                          ║
║  📋 Deploy cmd copied to clipboard                      ║
╚══════════════════════════════════════════════════════════╝
HERMES_HINT
            cat << 'DEPLOY_SCRIPT' | pbcopy 2>/dev/null || xclip -selection clipboard 2>/dev/null || true
cd ~/app && git pull && source venv/bin/activate && pip install -r requirements.txt && sudo systemctl restart myscript && echo "Deployed!"
DEPLOY_SCRIPT
            ;;
    esac
}


# ─── Fix #4: Problem with PYQT5 widgets ───
# Category: Environment | Reddit: https://reddit.com/r/learnpython/comments/1sxoimo/
# Score: 2 | Comments: 7 | Design: auto-paste-hint
_hermes_fix_problem_with_pyqt5_widgets() {
    local err="$1"
    case "$err" in
        *"ModuleNotFoundError"*"PyQt5"*)
            cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════╗
║  💡 PyQt5 installed but Python can't find it            ║
╠══════════════════════════════════════════════════════════╣
║  You likely installed PyQt5 outside your venv.           ║
║                                                          ║
║  🔧 Diagnosis:                                           ║
║  $ which python              # is this your venv?       ║
║  $ pip list | grep -i pyqt   # is PyQt5 here?           ║
║                                                          ║
║  🔧 Fix:                                                 ║
║  $ source /path/to/venv/bin/activate                    ║
║  $ pip install PyQt5                                     ║
║                                                          ║
║  Or system-wide on Debian/RPi:                          ║
║  $ sudo apt install python3-pyqt5                       ║
║                                                          ║
║  📋 Copied: pip install PyQt5                           ║
╚══════════════════════════════════════════════════════════╝
HERMES_HINT
            echo "pip install PyQt5" | pbcopy 2>/dev/null ||             echo "pip install PyQt5" | xclip -selection clipboard 2>/dev/null || true
            ;;
    esac
}


# ─── Fix #5: Django and Apache/Nginx ───
# Category: Environment | Reddit: https://reddit.com/r/learnpython/comments/1sxfe48/
# Score: 4 | Comments: 9 | Design: auto-paste-hint
_hermes_fix_django_and_apache/nginx() {
    local err="$1"
    case "$err" in
        *"django"*"apache"*|*"django"*"nginx"*)
            cat << 'HERMES_HINT'

╔══════════════════════════════════════════════════════════╗
║  💡 Django + Nginx - No venv activation headaches       ║
╠══════════════════════════════════════════════════════════╣
║  Unlike PHP, Python needs a WSGI server between Django  ║
║  and Nginx. Use gunicorn pointing to venv Python:       ║
║                                                          ║
║  $ pip install gunicorn                                  ║
║  $ /path/to/venv/bin/gunicorn myproject.wsgi:app \      ║
║        --bind 127.0.0.1:8000 --daemon                   ║
║                                                          ║
║  Nginx reverse proxy to gunicorn:                       ║
║  location / {                                            ║
║      proxy_pass http://127.0.0.1:8000;                  ║
║      proxy_set_header Host $host;                       ║
║  }                                                       ║
║                                                          ║
║  📋 Copied: pip install gunicorn                        ║
╚══════════════════════════════════════════════════════════╝
HERMES_HINT
            echo "pip install gunicorn" | pbcopy 2>/dev/null ||             echo "pip install gunicorn" | xclip -selection clipboard 2>/dev/null || true
            ;;
    esac
}


# ─── Installation ───
# Source this file in your shell rc:
#   echo "source ~/hermes_pain_hints.sh" >> ~/.zshrc   # zsh
#   echo "source ~/hermes_pain_hints.sh" >> ~/.bashrc  # bash
#
# To trigger manually: source ~/hermes_pain_hints.sh && _hermes_fix_int_too_large_to_convert_to_float "int too large to convert to float"
#
# Meta: Generated 2026-05-01T23:12:24Z | 5 hints | r/learnpython | Hermes Agent
