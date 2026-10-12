echo "Restart the sleep monitor so it watches for resumes"

# The lock no longer polls the panels while it shows a video; the sleep
# monitor now starts a watcher that tells it when the machine wakes. A monitor
# started before the update keeps running the old script until its next
# suspend, so restart one that is running. Nothing is sleeping during an update,
# so dropping its inhibitor for a moment costs nothing.
systemctl --user try-restart omarchy-sleep-lock.service 2>/dev/null || true
