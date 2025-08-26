#!/usr/bin/env bash
set -euo pipefail
mkdir -p "${WORKSPACE}/.ssh"
chmod 700 "${WORKSPACE}/.ssh"
> "${WORKSPACE}/.ssh/known_hosts"

cp "$EDGE_KEY"    "${WORKSPACE}/.ssh/edge_gateway_key.pem"
cp "$BACKEND_KEY" "${WORKSPACE}/.ssh/backend_key.pem"
cp "$FRONTEND_KEY"${WORKSPACE}/.ssh/frontend_key.pem"
chmod 600 "${WORKSPACE}"/.ssh/*.pem
