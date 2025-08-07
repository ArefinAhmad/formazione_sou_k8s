from kubernetes import client, config
import sys

# Carica config in-cluster oppure locale
try:
    config.load_kube_config()  # Per test locale
except:
    config.load_incluster_config()

apps_v1 = client.AppsV1Api()

namespace = "formazione-sou"
deployment_name = "flask-app"  # Cambialo se necessario

try:
    deployment = apps_v1.read_namespaced_deployment(deployment_name, namespace)
except client.exceptions.ApiException as e:
    print(f"[ERRORE] Deployment non trovato: {e}")
    sys.exit(1)

containers = deployment.spec.template.spec.containers

errors = []

for c in containers:
    if not c.liveness_probe:
        errors.append(f"[X] Liveness probe mancante nel container {c.name}")
    if not c.readiness_probe:
        errors.append(f"[X] Readiness probe mancante nel container {c.name}")
    if not c.resources or not c.resources.limits or not c.resources.requests:
        errors.append(f"[X] Resources (limits/requests) mancanti nel container {c.name}")

if errors:
    print("Deployment NON conforme:")
    for err in errors:
        print("  -", err)
    sys.exit(1)
else:
    print("Deployment conforme a best practices.")

