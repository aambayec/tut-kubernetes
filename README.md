# tut-kubernetes

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
