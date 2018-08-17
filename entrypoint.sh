
#!/bin/bash
# Compile for specific board-type
if [ -f /sketch/board.txt ]; then
  BOARD=$(cat /sketch/board.txt)
else
  BOARD="arduino:avr:uno"
fi
echo "Board is: $BOARD"

# Install dependencies
mkdir -p ~/Arduino/libraries
if [ -f /sketch/libraries.txt ]; then
  LIBRARIES=$(paste -s -d, /sketch/libraries.txt)
  echo "Installing: $LIBRARIES"
  /ide/arduino --install-library $LIBRARIES
fi

# Now compile any sketches
for sketch in `find /sketch -name '*.ino'`
do
  arduino-builder \
    -compile \
    -hardware /ide/hardware \
    -tools /ide/hardware/tools/avr \
    -tools /ide/tools-builder \
    -libraries /ide/libraries \
    -libraries ~/Arduino/libraries \
    -fqbn $BOARD \
    $sketch
done