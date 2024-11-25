#!/bin/zsh

WORKSPACE="$HOME/work/gooey-server"
GUI_WORKSPACE="$HOME/work/gooey-gui"

tmux new-session -A -s work -n 'ƛ Code Mode' \; \
	send-keys "cd $WORKSPACE" C-m \; \
	send-keys "code ." C-m \; \
	split-window -h \; \
	send-keys "cd $WORKSPACE" C-m \; \
	new-window -n '👾 API' \; \
	send-keys "cd $WORKSPACE" C-m \; \
	send-keys "poetry run uvicorn server:app --host 127.0.0.1 --port 8000 --reload" C-m \; \
	new-window -n '🏃 Workers' \; \
	send-keys "cd $WORKSPACE" C-m \; \
	send-keys "poetry run celery -A celeryapp worker -P threads -c 16 -l DEBUG" C-m \; \
	new-window -n '🎨 GUI' \; \
	send-keys "cd $GUI_WORKSPACE" C-m \; \
	send-keys "env PORT=3000 pnpm run dev" C-m \; \
	new-window -n '🛡️ Admin' \; \
	send-keys "cd $WORKSPACE" C-m \; \
	send-keys "poetry run python manage.py runserver" C-m \; \
	new-window -n '🐳 Containers' \; \
	send-keys "cd $WORKSPACE" C-m \; \
	send-keys "orbctl status" C-m \; \
	send-keys '[[ $? = 1 ]] && orbctl start' C-m \; \
	send-keys 'while [ "$(orbctl status)" != "Running" ]; do sleep 1; done' C-m \; \
	send-keys "docker compose -f docker-compose.dev.yml up" C-m \; \
	select-window -t 0
