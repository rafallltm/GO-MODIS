#!/bin/bash

# Nome do arquivo de log com data/hora
LOGFILE="k8s-health-log-$(date +%F_%H-%M).log"

# Função para imprimir e salvar no log ao mesmo tempo
log() {
    echo -e "$1" | tee -a "$LOGFILE"
}

log "📌 Verificando nós do cluster..."
kubectl get nodes -o wide | tee -a "$LOGFILE"
log ""

log "📌 Verificando estado dos componentes principais..."
kubectl get componentstatuses | tee -a "$LOGFILE"
log ""

log "📌 Verificando pods em todos os namespaces..."
kubectl get pods --all-namespaces -o wide | tee -a "$LOGFILE"
log ""

log "📌 Verificando eventos recentes no cluster..."
kubectl get events --all-namespaces --sort-by=.metadata.creationTimestamp | tail -n 20 | tee -a "$LOGFILE"
log ""

log "📌 Verificando status dos pods no namespace kube-system..."
kubectl get pods -n kube-system -o wide | tee -a "$LOGFILE"
log ""

log "📌 Verificando status do kubelet (local)..."
if systemctl is-active --quiet kubelet; then
    log "✅ Kubelet está ativo"
else
    log "❌ Kubelet está inativo"
fi
log ""

log "📌 Últimas mensagens do kubelet..."
journalctl -u kubelet --no-pager | tail -n 20 | tee -a "$LOGFILE"
log ""

log "📌 Verificando saúde do etcd (no k1)..."
kubectl exec -n kube-system etcd-k1 -- etcdctl endpoint health \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key | tee -a "$LOGFILE"
log ""

log "✅ Inspeção de saúde do cluster finalizada."
log "📝 Log salvo em: $LOGFILE"