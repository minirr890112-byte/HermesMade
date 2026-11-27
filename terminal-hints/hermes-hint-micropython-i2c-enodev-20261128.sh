#!/usr/bin/env bash
#
# hermes-hint-micropython-i2c-enodev-20261128.sh
# Hermes terminal hint — auto-generated 20261128
#
# Pain (from r/learnpython):
#   First MicroPython project on an ESP32 (Wokwi simulator or a real board) with an
#   SSD1306 OLED + rotary encoder. Code that worked before breaks when an I2C device
#   is added, raising:
#
#     Warning: I2C(-1, ...) is deprecated, use SoftI2C(...) instead
#     Traceback (most recent call last):
#       File "ssd1306.py", line 116, in __init__
#       File "ssd1306.py", line 61, in init_display
#     OSError: [Errno 19] ENODEV
#
# What ENODEV means:
#   "No such device" — MicroPython could not find the I2C chip at the expected
#   address. Almost always one of three causes:
#     1. The deprecated `I2C(-1, ...)` constructor selected the wrong/default bus.
#     2. The SDA/SCL pin numbers are wrong for your specific board.
#     3. Wiring: swapped SDA/SCL, missing pull-up resistors, or wrong device address.
#
# This script is DIAGNOSTIC ONLY — it scans your MicroPython source for the
# deprecated I2C(...) call, prints the SoftI2C(...) migration, and gives a pin/address
# checklist. It writes nothing and changes no files.
#
# Usage:
#   bash hermes-hint-micropython-i2c-enodev-20261128.sh [target_dir]
#
set -euo pipefail

TARGET="${1:-.}"
RED=$'\033[31m'; GRN=$'\033[32m'; YEL=$'\033[33m'; BLU=$'\033[34m'; RST=$'\033[0m'

echo "=================================================="
echo "  Hermes hint: MicroPython I2C ENODEV fix"
echo "=================================================="
echo

# ---- 1. locate .py files -----------------------------------------------------
mapfile -t PYFILES < <(find "$TARGET" -maxdepth 3 -type f -name '*.py' 2>/dev/null || true)

if [ "${#PYFILES[@]}" -eq 0 ]; then
  echo "${YEL}No .py files found under '$TARGET'.${RST}"
  echo "Point this script at the directory holding main.py / ssd1306.py:"
  echo "  bash $0 /path/to/micropython/project"
  exit 0
fi
echo "Scanning ${#PYFILES[@]} .py file(s) under '$TARGET' ..."
echo

# ---- 2. detect deprecated I2C constructor ------------------------------------
FOUND=0
while IFS= read -r line; do
  file="${line%%:*}"; rest="${line#*:}"; lineno="${rest%%:*}"
  echo "${RED}[deprecated] ${file}:${lineno}${RST}"
  FOUND=1
done < <(grep -rHn --include='*.py' -E 'I2C\([^)]*-1[^)]*\)' "$TARGET" 2>/dev/null || true)

if [ "$FOUND" -eq 0 ]; then
  echo "${GRN}No deprecated I2C(-1, ...) calls found.${RST}"
  echo "If you still get ENODEV, jump straight to the pin/address checklist below."
fi
echo

# ---- 3. migration snippet ----------------------------------------------------
echo "--------------------------------------------------"
echo "${BLU}Fix 1 — migrate to SoftI2C${RST}"
echo "--------------------------------------------------"
cat <<'EOF'
Replace:
    from machine import Pin, I2C
    i2c = I2C(-1, scl=Pin(22), sda=Pin(21))

with:
    from machine import Pin, SoftI2C
    i2c = SoftI2C(scl=Pin(22), sda=Pin(21), freq=400_000)

Then pass the same i2c object to your device driver:
    from ssd1306 import SSD1306_I2C
    oled = SSD1306_I2C(128, 64, i2c)
EOF
echo

# ---- 4. pin map --------------------------------------------------------------
echo "--------------------------------------------------"
echo "${BLU}Fix 2 — verify SDA/SCL pins for your board${RST}"
echo "--------------------------------------------------"
cat <<'EOF'
Common ESP32 defaults (check your specific board — they differ!):
  NodeMCU-32S / DevKitC v4   : SDA=21  SCL=22
  Wemos Lolin32 / Lolin32 lite: SDA=4   SCL=5   (older), or SDA=21/SCL=22 (newer)
  TTGO / OLED variants       : SDA=21  SCL=22 (often with a built-in OLED)
ESP8266 (if applicable):
  NodeMCU / Wemos D1 mini    : SDA=4 (D2)  SCL=5 (D1)

In Wokwi, the default ESP32 I2C pins are SDA=21 / SCL=22.
EOF
echo

# ---- 5. address scan ---------------------------------------------------------
echo "--------------------------------------------------"
echo "${BLU}Fix 3 — scan for the actual device address${RST}"
echo "--------------------------------------------------"
cat <<'EOF'
Run this ON the device (Thonny / mpremote) to confirm the chip answers at all:

    from machine import Pin, SoftI2C
    i2c = SoftI2C(scl=Pin(22), sda=Pin(21), freq=100_000)
    print(i2c.scan())   # expect e.g. [60] for SSD1306 (0x3C), [63] for 0x3D

  - Empty []  -> wiring / wrong pins / missing pull-ups / no power.
  - Wrong addr-> the driver may be using 0x3C but your OLED is 0x3D (or vice versa).
                 Most SSD1306 drivers accept an addr= argument; pass the scanned one.
EOF
echo

# ---- 6. optional: detect device tooling --------------------------------------
if command -v mpremote >/dev/null 2>&1; then
  echo "${GRN}Tip:${RST} mpremote is installed. Flash & run with:"
  echo "  mpremote connect /dev/ttyUSB0 run main.py"
elif command -v ampy >/dev/null 2>&1; then
  echo "${GRN}Tip:${RST} ampy is installed. Flash with:"
  echo "  ampy --port /dev/ttyUSB0 put main.py"
else
  echo "Tip: install mpremote (pip install mpremote) to flash and run code on the board."
fi
echo
echo "${GRN}Done.${RST} Fix 1 (SoftI2C) resolves the majority of ENODEV cases."
