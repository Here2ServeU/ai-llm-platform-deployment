
variable "name" { type = string, default = "llm-oke" }
variable "region" { type = string, default = "us-ashburn-1" }
variable "compartment_ocid" { type = string, default = "ocid1.compartment.oc1..REPLACE_ME" }
variable "vcn_ocid" { type = string, default = "ocid1.vcn.oc1..REPLACE_ME" }
variable "lb_subnet_ids" { type = list(string), default = ["ocid1.subnet.oc1..REPLACE_ME"] }
variable "kubernetes_version" { type = string, default = "v1.29.0" }
