FROM ubuntu:18.04


RUN apt-get update -y && \
    apt-get install -y python3-pip python3-dev

# We copy just the requirements.txt first to leverage Docker cache

WORKDIR /app

RUN pip3 install bane

COPY test-attack.py test-attack.py

RUN adduser --system --no-create-home nonroot && chown -R nonroot /app

# ... do the various install and setup steps as root ...

# Specify metadata for when you run the container
USER nonroot

CMD ["python3", "test-attack.py" ]
