# Fedora CoreOS Config -> Ignition file
resource "local_file" "fc-lucy-ign" {
  content = data.ct_config.fc-lucy-config.rendered
  filename = "${path.module}/output/coreos-lucy.ign"
}

# Fedora CoreOS Config
data "ct_config" "fc-lucy-config" {
  content = local.base-config-template-rendered
  pretty_print = true

  snippets = [
    file("${path.module}/content/docker-snippet.yaml"),
    local.portainer-snippet-rendered,
    local.traefik-snippet-rendered,
    local.netdata-snippet-rendered
  ]
}

# temblated files
locals {
  base-config-template-rendered = templatefile(
    "${path.module}/content/base.yaml",
    {
      hostname = var.hostname,
      isolated_id = var.isolated_id
    }
  )
  portainer-snippet-rendered = templatefile(
    "${path.module}/content/portainer-snippet.yaml",
    {
      domain_name = var.domain_name,
      hostname = var.hostname,
      portainer_id = var.portainer_id,
      isolated_id = var.isolated_id
    }
  )
  traefik-snippet-rendered = templatefile(
    "${path.module}/content/traefik-snippet.yaml",
    {
      domain_name = var.domain_name,
      hostname = var.hostname,
      traefik_id = var.traefik_id,
      isolated_id = var.isolated_id,
      cf_dns_api_token = var.cf_dns_api_token
    }
  )
  netdata-snippet-rendered = templatefile(
    "${path.module}/content/netdata-snippet.yaml",
    {
      domain_name = var.domain_name,
      hostname = var.hostname,
      netdata_id = var.netdata_id,
      isolated_id = var.isolated_id
    }
  )
}
