terraform {
  backend "s3" {}

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "4.39.0"
    }
  }
}

locals {
  cloudflare_account_id = "foo"
}

data "cloudflare_tunnel" "hetzner" {
  account_id = local.cloudflare_account_id
  name       = "hetzner"
}

resource "cloudflare_tunnel_config" "hetzner" {
  account_id = local.cloudflare_account_id
  tunnel_id  = data.cloudflare_tunnel.hetzner.id

  config {
    ingress_rule {
      hostname = "alexmills.uk"
      service  = "http://127.0.0.1:5000"
    }
  }
}