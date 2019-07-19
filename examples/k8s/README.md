# k8s

K8s example running mapproxy demo as a uwsgi application with lighttpd as webserver exposing a prometheus metrics end-point.

## TL;DR

```kubectl
kubectl apply -f mapproxy-deployment-example.yml
kubectl delete -f mapproxy-deployment-example.yml
```

## endpoints

With port-forwarding

```kubectl
kubectl port-forward service/mapproxy-example 8181:80
```

- <http://localhost:8181/mapproxy/demo/>
- <http://localhost:8181/server-status>

```kubectl
kubectl port-forward service/mapproxy-example 9117:9117
```

- <http://localhost:9117/metrics>
