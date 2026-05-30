# QQQQ
- EntryPoint: bash, cmd: -c server_daemon. with this can I run -it 
- if I run podman in the bg, why does no stdout?
- 

# installation
``` sh
apt install podman podman-compose # the core module
apt install podman-docker # opt, so that we can use docker syntax
```
# docker standard command
> image
- `docker images`
- `docker rmi` *image*:*tag*
- `docker pull $image:$tag` 
    - `/etc/containers/registries.conf.d/shortnames.conf` to see image list (not exhaustive) in 
    - `podman search --list-tags` *resolved_alias_of_image* to see tag of that image
        - hub.docker.com/_/OS
- `docker build` **?**

> container
- `docker ps --all` 
- `docker rm` *cont_id* 
- `docker run -it` *image*:*tag* `bash`
    - *`-i`* keep container STDIN open, (only in `podman run` not `start`) and attach stdin -> container
    - *`-t`* attach a TTY (bash need TTY and need STDIN to be open )
    - this gives it a TTY. if not, you cant attach to it, even with `start -ia`, since that bash doesnt get a tty
- `docker run `*image*:*tag*
    - `bash` = *cmd_overide* overwrite the default command 
        - when started, immediately run "EntryPoint Cmd", both can be seen via `docker inspect`
    - *`--rm`* remove container after exit
    - *`--name` $cont_name* 
    - *`-d`* ran in the background, 
        - by default, container run in the foreground. so running a server "app container" this way will take your tty and block it 
    - *`--init`* run tinit, useful for being able to use ctrl+C
    
    - *`--network` driver* 
    - *`-p` host_port:cont_port*.
        - *`-P`* expose all EXPOSE port to random host port
    - *`-e` key=value* 
    - *`-v` $host_path:$cont_path*.   
        - normal`run` root own this folder
        - sudo  `run` cont_user own this folder

> container 2
- `docker start` *cont_id* 
    - *-ia* interactive + attach
- `docker attach` *cont_id*
    - ctrl+Q to quit
- `docker stop` *cont_id*
    - if a container is interactive, it stop when you attach then `exit` or use `docker kill` *cont_id*
- `docker exec` *cont_id* *cmd*

> commit 
- `docker commit` *cont_id* *new_image_name*
    - see using `docker images`

    
# general mechanism
- service are not automatically started
    - to have it start at boot, modify `EntryPoint` or `CMD`
- `podman run` foreground will only block, while stdin will still attached to bash. 
    - like any other blocking process, stdin will still buffer input, But it will only executed after unblock
    - **?** so run -i does attach stdin to container 



# network 
- command:
    - `docker network ls`
    - `docker network inspect` *my_network*
    - `docker network create` *my_network* 
        - *`--driver` type* only: (no slirp, no none)
            - *bridge* default subnet 10.89.0.0/24
            - *ipvlan* need *`-o parent=` host_interface*,
            - *macvlan* same as above, additionally host interface must be on promiscuous mode
    - `docker network connect` *my_network* *my_cont* 
    - `docker network disconnect` *my_network* *my_cont* 

    - *`docker port` cont cont_port*, show host forwardded port 
    - when `podman run` use `--network` *mode* 
- intercontainer network option:
    - *bridge* use docker0
        - default internet for `sudo podman run`
        - docker0 is lazy, appear in host only when a container use it
    - *slirp4netns* user mode network
        - default internet for normal user `podman run`
    - *host* use host network stack (ip addr same as host)
    - *orverlay* allow inter-container to communicate accross host **?** how 
- outbound network:
    - (fast) `port_forward`. system level. each container, one port in host
    - (flexible) `reverse_proxy`. app level.
        - consider: this `reverse_proxy` device has 1 IP, but multiple domain name. it can mutex based on the domain name
        - from reverse_proxy running in host (can be container)> forward directly to the network connecting container
        - reverse = it hides the server instead of the client
        - example: NGINX, HAProxy(c/c++)

podman -e MY_NAME=john -it

# docker file
- command:
    - *`podman build` -t imageName -f dockerFilename  .*
        - *`-t` imageName:tag* image name, default to ID
        - *`-f` dockerFilename* file to make the image, default to searching for DockerFile/Containerfile
            - hostWorkdir of this file will be hostWorkdir for *`COPY`*
            - if *`-f`* is not use, hostWorkdir need to be defined using */path/* 
        - *`--target=`build_name* to stop at that build stage
- keywords:
    - *`FROM` image:tag* 
        - *`AS` build_name* to refer in later build stage using *`--from=`build_name*
    - *`WORKDIR` /path/* basically cd, you can use this multiple time in the file, 
    - *`RUN` cmd* 
    - *`COPY` /host/path /cont/path* 
        - *`--chmod=`755* right after *`COPY`*
        - the root for the host is defined in the build command
        - while *`ADD` url /cont/path* can handle 
    - *`ENV` key=value* 
    - *`EXPOSE` port* running *`run` -P* will forward all those port to random host port
    - *`VOLUME` /mount/path* only declare (like EXPOSE), a mount path, still need *`run` -v* to mount a path
    - *`ENTRYPOINT` [cmd]* 
        - at start/run, *entrypoint cmd* will be run, cmd is the part that is overidable
        - each argument must be a seperate item in the array
        - if this is a `.sh` , don't forget `exec "$@"`
    - *`CMD` [cmd]* 
- sidenote:
    - using *`COPY` --from* source `./` will search the host, instead of the *--from* image 

# volume 
- host will have a filesystem.
- container bind/mount to filesystem on a volume
- container  to volume inside a filesystem
- command:
    - `docker volume create $volume_name` create persistant volume
    - `docker run image` create anonymous volume
        - `-v $vol_name:$mount_path`.   
            -   v for volume. 
            - mount_path is inContainer_path, default to *?*
            - 
        
- docker has doc on volume


# compose.yaml
- execution: 
    - (start) `docker-compose up`  *?*
        - *-f my_filename* for any compose file not using the name `compose.yaml` or `docker-compose.yaml`
        - *-d* all container in the background, use attach later for foreground container
        - *`--scale` service_name=number* scale that service *number* amount of time
    - (stop) `docker-compose down`  *?*
        - also remove the container
    - (update) `docker-compose pull` *?*

- syntax: 
``` yaml
services: (each service = 1 container)
    my_cont: # must LOWERCASE #(equivalent to podman run)
        # (image) -> pull image, (build) -> build and give auto-name, (build,name)->build and give name
        image: nginx
        build: ./folder #must be a folder, if file use: dockerfile below
        build:  
            context: . # relative to compose.yaml 
            dockerfile: foo.dockerfile 

        profiles: ["manual"]
        tty: true           # -t
        stdin_open: true    # -i
        # -d from cli, 
        # --rm from podman compose down
        # --name container_name but dont use, makes it not scallable

        networks: ["my_bridge"] # --network
        ports: ["8080:80","22"] # -p, -P (by not providing host port)
        volumes: ['./:my/path/fasd'] # -v (. relative to compose dir)
        environment: {my_env: slda} #-e
        entrypoint: ["bash"] # command_override
        command: ["bash"] # + entryPoint_override

        # so that a service can have `condition`: `service_healthy` , 
        # otherwise only `service_started` , `service_completed_successfully`
        healthcheck:
            test: ["CMD", "mysqladmin","ping", "-h", "localhost"]
            interval: 3s
            timeout: 2s
            retries: 5
        
        # to wait for a service
        depends_on:
            myservice:
                condition: service_healthy

networks: 
volumes: 
environment: 
```

- [references](https://docs.docker.com/reference/compose-file/): 

