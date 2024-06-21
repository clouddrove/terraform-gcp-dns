

module "dns-peering-zone" {
  source = "../.."

  project_id                         = var.project_id
  type                               = "peering"
  name                               = var.name
  domain                             = var.domain
  private_visibility_config_networks = ["https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/jetic-dev-vpc"]
  target_network                     = "https://www.googleapis.com/compute/v1/projects/${var.project_id}/global/networks/module-test"
}
