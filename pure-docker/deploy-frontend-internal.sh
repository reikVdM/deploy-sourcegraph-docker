#!/usr/bin/env bash
set -e
source ./replicas.sh

# Description: Serves the internal Sourcegraph frontend API.
#
# Disk: 128GB / non-persistent SSD
# Network: 100mbps
# Liveness probe: n/a
# Ports exposed to other Sourcegraph services: 3090/TCP 6060/TCP
# Ports exposed to the public internet: none
#
VOLUME="$HOME/sourcegraph-docker/sourcegraph-frontend-internal-0-disk"
./ensure-volume.sh $VOLUME 100
docker run --detach \
    --name=sourcegraph-frontend-internal \
    --network=sourcegraph \
    --restart=always \
    --cpus=4 \
    --memory=8g \
    --health-cmd="wget -q 'http://127.0.0.1:3080/healthz' -O /dev/null || exit 1" \
    --health-interval=5s \
    --health-timeout=10s \
    --health-retries=3 \
    --health-start-period=300s \
    -e DEPLOY_TYPE=pure-docker \
    -e GOMAXPROCS=4 \
    -e PGHOST=pgsql \
    -e CODEINTEL_PGHOST=codeintel-db \
    -e CODEINSIGHTS_PGDATASOURCE=postgres://postgres:password@codeinsights-db:5432/postgres \
    -e SRC_GIT_SERVERS="$(addresses "gitserver-" $NUM_GITSERVER ":3178")" \
    -e SRC_SYNTECT_SERVER=http://syntect-server:9238 \
    -e SEARCHER_URL="$(addresses "http://searcher-" $NUM_SEARCHER ":3181")" \
    -e INDEXED_SEARCH_SERVERS="$(addresses "zoekt-webserver-" $NUM_INDEXED_SEARCH ":6070")" \
    -e SRC_FRONTEND_INTERNAL=sourcegraph-frontend-internal:3090 \
    -e GRAFANA_SERVER_URL=http://grafana:3000 \
    -e PROMETHEUS_URL=http://prometheus:9090 \
    -e PRECISE_CODE_INTEL_UPLOAD_BACKEND=blobstore \
    -e PRECISE_CODE_INTEL_UPLOAD_AWS_ENDPOINT=http://blobstore:9000 \
    -v $VOLUME:/mnt/cache \
    index.docker.io/sourcegraph/frontend:187572_2022-12-06_cbecc5321c7d@sha256:73e64a8636e70ebbaf7f4a3300479529294f67e8cf644cdaea02435915aec869

echo "Deployed sourcegraph-frontend-internal service"
