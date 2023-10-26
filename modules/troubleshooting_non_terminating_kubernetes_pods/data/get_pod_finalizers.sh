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