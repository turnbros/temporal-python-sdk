# syntax=docker/dockerfile:1
FROM python:3.8-alpine3.15 as builder

RUN apk add build-base && \
    apk add linux-headers && \
    pip install --upgrade pip && \
    pip install setuptools
COPY . /tmp/temporal-python-sdk
WORKDIR /tmp/temporal-python-sdk/
RUN python setup.py bdist_wheel && \
    pip wheel -r requirements.txt -w /tmp/wheels


FROM python:3.8-alpine3.15

COPY --from=builder /tmp/wheels /tmp/
RUN pip install --no-index --find-links=/tmp/wheels temporal_python_sdk