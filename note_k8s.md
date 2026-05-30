# structure
- cluster. multiple node
- node (physical boundary). a computer, multiple pod
- pod (logical boundary). multiple container. *smallest/atomic unit in k8s*
- container. in a pod,
    - only one is the main
    - share same volume
    - share same loopback/localhost
    - has different runtime

# resource
- a k8s manifest describe a resource (a single object in the cluster)
- a resource has :
    - `apiVersion` *group/version* ~~ the resource import statement
        - *version*
            - v1alpha1 = unstable
            - v1beta1 = mostly stable
            - v1 = stable
        - *group*
            - ``. this include kind: service, pod, other core resource
    - `kind` ~~ resource type
        - `service` = a set of pod
        - `Deployment` = stateless
        - `StatefulSet` = db
    - `metadata` ~~ identity
        - `name`
    - `spec` ~~ what it should do 

# service 
- is a k8s resource. it points to a group of pod
``` yaml
apiVersion: 
kind: Service
metadata:
    name: my_service
spec:
```
- `type`. how a service is exposed outside of the cluster
    - `clusterIP`(default). doesnt expose to the outside world
    - `NodePort`. expose the service to the outside <>
        - resolve: any_nodeIP:nodePort -> service
    - `LoadBalancer`. when it receive request, forward to any node --(service resolve)--> correct node :: correct 
    - `forwarding to pod`
    - `integration with ingress`

## network
- physical route: **?**
    `client_node` --DNS:*cluster_domainName -> (one of )cluster_interface.IP*--> 
    `(one of )cluster_interface` --*chooses nodeIP:node.Port (may be random)*--> 
    `(one of )node` --iptables:*nodeIP:node.Port-> service.IP:service.Port -> pod.IP:targetPort*--> 
    (CNI:*pod.IP -> node.IP* then send it there)
    `pod (may be at a different node)`
- cluster interface to the internet: load balancer, ingress **?**

- service/cluster lvl= serviceIP:port
- node lvl= nodeIP:nodePort
- pod lvl= podIP:targetPort
- container lvl= localhost:containerPort
             


    