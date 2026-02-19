######################################
#    k3d configuration with argoCD   #
#######################################

k3d cluster delete iot
echo "k3d old cluster removed successfully"
k3d cluster create iot --servers 1 --agents 0
echo "New cluster created"
kubectl create namespace argocd
kubectl create namespace dev
echo "Name space created"
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
echo "Initialisation of argocd"
kubectl wait \
	--namespace argocd \
	--for=condition=available \
	deployment/argocd-server \
	--timeout=300s
kubectl wait \
	--namespace argocd \
	--for=condition=ready pod \
	--selector=app.kubernetes.io/name=argocd-server \
	--timeout=300s

kubectl apply -f ../conf/application.yaml
kubectl port-forward service/argocd-server -n argocd 8080:443
echo "All finished, you can access through https://localhost:8080"


