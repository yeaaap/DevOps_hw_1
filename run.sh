#!/usr/bin/env bash
set -euo pipefail
cd -- "$(dirname -- "$0")"

for container in lebedev-10-web lebedev-10-db; do
    if docker container inspect "$container" >/dev/null 2>&1; then
        docker rm -f "$container"
    fi
done

docker build --build-arg VERSION=2.0 -t lebedev-10/probe:2.0 .
docker volume create lebedev-10-data
docker run -d --name lebedev-10-db \
    -p 8032:3306 \
    -e MARIADB_ROOT_PASSWORD=lab \
    -e MARIADB_DATABASE=lab \
    -v lebedev-10-data:/var/lib/mysql \
    mariadb:11
docker run -d --name lebedev-10-web \
    -p 8030:5010 \
    --add-host host.docker.internal:host-gateway \
    -e MARKER=weblab \
    -e DATABASE_URL=mysql://root:lab@host.docker.internal:8032/lab \
    lebedev-10/probe:2.0

SECONDS=0
until curl -fsS -m 3 http://localhost:8030/notes >/dev/null 2>&1; do
    if (( SECONDS >= 60 )); then
        curl -sS -m 3 http://localhost:8030/notes
        exit 1
    fi
    sleep 2
done
curl -fsS http://localhost:8030/notes | python3 -m json.tool --no-ensure-ascii
