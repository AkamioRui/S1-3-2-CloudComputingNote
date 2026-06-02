# structure
- `cluster`. multiple node
- `node` (physical boundary). a computer, multiple pod
    - all `node request/send info to center` by running these software(called k8s `components`)
        - kubelet
            - *poll whether its node (itself) need to run a pod*
            - *push status*
        - containerd
            - *runs the container*
        - kube-proxy
            - *poll about routing*
            - *works by modifying iptables*
    - One node `act as center` by additionally running these software(called k8s `control plane components`)
        - kube-apiserver 
            - *listen to kubectl and other k8s components*
            - *(the only one) communicate with etcd*. 
            - *then send response*. 
        - etcd 
            - *database* the status of the cluster
        - kube-scheduler 
            - *poll pod with no node* 
        - kube-controller-manager 
            - *poll state*
    
    - those softwares are called `componenets`
- `pod` (logical boundary). multiple container. *smallest/atomic unit in k8s*
    - pod are in practice a container that sleeps, the other container said to be inside of it are actually just normal container created at pod level, but with the same namespace and volume.
    - all pods in node is connected by a bridge. the node is also in this bridge
    - unlike gateway: 
        - pod_A in node_A will first send to bridge(node_A), [pod_A_ip->pod_B_ip]{msg}
        - node_A will send to node_B, [node_A_ip->node_B_ip]{[pod_A_ip->pod_B_ip]{msg}}
        - node_B will send to pod_B
        - but the mac will still be from pod_A
- `container`. in a pod,
    - only one is the main
    - share same volume
    - share same loopback/localhost
    - has different runtime

# resource
- a k8s manifest describe a `resource` (a single object in the cluster)
- When a `resource` is deployed, that each instance is called an `object`
- a resource has :
    - `apiVersion` *group/version* ~~ from part of "from x import y"
        - *version*
            - v1alpha1 = unstable
            - v1beta1 = mostly stable
            - v1 = stable
        - *group*
            - ``. this include kind: service, pod, other core resource
    - `kind` ~~ import part of "from x import y", the resource type
        - `service` = a set of pod
        - `Deployment` = stateless
        - `StatefulSet` = db
    - `metadata` ~~ identity
        - `name`
        - `labels`. to be used with `selector`
    - `spec` ~~ what it should do 

# service *v1:Service*
- it points to a group of pod
- addressing:
    - service/cluster lvl   = serviceIP:port
    - node lvl              = nodeIP:nodePort
    - pod lvl               = podIP:targetPort
    - container lvl         = localhost:containerPort. containerPort == targetPort
- `type`. how a service is exposed outside of the cluster
    - `clusterIP`(default). doesnt expose service to outside
        - kube-proxy allocate = *clusterIP:port*
        - traffic to *clusterIP:port* is forwarded to *(a podIP):targetPort*
    - `NodePort`. expose service via Node(*:port)
        - kube-proxy allocate = *clusterIP:port*. all node now also listen to *nodePort*
        - traffic arrived at anynode:*nodePort* --resolved--> *clusterIP:port* is forwarded to *(a podIP):targetPort*
    - `LoadBalancer`. expose service via LoadBalancerIP:port
        - when api-server receive this manifest, a loadbalancer device (aws/azure/metalLB) will give took that job and give them its IP. then when traffic goes to the loadbalancer it will forward to one of the node.
        - the rest is `NodePort`.
    - `forwarding to pod`
    - `integration with ingress`
- one possible route:
    - `client_node` --DNS:*cluster_domainName -> (one of )cluster_interface.IP*--> 
    - `(one of )cluster_interface` --*chooses nodeIP:node.Port (may be random)*--> 
    - `(one of )node` --iptables:*nodeIP:node.Port-> service.IP:service.Port -> pod.IP:targetPort*--> 
    - (CNI:*pod.IP -> node.IP* then send it there)
    - `pod (may be at a different node)`

RuiMakaGithubioWibowo11062005

## ingress
- is a k8s resource. it's a rule that maps hostname/path -> service
- this is implemented by `ingress controller` pods
- http header `Host:` defines the hostname

             
## resources
- a resources = what you want to happend
- each resource has their own spec syntax
- `v1:Service`. 
- `v1:PersistentVolume`. 
- `v1:PersistentVolumeClaim`. 
- `apps/v1:Deployment`. I want *rolling update* and *ReplicaSet_spec*
    - `apps/v1:ReplicaSet`. I want *have x many replica*, if I not enough use *`template:` pod_spec*
        - `v1:Pod` I want create a pod
- `apps/v1:StatefulSet`. 
- `networking.k8s.io/v1:Ingress`. I want a pod that translate *URI ==> clusterIP:port*

    