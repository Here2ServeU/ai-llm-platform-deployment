
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    oci = { source = "oracle/oci", version = "~> 6.15" }
  }
}

provider "oci" {
  region = var.region
}

resource "oci_containerengine_cluster" "oke" {
  name           = var.name
  compartment_id = var.compartment_ocid
  vcn_id         = var.vcn_ocid
  kubernetes_version = var.kubernetes_version
  options {
    service_lb_subnet_ids = var.lb_subnet_ids
  }
}

output "kubeconfig" {
  value = "oci ce cluster create-kubeconfig --cluster-id ${oci_containerengine_cluster.oke.id} --file $HOME/.kube/config --region ${var.region} --token-version 2.0.0 --kube-endpoint PUBLIC_ENDPOINT --overwrite"
}
