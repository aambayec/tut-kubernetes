# Configuration

Change the current configuration of cluster

```
kubectl apply -f client-pod.yml
kubectl apply -f client-node-port.yml
```

Print the status of all running objects (pods, services)

```
kubectl get pods
kubectl get services
kubectl describe pod client-pod
```

Get minikube running IP (not used when using Docker Desktop, we can use localhost)

```
minikube ip
```
