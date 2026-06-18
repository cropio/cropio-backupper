#!/usr/bin/env bash
# Continuous sync loop: run one full download pass, sleep, repeat forever.
# A failed pass is logged and retried after the sleep — it does not stop the loop.
#
# DOWNLOAD_SLEEP — seconds to wait between passes (default 3600 = 1 hour).
#   e.g. 1800 = 30 min, 900 = 15 min, 86400 = once a day.
set -uo pipefail

SLEEP_SECONDS="${DOWNLOAD_SLEEP:-3600}"

echo "[run-loop] starting continuous sync — sleep between passes: ${SLEEP_SECONDS}s"

while true; do
  echo "[run-loop] === pass started ==="
  if bundle exec rake download_data; then
    echo "[run-loop] === pass finished OK ==="
  else
    echo "[run-loop] === pass FAILED (exit $?); retrying after sleep ==="
  fi
  echo "[run-loop] sleeping ${SLEEP_SECONDS}s before next pass..."
  sleep "${SLEEP_SECONDS}"
done
