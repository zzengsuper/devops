# Jenkins

> Setup Jenkins master node and slave node on docker  
> Setup Prometheus and Grafana on docker to monitor and overview Jenkins performance and health

## Jenkins master setup

```shell
$docker run --name jenkins -itd -v `pwd`/jenkins_home:/var/jenkins_home -p 8080:8080 -p 50000:50000 jenkins/jenkins:lts /bin/bash
```

- InitialPassword is able to check from docker logs CONTAINERID or [`pwd`/jenkins_home/secrets/initialAdminPassword]
- Dashboard access from http://localhost:8080
- Install plug-in

## Add slave to master

Connect slave to master through docker API

```shell
Container : 1bc497060ea9   running Jenkins master
Container : 5a943ec599d4   docker API
```

## Monitoring Jenkins with Prometheus and Grafana

### Prometheus setup

```shell
docker run -d -p 9090:9090 -v /Users/xxx/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus 

# reload config without stopping the prometheus process
docker exec XXX sudo killall -HUP prometheus  #XXX is the container name
```

### Install Jenkins plug-in of prometheus and disk usage

After installation restart the Jenkins server

### Metrics in jenkins server(optional)

```shell
# accesskey should be able to check from [configure system] downbelow the [Metrics] section
https://0.0.0.0:8080/metrics/accesskey 
```

### Grafana sestup 

```shell
docker run \
       -d --name grafana  -p 3000:3000 \
       -e "GF_SECURITY_ADMIN_PASSWORD=xxxxxx" \
       -v "$PWD/grafana:/var/lib/grafana" \
       grafana/grafana
```

### Add prometheus data source

```shell
http://docker.for.mac.localhost:9090
```

### Grafana dashboard

[Jenkins performance dashboard](https://grafana.com/grafana/dashboards/9964)

