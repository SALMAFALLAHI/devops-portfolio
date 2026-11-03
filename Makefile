.PHONY: cluster-up cluster-down build import deploy port-forward-grafana port-forward-prometheus port-forward-argocd status clean

CLUSTER_NAME=devops-cluster
IMAGE_NAME=devops-portfolio:dev

## Crée le cluster k3d avec la config déclarative
cluster-up:
	k3d cluster create --config cluster/k3d-config.yaml

## Détruit le cluster
cluster-down:
	k3d cluster delete $(CLUSTER_NAME)

## Build l'image Docker
build:
	docker build -t $(IMAGE_NAME) .

## Importe l'image dans le cluster k3d
import:
	k3d image import $(IMAGE_NAME) -c $(CLUSTER_NAME)

## Build + import en une commande
update-image: build import
	kubectl rollout restart deployment/devops-portfolio -n devops-portfolio

## Affiche l'état global du projet
status:
	@echo "--- Nodes ---"
	kubectl get nodes
	@echo "--- App pods ---"
	kubectl get pods -n devops-portfolio
	@echo "--- ArgoCD apps ---"
	kubectl get applications -n argocd
	@echo "--- Monitoring pods ---"
	kubectl get pods -n monitoring

## Ouvre Grafana (laisse tourner dans ce terminal)
port-forward-grafana:
	kubectl port-forward -n monitoring svc/monitoring-grafana 3000:80

## Ouvre Prometheus (laisse tourner dans ce terminal)
port-forward-prometheus:
	kubectl port-forward -n monitoring svc/monitoring-kube-prometheus-prometheus 9090:9090

## Ouvre ArgoCD UI (laisse tourner dans ce terminal)
port-forward-argocd:
	kubectl port-forward svc/argocd-server -n argocd 8081:443

## Ouvre l'app elle-même (déjà exposée via Ingress sur 8080 normalement)
test-app:
	curl -UseBasicParsing http://localhost:8080/health

## Nettoyage complet (supprime tout)
clean: cluster-down
	@echo "Cluster supprimé."