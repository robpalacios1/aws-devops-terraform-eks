resource "helm_release" "metrics-server" {
    name          = "metrics-server"
    chart         = "metrics-server"
    repository    = "https://kubernetes-sigs.github.io/metrics-server"
    namespace     = "kube-system"
    version       = var.chart_version

    set {
        name  = "metrics.enabled"
        value = "true"
    }

    set {
        name  = "args[0]"
        value = "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"
    }
}