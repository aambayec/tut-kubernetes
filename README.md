# Kubernetes Tutorial

Setup with:

- Kubernetes
- Docker
- Travis CI
- Google Cloud
- AWS
- Redis
- Postgres
- React
- Nodejs
- Helm V3
- LetsEncrypt - for TLS certificate, using [cert-manager](https://github.com/jetstack/cert-manager)
- [Skaffold](https://skaffold.dev/docs/) - for local development with Kubernetes

## To Run

```shell
kubectl apply -f k8s
```

Then open browser localhost:80

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

## Kubernetes dashboard

### Minikube

```shell
minikube dashboard
```

### Docker Desktop

1. Grab the most current script from the [install instructions](https://github.com/kubernetes/dashboard#install)
   eg:

   ```shell
   # Mac or using GitBash
   curl https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml > kubernetes-dashboard.yaml

   # PowerShell
   Invoke-RestMethod -Uri https://raw.githubusercontent.com/kubernetes/dashboard/v2.3.1/aio/deploy/recommended.yaml -Outfile kubernetes-dashboard.yaml
   ```

2. Open up the downloaded file in your code editor and use CMD+F or CTL+F to find the args. Add the following two lines underneath --auto-generate-certificates:

   ```yml
   args:
     - --auto-generate-certificates
     - --enable-skip-login
     - --disable-settings-authorizer
   ```

3. Run the following command inside the directory where you downloaded the dashboard manifest file a few steps ago:

   ```shell
   kubectl apply -f kubernetes-dashboard.yaml
   ```

4. Start the server by running the following command:

   ```shell
   kubectl proxy
   ```

5. You can now access the dashboard by visiting:

   <http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/>

6. You will be presented with a login screen. Click the "SKIP" link next to the SIGN IN button.

## Installing Travis CLI to encrypt GCloud JSON service account

```shell
# Use docker when using Windows, Ruby is preinstalled in Mac/Linux
docker run -it -v $(pwd):/app ruby:2.4 sh

gem install travis

travis login --github-token YOUR_PERSONAL_TOKEN --com
or travis login --github-token YOUR_PERSONAL_TOKEN --pro

# Manually copy json file into the 'volumed' directory so we can use it in the container eg. gcloud-service-account.json
# then...

travis encrypt-file gcloud-service-account.json -r aambayec/tut-kubernetes --com
# or travis encrypt-file service-account.json -r USERNAME/REPO --pro

# SAMPLE OUTPUT
# Please add the following to your build script (before_install stage in your .travis.yml, for instance):
#    openssl aes-256-cbc -K $encrypted_227a26790598_key -iv $encrypted_227a26790598_iv -in gcloud-service-account.json.enc -out gcloud-service-account.json -d
```

## Helm V3

Helm is essentially a program that we can use to administer 3rd party software inside of a Kubernetes cluster.

1. Install Helm v3:
   In your Google Cloud Console run the following:

   ```shell
   curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
   chmod 700 get_helm.sh
   ./get_helm.sh
   ```

   link to the docs:kv

   <https://helm.sh/docs/intro/install/#from-script>

2. Skip the commands run in the following lectures:

   ~~Helm Setup, Kubernetes Security with RBAC, Assigning Tiller a Service Account, and Ingress-Nginx with Helm. You should still watch these lectures and they contain otherwise useful info.~~

3. Install Ingress-Nginx:

   In your Google Cloud Console run the following:

   ```shell
   helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
   helm install my-release ingress-nginx/ingress-nginx
   ```

   IMPORTANT: If you get an error such as chart requires kubeVersion: >=1.16.0-0.....

   You may need to manually upgrade your cluster to at least the version specified:

   gcloud container clusters upgrade YOUR_CLUSTER_NAME --master --cluster-version 1.16

   This should not be a long term issue since Google Cloud should handle this automatically:

   <https://cloud.google.com/kubernetes-engine/docs/how-to/upgrading-a-cluster>

   Link to the docs:

   <https://kubernetes.github.io/ingress-nginx/deploy/#using-helm>

## Use Let's Encrypt in Google Cloud

Must have a domain name.
Then follow this <https://www.siteyaar.com/connect-godaddy-domain-to-google-cloud> to make your domain use google cloud.

### Installing the Cert Manager using Helm on Google Cloud

1. Create the namespace for cert-manager:

   ```shell
   kubectl create namespace cert-manager
   ```

2. Add the Jetstack Helm repository

   ```shell
   helm repo add jetstack https://charts.jetstack.io
   ```

3. Update your local Helm chart repository cache:

   ```shell
   helm repo update
   ```

4. Install the cert-manager Helm chart:

   ```shell
   helm install cert-manager jetstack/cert-manager --namespace cert-manager --version v1.2.0 --create-namespace
   ```

5. Install the CRDs:

   ```shell
   kubectl apply -f https://github.com/jetstack/cert-manager/releases/download/v1.2.0/cert-manager.crds.yaml
   ```

Official docs for reference:

<https://cert-manager.io/docs/installation/kubernetes/#installing-with-helm>
