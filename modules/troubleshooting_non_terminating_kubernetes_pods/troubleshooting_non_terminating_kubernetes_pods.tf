resource "shoreline_notebook" "troubleshooting_non_terminating_kubernetes_pods" {
  name       = "troubleshooting_non_terminating_kubernetes_pods"
  data       = file("${path.module}/data/troubleshooting_non_terminating_kubernetes_pods.json")
  depends_on = [shoreline_action.invoke_get_pod_finalizers]
}

resource "shoreline_file" "get_pod_finalizers" {
  name             = "get_pod_finalizers"
  input_file       = "${path.module}/data/get_pod_finalizers.sh"
  md5              = filemd5("${path.module}/data/get_pod_finalizers.sh")
  description      = "Show any finalizers associated with the pod."
  destination_path = "/tmp/get_pod_finalizers.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_get_pod_finalizers" {
  name        = "invoke_get_pod_finalizers"
  description = "Show any finalizers associated with the pod."
  command     = "`chmod +x /tmp/get_pod_finalizers.sh && /tmp/get_pod_finalizers.sh`"
  params      = ["POD_NAME","NAMESPACE"]
  file_deps   = ["get_pod_finalizers"]
  enabled     = true
  depends_on  = [shoreline_file.get_pod_finalizers]
}

