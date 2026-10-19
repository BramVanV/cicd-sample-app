#!/bin/bash
set -euo pipefail

# Create a fresh build directory and remove it when the script exits.
BUILD_DIR=$(mktemp -d)
trap 'rm -rf "$BUILD_DIR"' EXIT

mkdir -p "$BUILD_DIR/templates" "$BUILD_DIR/static"

cp sample_app.py "$BUILD_DIR/"
cp -r templates/. "$BUILD_DIR/templates/"
cp -r static/. "$BUILD_DIR/static/"

cat > "$BUILD_DIR/Dockerfile" <<'EOF'
FROM python
RUN pip install flask
COPY static /home/myapp/static/
COPY templates /home/myapp/templates/
COPY sample_app.py /home/myapp/
EXPOSE 5050
CMD ["python", "/home/myapp/sample_app.py"]
EOF

# Build successfully before replacing the running application.
docker build -t sampleapp "$BUILD_DIR"

if docker container inspect samplerunning >/dev/null 2>&1; then
    docker rm -f samplerunning
fi

docker run -d \
    -p 5050:5050 \
    --name samplerunning \
    sampleapp

docker ps