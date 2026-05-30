- suppose `client` wants to ssh into `server`
    - `client verify server` authenticity by saving 
        - `server`'s`/etc/ssh/ssh_host*` --->`client`'s `~/.ssh/known_hosts`
    - `server allow client` without password by saving 
        - `client`'s `~/.ssh/` ---> `server`'s`/etc/ssh/ssh_host*` 

- `.ssh/config` content
```
Host 163.13.58.231
  HostName 163.13.58.231
  User root

Host 192.168.43.33
  HostName 192.168.43.33
  User root
  Port 22
```

``` bash 
# use this to list known host
cat C:/Users/ruima/.ssh/known_hosts

# delete known host, the must be in [ip]:port format
ssh-keygen -R [localhost]:8822

# if username empty, will use host username
ssh -p 10022 rui@localhost

# localhost=ipv6, need to use 127.0.0.1 to use the ipv4 version
ssh-keyscan -p 8822 127.0.0.1 

```
