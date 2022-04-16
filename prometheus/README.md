# Prometheus architecture

[Prometheus Overview](https://prometheus.io/docs/introduction/overview/)

## Exporter

[third-party exporter list](https://prometheus.io/docs/instrumenting/exporters/)

### what is a exporter

Export is basically a translator between applications data or metrics to metrics or data that Prometheus understand.so It's basically sitting between the application and prometheus getting the data from the application transforming it into data or metrics that prometheus will be able to collect. An exporter itself will expose /metrics endpoint so that prometheus will be able to scrape it from there. (For example, fetches metrics from target mongodb app and converts to Prometheus understandable metrics)

- It collects the matrix data from the application and converts it to data understandable by prometheus
- It exposes these metrics at a /metrics endpoint for permetheus to be able to scrape them

### 3 components get started exporter (not recommend)

- exporter application (mongodb-exporter) - exposes / metrics endpoint
- service - for connecting to the exporter
- servicemornitor - to be discovered by the prometheus

### helm search (recommend)

[mongodb-exporter-chart](https://github.com/helm/charts/tree/master/stable/prometheus-mongodb-exporter)

Preferred way of doing it we can search for a helm chart that already has all these configuration files ready and configured so that you can basically just install them with one command 

