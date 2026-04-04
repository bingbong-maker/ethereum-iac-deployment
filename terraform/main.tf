provider "kubernetes" {
  config_path = "~/.kube/config"
}

resource "kubernetes_namespace" "ethereum" {
  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "ethereum_node" {
  metadata {
    name      = "ethereum-node"
    namespace = kubernetes_namespace.ethereum.metadata[0].name
    labels = {
      app = "ethereum"
    }
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        app = "ethereum"
      }
    }

    template {
      metadata {
        labels = {
          app = "ethereum"
        }
      }

      spec {
        container {
          image = "ethereum/client-go:stable"
          name  = "geth"

          args = [
            "--networkid=${var.network_id}",
            "--http",
            "--http.addr=0.0.0.0",
            "--http.port=8545",
            "--http.api=eth,net,web3,personal"
          ]

          port {
            container_port = 8545
          }

          port {
            container_port = 30303
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "ethereum_service" {
  metadata {
    name      = "ethereum-service"
    namespace = kubernetes_namespace.ethereum.metadata[0].name
  }

  spec {
    selector = {
      app = "ethereum"
    }

    port {
      name        = "rpc"
      port        = 8545
      target_port = 8545
    }

    port {
      name        = "p2p"
      port        = 30303
      target_port = 30303
    }

    type = "NodePort"
  }
}
