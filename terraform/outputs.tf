output "service_name" {
    value = kubernetes_service.ethereum_service.metadata[0].name
}

output "namespace" {
    value = kubernetes_namespace.ethereum.metadata[0].name
}