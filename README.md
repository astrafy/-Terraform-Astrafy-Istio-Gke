<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.4 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=4.28.0 |
| <a name="requirement_google-beta"></a> [google-beta](#requirement\_google-beta) | >=4.28.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >=2.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >=2.12.1 |
| <a name="requirement_random"></a> [random](#requirement\_random) | >=3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | 4.28.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | >=2.6.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | 2.12.1 |
| <a name="provider_random"></a> [random](#provider\_random) | >=3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_firewall.gke_master_istio_pilot_allow](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_firewall) | resource |
| [google_compute_global_address.istio_ingress_lb_ip](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_managed_ssl_certificate.istio_ingress_lb](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) | resource |
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_discovery](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.istio_ingress](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_ingress_v1.istio](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/ingress_v1) | resource |
| [kubernetes_namespace.istio_ingress](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [kubernetes_namespace.istio_system](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/namespace) | resource |
| [random_id.istio_ingress_lb_certificate](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [google_client_config.default](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cluster_node_network_tags"></a> [cluster\_node\_network\_tags](#input\_cluster\_node\_network\_tags) | Network tags of the nodes. Used in private cluster to add additional firewall rules. Required when `private_cluster` is `true` | `list(string)` | `null` | no |
| <a name="input_istio_ingress_configuration"></a> [istio\_ingress\_configuration](#input\_istio\_ingress\_configuration) | Istio Ingress configuration | <pre>object({<br>    allow_http = bool<br>    hosts      = list(string)<br>  })</pre> | n/a | yes |
| <a name="input_master_cidr_range"></a> [master\_cidr\_range](#input\_master\_cidr\_range) | CIDR range of GKE master node when using private cluster. Required when `private_cluster` is `true` | `string` | `null` | no |
| <a name="input_private_cluster"></a> [private\_cluster](#input\_private\_cluster) | Indicate if installing on a private cluster or not. Required for additional firewall rules | `bool` | n/a | yes |
| <a name="input_vpc_network_id"></a> [vpc\_network\_id](#input\_vpc\_network\_id) | VPC network ID to use to add additional firewall rules in private cluster. Required when `private_cluster` is `true` | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_istio_ingress_lb_ip"></a> [istio\_ingress\_lb\_ip](#output\_istio\_ingress\_lb\_ip) | Public IP of the L7 load balancer |
<!-- END_TF_DOCS -->
