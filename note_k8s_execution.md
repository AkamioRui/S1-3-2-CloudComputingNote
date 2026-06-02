# kubectl
## managing resource
- `api-resources` list all resources
- `get` *resource*
    - resource:*all* resource
    - *`-A`* all namespace
    - *`-n` namespace*
    - *`-o wide`* show which node
- `apply` this includes updating the same yaml
    - *`-f` manifest.yaml* 
- `delete`
    - *`-f` manifest.yaml* 

## miscelaneous
- *`exec -it` pod name `-- bash`*


## using clusterIP
- to use clusterIP, you need to be in a node that has kube-proxy.
    - in minikube, those are container created by podman. so 
``` sh
    minikube ssh
```

## creating an image registry
```sh
    microk8s enable registry
```
- microk8s `registry` will store all image pushed and update the image if the name is identical down to the tag
    - list image `curl http://localhost:32000/v2/_catalog`
- microk8s `containerd`, the thing that run the container, will pull from registry
    - it will cache and not pull the same image again, even when there if that image gets new pushes (to the registry)
### podman: save image in specific registry
- manual:
    - *`podman build -t` **registry_url**/image_name:tag ./context*
    - *`podman push --tls-verify=false` **registry_url**/image_name:tag*
- compose:
    ``` yaml
    build: 
    image: registry_url/image_name:tag
    ``` 
    - `podman-compose build`
    - `podman-compose push`

## manifest syntax 
### header
``` yaml
apiVersion: v1
kind: 
metadata:
    - name: 
spec: 
```
### pod_spec ~~ podman-compose
```yaml
containers:
  - name: my-container
    image: nginx:1.14.2
    ports:
      - containerPort: 80
    env:                    # environment variables
      - name: MY_VAR
        value: "hello"
    volumeMounts:
      - name: my-volume
        mountPath: /data
initContainers:       
  - name: init
    image: busybox
    command: ['sh', '-c', 'echo initializing']
volumes:
  - name: my-volume
    persistentVolumeClaim:
    claimName: my-pvc
```


  



## different alternative for k8s
- `k8s`. 
    - contains all `kube-apiserver`, `kubelet`, etc
- `microk8s` is just `k8s` installed using snap (classically) 
    - `k8s-dqlite` replaces `etcd`
    - `kubelite` run [`kubelet`, `proxy`, `apiserver`, `scheduler`, `controller-manager`]    
- `minikube` create a vm/container and run `k8s` in it
``` sh
    curl -LO https://github.com/kubernetes/minikube/releases/latest/download/minikube-linux-amd64
    sudo install minikube-linux-amd64 /usr/local/bin/minikube && rm minikube-linux-amd64
        
        ## checking podman status need sudo, but cant sudo. So run minikube as rootless
        minikube config set rootless true
        ## qemu will need `--smp 2` (more than 2 cpu) 
    sudo minikube start 
```

## adding another host
### minikube `minikube add node`
### from control plane node
1. `kubeadm token create --print-join-command`
### from new node
1. the new host must have: ``, ``, ``
2. must be able to change it's namespace 
3. can talk to control plane's apiServer
4. it must not close 
5. it must not close 