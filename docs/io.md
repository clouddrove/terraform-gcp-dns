## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| default\_key\_specs\_key | Object containing default key signing specifications : algorithm, key\_length, key\_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details | `any` | `{}` | no |
| default\_key\_specs\_zone | Object containing default zone signing specifications : algorithm, key\_length, key\_type, kind. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details | `any` | `{}` | no |
| description | zone description (shown in console) | `string` | `"Managed by CloudDrove"` | no |
| dnssec\_config | Object containing : kind, non\_existence, state. Please see https://www.terraform.io/docs/providers/google/r/dns_managed_zone#dnssec_config for futhers details | `any` | `{}` | no |
| domain | Zone domain, must end with a period. | `string` | n/a | yes |
| enable\_logging | Enable query logging for this ManagedZone | `bool` | `false` | no |
| force\_destroy | Set this true to delete all records in the zone. | `bool` | `false` | no |
| labels | A set of key/value label pairs to assign to this ManagedZone | `map(any)` | `{}` | no |
| name | Zone name, must be unique within the project. | `string` | n/a | yes |
| private\_visibility\_config\_networks | List of VPC self links that can see this zone. | `list(string)` | `[]` | no |
| project\_id | Project id for the zone. | `string` | n/a | yes |
| recordsets | List of DNS record objects to manage, in the standard terraform dns structure. | <pre>list(object({<br>    name    = string<br>    type    = string<br>    ttl     = number<br>    records = optional(list(string), null)<br><br>    routing_policy = optional(object({<br>      wrr = optional(list(object({<br>        weight  = number<br>        records = list(string)<br>      })), [])<br>      geo = optional(list(object({<br>        location = string<br>        records  = list(string)<br>      })), [])<br>    }))<br>  }))</pre> | `[]` | no |
| target\_network | Peering network. | `string` | `""` | no |
| type | Type of zone to create, valid values are 'public', 'private', 'forwarding', 'peering', 'reverse\_lookup' and 'service\_directory'. | `string` | `"private"` | no |

## Outputs

| Name | Description |
|------|-------------|
| domain | The DNS zone domain. |
| name | The DNS zone name. |
| name\_servers | The DNS zone name servers. |
| type | The DNS zone type. |
