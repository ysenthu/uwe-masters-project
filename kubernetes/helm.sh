helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus prometheus-community/kube-prometheus-stack
aws ecr get-login-password --bridgefund --region eu-central-1 | docker login --username AWS --password-stdin 002665144501.dkr.ecr.eu-central-1.amazonaws.com
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
helm upgrade  loki grafana/loki
