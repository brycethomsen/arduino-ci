FROM golang:1.10.3-stretch as builder
ENV ARDUINO_VER=1.8.5
WORKDIR /build
RUN apt-get update && apt-get install xz-utils -y
RUN go get github.com/go-errors/errors && \
    go get github.com/stretchr/testify && \
    go get github.com/jstemmer/go-junit-report && \
    go get -u github.com/arduino/go-properties-map && \
    go get -u github.com/arduino/go-timeutils && \
    go get google.golang.org/grpc && \
    go get github.com/golang/protobuf/proto && \
    go get golang.org/x/net/context && \
    go get github.com/fsnotify/fsnotify && \
    go get github.com/arduino/arduino-builder && \
    go build github.com/arduino/arduino-builder/arduino-builder
RUN curl -s -o arduino-${ARDUINO_VER}-linux64.tar.xz https://downloads.arduino.cc/arduino-${ARDUINO_VER}-linux64.tar.xz && \
    tar -xf arduino-${ARDUINO_VER}-linux64.tar.xz && \
    mv arduino-${ARDUINO_VER} ide
RUN mkdir -p ide/hardware/esp8266com && \
    git clone https://github.com/esp8266/Arduino.git ide/hardware/esp8266com/esp8266 && \
    cd ide/hardware/esp8266com/esp8266/tools && python get.py

FROM launcher.gcr.io/google/debian9
WORKDIR /sketch
COPY --from=builder /build/ide /ide
COPY --from=builder /build/arduino-builder /usr/local/bin/arduino-builder
COPY entrypoint.sh /tmp/entrypoint.sh
ENTRYPOINT [ "/bin/bash", "-c", "/tmp/entrypoint.sh" ]
