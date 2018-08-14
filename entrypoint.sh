
#!/bin/bash
# Compile for specific board-type
if [ -f /sketch/board.txt ]; then
  BOARD=$(cat /sketch/board.txt)
else
  BOARD="arduino:avr:uno"
fi

# Install dependencies
if [ -f /sketch/libraries.txt ]; then
  LIBRARIES=$(paste -s -d, /sketch/libraries.txt)
  /ide/arduino --install-library $LIBRARIES
fi

# Now compile
for sketch in `find /sketch -name '*.ino'`
do
  arduino-builder \
    -hardware /ide/hardware \
    -tools /ide/hardware/tools/avr \
    -tools /ide/tools-builder \
    -libraries /ide/libraries \
    -fqbn $BOARD \
    $sketch
done