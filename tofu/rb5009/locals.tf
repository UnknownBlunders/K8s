locals {
  # Load and convert the YAML string into a Terraform object
  global = yamldecode(file("${path.module}/../globals.yaml"))
}
