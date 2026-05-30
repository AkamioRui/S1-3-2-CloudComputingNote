# about Service
- location:
    - (custom)          *`/etc/systemd/system/`service_name`.service`*
    - (debian package)  *`/lib/systemd/system/`service_name`.service`*
    - (debian package)  *`/usr/lib/systemd/system/`service_name`.service`*
    - (user)            *`~/.config/systemd/user/`service_name`.service`*
- command:
    - `systemctl daemon-reload`
    - `systemctl start` *service_name*
    - `systemctl enable` *service_name*


# syntax
``` md
[Unit]
Description= just a label
After= just a requirement, WantedBy is when it will execute

[Service]
Type=
    -- ready is the state that trigger After
    - simple, set ready after the script is running. when finished its status is failed (because it shouldnt stop)
    - oneshot, set ready after the script finished. when finished its status is dead
    - fork, set ready after the script is running in the child process

ExecStartPre= command that's run before ExecStart, if return wrong, ExecStart wont run
ExecStart= this can be a blocking service (but it's going to be run in the background)
ExecStartPost= command that's run after service start, even when ExecStart is still blocking

RemainAfterExit=yes

[Install]
WantedBy. specify when it will start running
```






