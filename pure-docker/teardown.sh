#!/usr/bin/env bash
set -e

root_dir="$(dirname "${BASH_SOURCE[0]}")"
cd "$root_dir"

source ./replicas.sh

docker rm -f node-exporter &>/dev/null || true &
docker rm -f cadvisor &>/dev/null || true &
docker rm -f caddy &>/dev/null || true &
docker rm -f sourcegraph-frontend-internal &>/dev/null || true &
docker rm -f $(addresses "sourcegraph-frontend-" $NUM_FRONTEND "") &>/dev/null || true &
docker rm -f $(addresses "gitserver-" $NUM_GITSERVER "") &>/dev/null || true &
docker rm -f grafana &>/dev/null || true
docker rm -f jaeger &>/dev/null || true
docker rm -f precise-code-intel-worker &>/dev/null || true
docker rm -f pgsql &>/dev/null || true &
docker rm -f codeintel-db &>/dev/null || true &
docker rm -f codeinsights-db &>/dev/null || true &
docker rm -f blobstore &>/dev/null || true &
docker rm -f migrator &>/dev/null || true &
docker rm -f prometheus &>/dev/null || true
docker rm -f redis-cache &>/dev/null || true &
docker rm -f redis-store &>/dev/null || true &
docker rm -f worker &>/dev/null || true &
docker rm -f $(addresses "searcher-" $NUM_SEARCHER "") &>/dev/null || true &
docker rm -f syntect-server &>/dev/null || true &
docker rm -f $(addresses "zoekt-indexserver-" $NUM_INDEXED_SEARCH "") &>/dev/null || true &
docker rm -f $(addresses "zoekt-webserver-" $NUM_INDEXED_SEARCH "") &>/dev/null || true &
docker rm -f otel-collector &>/dev/null || true &

docker network rm sourcegraph &>/dev/null || true &
wait
