## Kubernetes Challenge_1 
1.Check user crt and user key is provided 
2. Check cert is signed by Kubernetes CA or not 
```
openssl x509 -in /root/martin.crt -text -noout 
```
3. Add user to default configuration file 
```
kubectl config set-credentials martin --client-certificate=/root/martin.crt --client-key=/root/martin.key --embed-certs=true
```
4. set context 
```
kubectl config set-context developer --cluster=kubernetes --user=martin --namespace=development
```
5. Create role 
```
kubectl -n development create role developer-role --verb="*" --resource=pods,services,persistentvolumeclaims
```
6. Create rolebindings 
```
kubectl -n development create rolebinding developer-rolebinding --role=developer-role --user=martin 
```
7.pvc.yaml 
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jekyll-site
  namespace: development
spec:
  accessModes:
    - ReadWriteMany
  volumeMode: Filesystem
  resources:
    requests:
      storage: 1Gi
  storageClassName: local-storage
```
...
8. pod.yaml

```
apiVersion: v1
kind: Pod
metadata:
  labels:
    run: jekyll
  name: jekyll
spec:
  initContainers:
  - image: gcr.io/kodekloud/customimage/jekyll
    name: copy-jekyll-site
    command: ["/bin/sh", "-c"]
    args:
      - "rm -rf /site/* && jekyll new /site && cd /site && bundle install"
    volumeMounts:
    - name: site
      mountPath: /site
  containers:
  - image: gcr.io/kodekloud/customimage/jekyll-serve
    name: jekyll
    command: ["/bin/sh", "-c"]
    args: 
      - "cd /site && bundle install && bundle exec jekyll serve --host 0.0.0.0 --port 4000"
    volumeMounts:
    - name: site
      mountPath: /site
  volumes:
    - name: site
      persistentVolumeClaim:
        claimName: jekyll-site 
```
---
9. svc.yaml

```
apiVersion: v1
kind: Service
metadata:
  labels:
    run: jekyll
  name: jekyll-node-service
spec:
  ports:
  - port: 4000
    protocol: TCP
    targetPort: 4000
    nodePort: 30097
  type: NodePort
  selector:
    run: jekyll
```
10. Check 
```
curl http://node01:30097
```

