###############################################################################
#                                Peering DNS Zones                              #
###############################################################################

resource "google_dns_managed_zone" "peering" {
  count         = var.type == "peering" ? 1 : 0
  provider      = google-beta
  project       = var.project_id
  name          = var.name
  dns_name      = "${var.domain}." # Ensure the domain ends with a dot
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }

  peering_config {
    target_network {
      network_url = var.target_network
    }
  }
}

###############################################################################
#                                Private DNS Zones                              #
###############################################################################

resource "google_dns_managed_zone" "private" {
  count         = var.type == "private" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = "${var.domain}."
  description   = var.description
  labels        = var.labels
  visibility    = "private"
  force_destroy = var.force_destroy

  dynamic "private_visibility_config" {
    for_each = length(var.private_visibility_config_networks) > 0 ? [1] : []
    content {
      dynamic "networks" {
        for_each = var.private_visibility_config_networks
        content {
          network_url = networks.value
        }
      }
    }
  }
}

###############################################################################
#                                Public DNS Zones                              #
###############################################################################

resource "google_dns_managed_zone" "public" {
  count         = var.type == "public" ? 1 : 0
  project       = var.project_id
  name          = var.name
  dns_name      = "${var.domain}." # Ensure the domain ends with a dot
  description   = var.description
  labels        = var.labels
  visibility    = "public"
  force_destroy = var.force_destroy

  dynamic "dnssec_config" {
    for_each = length(var.dnssec_config) == 0 ? [] : [var.dnssec_config]
    iterator = config
    content {
      kind          = lookup(config.value, "kind", "dns#managedZoneDnsSecConfig")
      non_existence = lookup(config.value, "non_existence", "nsec3")
      state         = lookup(config.value, "state", "off")

      default_key_specs {
        algorithm  = lookup(var.default_key_specs_key, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_key, "key_length", 2048)
        key_type   = lookup(var.default_key_specs_key, "key_type", "keySigning")
        kind       = lookup(var.default_key_specs_key, "kind", "dns#dnsKeySpec")
      }
      default_key_specs {
        algorithm  = lookup(var.default_key_specs_zone, "algorithm", "rsasha256")
        key_length = lookup(var.default_key_specs_zone, "key_length", 1024)
        key_type   = lookup(var.default_key_specs_zone, "key_type", "zoneSigning")
        kind       = lookup(var.default_key_specs_zone, "kind", "dns#dnsKeySpec")
      }
    }
  }

  cloud_logging_config {
    enable_logging = var.enable_logging
  }
}


resource "google_dns_record_set" "cloud-static-records" {
  project      = var.project_id
  managed_zone = var.name

  for_each = { for record in var.recordsets : join("/", [record.name, record.type]) => record }
  name = (
    each.value.name != "" ?
    "${each.value.name}.${var.domain}" :
    var.domain
  )
  type = each.value.type
  ttl  = each.value.ttl

  rrdatas = each.value.records

  dynamic "routing_policy" {
    for_each = toset(each.value.routing_policy != null ? ["create"] : [])
    content {
      dynamic "wrr" {
        for_each = each.value.routing_policy.wrr
        iterator = wrr
        content {
          weight  = wrr.value.weight
          rrdatas = wrr.value.records
        }
      }

      dynamic "geo" {
        for_each = each.value.routing_policy.geo
        iterator = geo
        content {
          location = geo.value.location
          rrdatas  = geo.value.records
        }
      }
    }
  }

  depends_on = [
    google_dns_managed_zone.private,
    google_dns_managed_zone.public,
  ]
}