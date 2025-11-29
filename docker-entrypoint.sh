#!/bin/bash
set -e

VENV_PATH="/home/appuser/opt/.venv"

# If the venv exists, source its activate script for interactive shells
if [ -f "$VENV_PATH/bin/activate" ]; then
  # shellcheck disable=SC1091
  . "$VENV_PATH/bin/activate"
  export VIRTUAL_ENV="$VENV_PATH"
  export PATH="$VIRTUAL_ENV/bin:$PATH"
fi

# Execute the provided command
exec "$@"
