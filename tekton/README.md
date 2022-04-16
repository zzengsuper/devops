# Tekton

## Environment 

Minikube Install on Linux:

```shell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube
```

Tekton Install on Linux:
```shell
curl -LO https://github.com/tektoncd/cli/releases/download/v0.23.1/tektoncd-cli-0.23.1_Linux-64bit.deb
sudo dpkg -i package-name
```

Install CRDs to be able to run Tekton Tasks and Pipelines:
```shell
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
```

Tekton Dashboard:
```shell
kubectl apply --filename https://github.com/tektoncd/dashboard/releases/latest/download/tekton-dashboard-release.yaml
```

```shell
kubectl --namespace tekton-pipelines port-forward svc/tekton-dashboard 9097:9097
```

Access Dashboard:
http://localhost:9097

Tekton Version:

```shell
Client version: 0.23.1
Pipeline version: v0.34.1
Dashboard version: v0.25.0
```

## Tekton Task CLI

```shell
kubectl apply -f hello.yaml
tkn task ls
tkn task start hello
tkn taskrun logs hello-run-7vnhm -f -n default
tkn task start hello --showlog
tkn task start hello-param --showlog -p who=Ken
tkn task start hello-param --showlog --use-param-defaults
kubectl get taskrun groceries-run-k24zp -o yaml
kubectl get tr failing-run-mw2fh -o yaml
```

## Tekton pipeline CLI

```shell
tkn pipeline start hello
tkn pipeline start hello --showlog
tkn pipelinerun logs hello-run-bf6h5 -f -n default
kubectl get pipelineruns
kubectl delete pipelinerun results-run-sb6lk
kubectl get pipelinerun results-run-sb6lk -o yaml
```



