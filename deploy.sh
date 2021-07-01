# update latest tag and create new tag with git commit SHA
docker build -t alaena/tut-multi-client:latest -t alaena/tut-multi-client:$GIT_SHA -f ./client/Dockerfile ./client
docker build -t alaena/tut-multi-server:latest -t alaena/tut-multi-server:$GIT_SHA -f ./server/Dockerfile ./server
docker build -t alaena/tut-multi-worker:latest -t alaena/tut-multi-worker:$GIT_SHA -f ./worker/Dockerfile ./worker

docker push alaena/tut-multi-client:latest
docker push alaena/tut-multi-server:latest
docker push alaena/tut-multi-worker:latest

docker push alaena/tut-multi-client:$GIT_SHA
docker push alaena/tut-multi-server:$GIT_SHA
docker push alaena/tut-multi-worker:$GIT_SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=alaena/tut-multi-server:$GIT_SHA
kubectl set image deployments/client-deployment client=alaena/tut-multi-client:$GIT_SHA
kubectl set image deployments/worker-deployment worker=alaena/tut-multi-worker:$GIT_SHA