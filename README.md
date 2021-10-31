# Description

This module deploys a google\_storage bucket to host a static website. Moreover, it also deploy the necessary front-end to deliver the content through CDN.
You can configure a HTTP or HTTPS protocol.
If needed, you can also automatically create a log bucket to retrieve all logs from the website.

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.0.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >=3.90.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >=3.90.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_compute_backend_bucket.backend_website](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_backend_bucket) | resource |
| [google_compute_global_address.global_address](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_address) | resource |
| [google_compute_global_forwarding_rule.default_frontend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_global_forwarding_rule.default_https_frontend](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_global_forwarding_rule) | resource |
| [google_compute_managed_ssl_certificate.certificate](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_managed_ssl_certificate) | resource |
| [google_compute_ssl_policy.modern-ssl-policy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_ssl_policy) | resource |
| [google_compute_target_http_proxy.http_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_http_proxy) | resource |
| [google_compute_target_https_proxy.https_proxy](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_target_https_proxy) | resource |
| [google_compute_url_map.loadbalancer](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/compute_url_map) | resource |
| [google_dns_record_set.dns_record](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/dns_record_set) | resource |
| [google_storage_bucket.log_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_bucket.website_bucket](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket) | resource |
| [google_storage_default_object_acl.default_permission](https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_default_object_acl) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cors"></a> [cors](#input\_cors) | Define cors permissions | <pre>list(object({<br>    max_age_seconds = number<br>    methods         = list(string),<br>    origins         = list(string),<br>    response_header = list(string)<br>    })<br>  )</pre> | `[]` | no |
| <a name="input_create_dns_record"></a> [create\_dns\_record](#input\_create\_dns\_record) | To create a SSL certificate, you need to create a DNS record, with this bool variable it can create the DNS record only if the domain is managed by GCP | `bool` | `false` | no |
| <a name="input_create_log_bucket"></a> [create\_log\_bucket](#input\_create\_log\_bucket) | n/a | `bool` | `false` | no |
| <a name="input_enable_https"></a> [enable\_https](#input\_enable\_https) | Enable HTTPS access to the static website, if yes, a GCP certificate will be generated | `bool` | `false` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow to delete all files before deleting the bucket | `bool` | `true` | no |
| <a name="input_labels"></a> [labels](#input\_labels) | Labels to add to each resource deployed | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | Bucket location | `string` | `"US"` | no |
| <a name="input_log_bucket"></a> [log\_bucket](#input\_log\_bucket) | Specify the bucket to store logs from the website bucket, if not specified, no log will be configured | `string` | `null` | no |
| <a name="input_logs_retention"></a> [logs\_retention](#input\_logs\_retention) | Set logs retention on logs bucket | `number` | `90` | no |
| <a name="input_main_page_suffix"></a> [main\_page\_suffix](#input\_main\_page\_suffix) | Default website page | `string` | `"index.html"` | no |
| <a name="input_managed_zone_dns_name"></a> [managed\_zone\_dns\_name](#input\_managed\_zone\_dns\_name) | if create\_dns\_record is set to yes, you can specify the name of the zone with this variable | `string` | `""` | no |
| <a name="input_not_found_page"></a> [not\_found\_page](#input\_not\_found\_page) | Default 404 error | `string` | `"404.html"` | no |
| <a name="input_storage_class"></a> [storage\_class](#input\_storage\_class) | Storage class of the bucket | `string` | `"standard"` | no |
| <a name="input_website_default_public"></a> [website\_default\_public](#input\_website\_default\_public) | Set to true to set the website bucket as public | `bool` | `false` | no |
| <a name="input_website_url"></a> [website\_url](#input\_website\_url) | Website url and bucket name | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_bucket_name"></a> [log\_bucket\_name](#output\_log\_bucket\_name) | Log bucket name |
| <a name="output_map_url_id"></a> [map\_url\_id](#output\_map\_url\_id) | n/a |
| <a name="output_public_ip"></a> [public\_ip](#output\_public\_ip) | Public IP of the global address |
| <a name="output_website_bucket_name"></a> [website\_bucket\_name](#output\_website\_bucket\_name) | Website bucket name |
