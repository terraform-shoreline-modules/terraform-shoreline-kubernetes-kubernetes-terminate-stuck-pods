
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# Troubleshooting Non-Terminating Kubernetes Pods.
---

This incident type refers to the problem of Kubernetes pods that are not terminating. When a pod is no longer needed, it should terminate automatically. However, sometimes a pod can get stuck in a state where it is not terminating, even though it is no longer needed. This can be caused by a variety of factors, such as network issues, resource constraints, or bugs in the application code. Troubleshooting non-terminating Kubernetes pods involves identifying the root cause of the issue and taking steps to resolve it, such as restarting the pod, freeing up resources, or fixing bugs in the code.

### Parameters
```shell
export POD_NAME="PLACEHOLDER"

export CONTAINER_NAME="PLACEHOLDER"

export KUBE_APISERVER_POD_NAME="PLACEHOLDER"

export KUBE_CONTROLLER_MANAGER_POD_NAME="PLACEHOLDER"

export KUBE_SCHEDULER_POD_NAME="PLACEHOLDER"

export NAMESPACE="PLACEHOLDER"
```

## Debug

### Get detailed information about a specific pod
```shell
kubectl describe pod ${POD_NAME}
```

### Check the logs of a specific container within a pod
```shell
kubectl -n $NAMESPACE logs ${POD_NAME} ${CONTAINER_NAME}
```

### Check the events related to a specific pod
```shell
kubectl -n $NAMESPACE get events --field-selector involvedObject.name=${POD_NAME}
```

### See what is still running on the specific pod
```shell
kubectl -n $NAMESPACE top pod ${POD_NAME}
```

### Check the status of the Kubernetes components
```shell
kubectl get componentstatuses
```

### Check the Kubernetes API server logs
```shell
kubectl logs -n kube-system ${KUBE_APISERVER_POD_NAME} kube-apiserver
```

### Check the Kubernetes controller manager logs
```shell
kubectl logs -n kube-system ${KUBE_CONTROLLER_MANAGER_POD_NAME} kube-controller-manager
```

### Check the Kubernetes scheduler logs
```shell
kubectl logs -n kube-system ${KUBE_SCHEDULER_POD_NAME} kube-scheduler
```

### Show any finalizers associated with the pod.
```shell
#!/bin/bash

# Get the pod name and namespace from the command line arguments
POD_NAME=${POD_NAME}
NAMESPACE=${NAMESPACE}

# Get the finalizers associated with the pod
FINALIZERS=$(kubectl get pod $POD_NAME -n $NAMESPACE -o jsonpath='{.metadata.finalizers}')

# Check if there are any finalizers
if [ -z "$FINALIZERS" ]; then
  echo "No finalizers are associated with the pod."
else
  echo "The following finalizers are associated with the pod:"
  echo $FINALIZERS
fi
```

## Repair

### Forcefully delete a stuck pod (WARNING: this may cause data loss)
```shell
kubectl -n $NAMESPACE delete pod ${POD_NAME} --grace-period=0 --force
```

### Remove any finalizers associated with the pod.
```shell
kubectl -n $NAMESPACE patch pod $POD_NAME -p '{"metadata":{"finalizers": []}}'
```