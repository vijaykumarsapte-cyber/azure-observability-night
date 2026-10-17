kubectl apply -f namespaces.yaml
sleep 5
kubectl apply -f database/ 
sleep 5
kubectl apply -f backend/
sleep 5
kubectl apply -f frontend/

kubectl get pods,svc -n database
kubectl get pods,svc -n backend
kubectl get pods,svc -n frontend