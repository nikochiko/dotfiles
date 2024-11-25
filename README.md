# Dotfiles

Hello, welcome to my dotfiles repository.

I have grown to believe that dotfiles is among the most unfiltered
expressions of a person. Here are mine. This repository obviously
helps me sync configuration across different machines, but I do
also hope that it comes in handy to another stranger. To that end,
I shall maintain an Index *(edit: **attempt to**)* of the dotfiles
in this repository and where that might fit on your own machine.


|    #     |             File                                |              Notes                    |
|----------|-------------------------------------------------|---------------------------------------|
|    1     |  [work.init.sh](./work.init.sh)                 | `~/.config/bin/work.init.sh` tmux-initialization script for my work needs. |
|    2     |  [AutoLaunch.scpt](./AutoLaunch.scpt)           | `~/Library/Application Support/iTerm2/Scripts/AutoLaunch.scpt` applescript to auto-run the above tmux init script when I launch `iTerm2`. |
|    3     |  [sync-internal-dns.sh](./sync-internal-dns.sh) | `~/.config/bin/sync-internal-dns.sh` I already use Tailscale + Syncthing, but for streaming I absolutely need a connection over my private network (vs Tailscale's VPN). I've put this in my `crontab` to run every minute on all my devices. It adds a `$hostname.internal` entry to `/etc/hosts` for each machine. |
