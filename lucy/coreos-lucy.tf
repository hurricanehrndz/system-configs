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
    file("${path.module}/content/docker-snippet.yaml")
  ]
}

# temblated files
locals {
  base-config-template-rendered = templatefile(
    "${path.module}/content/base.yaml",
    {
      hostname = "lucy"
    }
  )
}
