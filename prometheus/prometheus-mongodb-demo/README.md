# Prometheus MongoDB Monitoring Demo

## Steps to monitor third-party apps using Prometheus Exporter

* Pre-requisite : minikube cluster installed
* mongodb pod <-- mongoldb-exporter <-- pull metrics <-- Prometheus Server <-- PromQL <-- Prometheus UI(Grafana)

### create minikube cluster

```shell
minikube start --cpus 4 --memory 8192 --vm-driver hyperkit
```

### install Prometheus-operator 

```shell
[add repos]
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add stable https://charts.helm.sh/stable
helm repo update

[install chart]
helm install prometheus prometheus-community/kube-prometheus-stack
```

### check pod and svc

```shell
$ kubectl get pod
NAME                                                     READY   STATUS    RESTARTS   AGE
alertmanager-prometheus-kube-prometheus-alertmanager-0   2/2     Running   0          5m16s
prometheus-grafana-5b96fb5467-9hwfd                      2/2     Running   1          5m52s
prometheus-kube-prometheus-operator-bcdfdbc79-k9qp7      1/1     Running   0          5m52s
prometheus-kube-state-metrics-58c5cd6ddb-dz7ps           0/1     Running   4          5m52s
prometheus-prometheus-kube-prometheus-prometheus-0       2/2     Running   0          5m3s
prometheus-prometheus-node-exporter-r6tj7                1/1     Running   2          5m51s
```

```shell
$ kubectl get svc
NAME                                      TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                      AGE
alertmanager-operated                     ClusterIP   None             <none>        9093/TCP,9094/TCP,9094/UDP   5m44s
kubernetes                                ClusterIP   10.96.0.1        <none>        443/TCP                      2d1h
prometheus-grafana                        ClusterIP   10.101.102.48    <none>        80/TCP                       6m19s
prometheus-kube-prometheus-alertmanager   ClusterIP   10.108.126.129   <none>        9093/TCP                     6m19s
prometheus-kube-prometheus-operator       ClusterIP   10.110.153.211   <none>        443/TCP                      6m19s
prometheus-kube-prometheus-prometheus     ClusterIP   10.100.150.34    <none>        9090/TCP                     6m19s
prometheus-kube-state-metrics             ClusterIP   10.110.215.181   <none>        8080/TCP                     6m19s
prometheus-operated                       ClusterIP   None             <none>        9090/TCP                     5m31s
prometheus-prometheus-node-exporter       ClusterIP   10.109.75.21     <none>        9100/TCP                     6m19s
```

### port-forwardings

```shell
[prometheus-UI]
kubectl port-forward service/prometheus-kube-prometheus-prometheus 9090
Forwarding from 127.0.0.1:9090 -> 9090
Forwarding from [::1]:9090 -> 9090
```

```shell
$ kubectl get servicemonitor 
NAME                                                 AGE
prometheus-kube-prometheus-alertmanager              34m
prometheus-kube-prometheus-apiserver                 34m
prometheus-kube-prometheus-coredns                   34m
prometheus-kube-prometheus-grafana                   34m
prometheus-kube-prometheus-kube-controller-manager   34m
prometheus-kube-prometheus-kube-etcd                 34m
prometheus-kube-prometheus-kube-proxy                34m
prometheus-kube-prometheus-kube-scheduler            34m
prometheus-kube-prometheus-kube-state-metrics        34m
prometheus-kube-prometheus-kubelet                   34m
prometheus-kube-prometheus-node-exporter             34m
prometheus-kube-prometheus-operator                  34m
prometheus-kube-prometheus-prometheus                34m
```

### create mongodb deployment and service

```shell 
$ kubectl apply -f mongodb-without-exporter.yaml
```

### deploy mongodb exporter with helm search

[mongodb-exporter](https://github.com/helm/charts/tree/master/stable/prometheus-mongodb-exporter)

```shell
$ helm show values prometheus-community/prometheus-mongodb-exporter > values.yaml
```

### modify the value yaml file

### install mongodb-exporter with values

[prometheus-community/helm-charts](https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-mongodb-exporter)

```shell
$ helm install mongodb-exporter prometheus-community/prometheus-mongodb-exporter -f values.yaml
$ helm ls
$ kubectl get pod  # mongodb-exporter-prometheus-mongodb-exporter should be installed
$ kubectl get svc  # mongodb-exporter-prometheus-mongodb-exporter service should be there
$ kubectl get servicemonitor  # mongodb-exporter-prometheus-mongodb-exporter should be created
$ kubectl get servicemonitor mongodb-exporter-prometheus-mongodb-exporter -o yaml # release: prometheus label should be there
```

### port-forwarding mongodb-exporter 

```shell
# port-forward mongodb-exporter and check metrics from there and prometheus will collect all those datas from mongodb-exporter(mongodb-exporter will expose all of those metrics to prometheus)
$ kubectl port-forward service/mongodb-exporter-prometheus-mongodb-exporter 9216
```

### mongodb metrics data in Grafana UI

```shell
$ kubectl get deployment
$ kubectl port-forward deployment/prometheus-grafana 3000
# Grafana Dashboard credential
# user : admin
# pwd : prom-operator
```

### port-forwardings alert manager UI

```shell
$ kubectl port-forward svc/prometheus-kube-prometheus-alertmanager 9093
```

















