#!/bin/bash

echo "📌 Verificando nós do cluster..."
kubectl get nodes -o wide
echo ""

echo "📌 Verificando estado dos componentes principais..."
kubectl get componentstatuses
echo ""

echo "📌 Verificando pods em todos os namespaces..."
kubectl get pods --all-namespaces -o wide
echo ""

echo "📌 Verificando eventos recentes no cluster..."
kubectl get events --all-namespaces --sort-by=.metadata.creationTimestamp | tail -n 20
echo ""

echo "📌 Verificando status dos pods no namespace kube-system..."
kubectl get pods -n kube-system -o wide
echo ""

echo "📌 Verificando status do kubelet (local)..."
systemctl is-active --quiet kubelet && echo "✅ Kubelet está ativo" || echo "❌ Kubelet está inativo"
echo ""

echo "📌 Últimas mensagens do kubelet..."
journalctl -u kubelet --no-pager | tail -n 20
echo ""

echo "📌 Verificando saúde do etcd (no k1)..."
kubectl exec -n kube-system etcd-k1 -- etcdctl endpoint health \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key
echo ""

echo "✅ Inspeção de saúde do cluster finalizada."