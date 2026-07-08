```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: redis-cluster
spec:
  selector:
    matchLabels:
      app: redis-cluster
  serviceName: redis-cluster
  replicas: 6
  template:
    metadata:
      labels:
        app: redis-cluster
    spec:
      terminationGracePeriodSeconds: 10
      containers:
      - name: redis
        image: redis:5.0.1-alpine
        command: ["/conf/update-node.sh", "redis-server", "/conf/redis.conf"]
        env:
        - name: POD_IP
          valueFrom:
            fieldRef:
              fieldPath: status.podIP
        ports:
        - containerPort: 6379
          name: client
        - containerPort: 16379
          name: gossip
        volumeMounts:
        - name: conf
          mountPath: /conf
          readOnly: False
        - name: data
          mountPath: /data
          readOnly: False
      volumes: 
      - name: conf
        configMap:
          name: redis-cluster-configmap
          defaultMode: 0755
  volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes: [ "ReadWriteOnce" ]
      resources:
        requests:
          storage: 1Gi
---
apiVersion: v1
kind: Service
metadata:
  name: redis-cluster-service
  labels:
    app: redis-cluster
spec:
  clusterIP: None
  selector:
    app: redis-cluster
  ports:
  - name: client
    port: 6379
    targetPort: 6379
  - name: gossip
    port: 16379
    targetPort: 16379
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis01
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis01
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis02
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis02
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis03
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis03
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis04
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis04
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis05
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis05
---
apiVersion: v1
kind: PersistentVolume
metadata:
  name: redis06
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteOnce
  hostPath:
    path: /redis06
```
Run command below to initialize the cluster
```
kubectl exec -it redis-cluster-0 -- redis-cli --cluster create --cluster-replicas 1 $(kubectl get pods -l app=redis-cluster -o jsonpath='{range.items[*]}{.status.podIP}:6379 {end}')
```
