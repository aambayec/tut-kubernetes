# Kubernetes Tutorial

Kubernetes setup with:

- Google Cloud
- Redis
- Postgres
- React
- Nodejs

## Configuration

Change the current configuration of cluster

```shell
kubectl apply -f client-pod.yml
kubectl apply -f client-node-port.yml
kubectl apply -f client-deployment.yml
kubectl apply -f k8s/client-deployment.yml
kubectl apply -f k8s # apply all config file in a folder
```

Print the status of all running objects (pods, services)

```shell
kubectl get pods
kubectl get pods -o wide
kubectl get services
kubectl get deployments
kubect get pv # persistent volume
kubectl get pvc # get claims (advertisement)
kubectl get secrets
kubectl get ingress
kubectl describe pod client-pod
kubectl describe pod client-deployment-6695c9c676-q4knp
```

Most commands from Docker will also work in kubectl

```shell
kubectl logs <pod_name>
kubectl exec it <pod_name> sh
```

Remove an object

```shell
kubectl delete -f client-pod.yml
kubectl delete -f client-node-port.yml
kubectl delete -f client-deployment.yml

kubectl delete <kind> <object_name>
kubectl delete deployment client-deployment
kubectl delete service client-node-port
```

## Minikube (not used when using Docker Desktop)

Get minikube running IP

```shell
minikube ip
```

Reconfigure current terminal docker client to connect to docker server inside Kubernetes node

```shell
minikube docker-env # to see settings
eval $(minikube docker-env)
```

## Rebuild Docker Image

```shell
docker build -t alaena/tut-multi-client .
docker push alaena/tut-multi-client
```

### Updating Kubernetes deployment

Option 1:
Delete pods manually then reapply

Option 2:
Add image tag/version in yml file

Option 3 (Recommended):
Use an imperative command - tell kubectl to update the deployment

```shell
kubectl set image <object_typ>/<object_name> <container_name>=<new image to use>
kubectl set image deployment/client-deployment client=alaena/tut-multi-client:v0.1

```

## Kubernetes Objects

- Pods - a group of one or more containers, with shared storage and network resources, and a specification for how to run the containers
- Deployments - administers and manages a set of pods. Deployment is a type of 'controller'.
- Services - sets up networking in a Kubernetes Cluster
  - ClusterIP - exposes a set of pods to other objects in the cluster
  - NodePort - exposes a set of pods to the outside world (only good for dev purposes)
  - LoadBalancer - legacy way of getting network traffic into a cluster
  - Ingress - exposes a set of services to outside world
    - [ingress-nginx](https://github.com/kubernetes/ingress-nginx) - a community led project by kubernetes, setup of ingress-nginx changes depending on your environment (local, GC, AWS, Azure). Learn [more](https://www.joyfulbikeshedding.com/blog/2018-03-26-studying-the-kubernetes-ingress-system.html).
    - [kubernetes-ingress](https://github.com/nginxinc/kubernetes-ingress) - a project led by the company nginx
- Secrets - Securely stores a piece of information in the cluster, such as a database password, API keys, or any secrets
  _Secret Types_:
  - docker-registry - authentication with some type of custom authentication with docker registry where we store our images in (no need when using docker hub)
  - tls - https setup (tls keys)
  - generic

Imperative command to create secret:

```shell
# --from-literal or from a file
kubectl create secret generic <secret_name> --from-literal key=<value>
kubectl create secret generic pgpassword --from-literal PGPASSWORD=Ulyanin123
```

## Kubernetes Volumes

- Volume - tied to a pod only, when pod dies the data is lost
- Persistent Volume - exists outside of a pod, when pod dies data will persist, until dev delete it
- Persistent Volume Claim - advertisement of options of volumes in your config
  - Statically Provisioned Persistent Volume - created ahead of time
  - Dynamically Provisioned Persistent Volume - created on the fly, only created when pod asked for it

### Access Modes

- ReadWriteOnce - can be used by a single node
- ReadOnlyMany - multiple nodes can read from this
- ReadWriteMany - Can be read and written to by many nodes

### Storage Classes (File System)

Usually just use the default settings, it will automatically adjust to defaults of the cloud provider.

Some [options](https://kubernetes.io/docs/concepts/storage/storage-classes/):

- Google Cloud Persistent Disk
- Azure File
- Azure Disk
- AWS Block Store
- Local

```shell
kubectl get storageclass
kubectl describe storageclass
```
