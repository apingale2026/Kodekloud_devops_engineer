## Kubernetes Challenge 2 
No kubectl command is working 
Kubectl get pods - not working 
error: connection refused 
checked kubeconfig file /root/.kube/config 
Changed api-server port from 6433 to 6443 
still kube-api server is in CrashLoopBackOff
crictl ps -a
crictl logs containerid 
```
controlplane /etc/kubernetes/manifests ➜  crictl logs ed8b2e525eab2
I0708 09:28:05.566777       1 options.go:221] external host was not specified, using 10.244.135.106
I0708 09:28:05.568155       1 server.go:148] Version: v1.30.0
I0708 09:28:05.568236       1 server.go:150] "Golang settings" GOGC="" GOMAXPROCS="" GOTRACEBACK=""
E0708 09:28:05.988692       1 run.go:74] "command failed" err="open /etc/kubernetes/pki/ca-authority.crt: no such file or directory"
```
changed the ca crt path in /etc/kubernetes/manifest/kube-apiserver.yaml
now kubectl get nodes is working fine 
but SchedulingDisabled on node01
run 
```
kubectl uncordon node01
```
Now node01 is ready to schedule
checked pods in kube-system namespace core dns is in ImagePullBackOff
changed the coredns image given in question via command 
```
kubectl -n kube-system edit deployment coredns 
```
Copy all images from the directory '/media' on the controlplane node to '/web' directory on node01
```
scp /media/* node01:/web/
```
pv-pvc.yaml 

```
apiVersion: v1
kind: PersistentVolume
metadata:
  name: data-pv
spec:
  capacity:
    storage: 1Gi
  accessModes:
    - ReadWriteMany
  hostPath:
    path: /web
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: data-pvc
spec:
  accessModes:
    - ReadWriteMany
  resources:
    requests:
      storage: 1Gi
  volumeName: data-pv
```
pod.yaml
```

apiVersion: v1
kind: Pod
metadata:
  labels:
    run: pod
  name: gop-file-server
spec:
  containers:
  - image: kodekloud/fileserver
    name: pod
    volumeMounts:
    - name: data-store
      mountPath: /web
  volumes:
    - name: data-store
      persistentVolumeClaim:
        claimName: data-pvc
```
expose service on port 8080
```
kubectl expose pod gop-file-server --name gop-file-service --port 8080 --target-port 8080 
```
