# PENOS Login initialization
if [ -f /etc/penos/aliases.sh ]; then
    . /etc/penos/aliases.sh
fi

# Auto-run update check in background occasionally
#(pen update check &) >/dev/null 2>&1
