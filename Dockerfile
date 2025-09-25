FROM docker.io/library/python:3.13-alpine

LABEL org.opencontainers.image.title="bitcoin-prometheus-exporter"
LABEL org.opencontainers.image.description="Prometheus exporter for bitcoin nodes"

# Dependencies for python-bitcoinlib and sanity check.
RUN apk --no-cache add \
      binutils \
      libressl-dev && \
    python -c "import ctypes, ctypes.util; ctypes.cdll.LoadLibrary('/usr/lib/libssl.so')"

RUN pip install --no-cache-dir \
        prometheus_client \
        python-bitcoinlib \
        riprova

RUN mkdir -p /monitor
COPY --chmod=555 ./bitcoind-monitor.py /monitor

USER nobody

CMD ["/monitor/bitcoind-monitor.py"]
