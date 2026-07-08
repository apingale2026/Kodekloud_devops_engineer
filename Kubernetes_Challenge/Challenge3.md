## Kubernetes Challenge 3
1. Create namespace vote 
```
kubectl create ns vote
```
2. Set namespace as vote for current context 
```
kubectl config set-context --current --namespace=vote 
```
3. Create vote deployment 


4.Create service vote 
```
apiVersion: v1
kind: Service
metadata:
  labels:
    app: vote
  name: vote
spec:
  type: NodePort
  ports:
  - port: 8080
    protocol: TCP
    targetPort: 80
    nodePort: 31000
  selector:
    app: vote
```
5.Create deployment - redis
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: redis
  name: redis
spec:
  replicas: 1
  selector:
    matchLabels:
      app: redis
  strategy: {}
  template:
    metadata:
      labels:
        app: redis
    spec:
      containers:
      - image: redis:alpine
        name: redis
        volumeMounts:
        - name: redis-data
          mountPath: /data
      volumes:
        - name: redis-data
          emptyDir: {}
```
6.Create service - redis
```
kubectl expose deployment redis --name redis --port 6379 --target-port 6379 --type ClusterIP
```
7.Create deployment - db 
```
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: db
  name: db
spec:
  replicas: 1
  selector:
    matchLabels:
      app: db
  template:
    metadata:
      labels:
        app: db
    spec:
      containers:
      - image: postgres:15-alpine
        name: db
        env:
        - name: POSTGRES_HOST_AUTH_METHOD
          value: "trust"
        volumeMounts:
        - name: db-data
          mountPath: /var/lib/postgresql/data
      volumes:
        - name: db-data
          emptyDir: {}
```
8. expose deployment db to service db 
```
kubectl expose deployment db --name db --port 5432 --target-port 5432 --type ClusterIP
```
9. Create deployment - result 
```
kubectl create deployment result --image=dockersamples/examplevotingapp_result
```
10. Create service - result 
```
apiVersion: v1
kind: Service
metadata:
  creationTimestamp: null
  labels:
    app: result
  name: result
spec:
  ports:
  - port: 8081
    protocol: TCP
    targetPort: 80
    nodePort: 31001
  selector:
    app: result
  type: NodePort
status:
  loadBalancer: {}
  ```
11. Create deployment worker
```
kubectl create deployment worker --image=dockersamples/examplevotingapp_worker
```
