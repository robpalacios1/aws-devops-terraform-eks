resource "helm_release" "metrics-server" {
    name          = "metrics-server"
    chart         = "metrics-server"
    repository    = "https://kubernetes-sigs.github.io/metrics-server"
    namespace     = "kube-system"
    version       = var.chart_version
}