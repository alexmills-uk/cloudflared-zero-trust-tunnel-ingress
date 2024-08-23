# Cloudflare Zero Trust Tunnels, for ingress to applications - with Terraform.

You may not want to open any ports to your server, but would like to expose an application to the Internet. 

For example, we may have an application running on `http://127.0.0.1:5000`

Cloudflare's Tunnel daemon, `cloudflared`, creates an encrypted tunnel between your origin web server and Cloudflare's nearest data center, all without opening any public inbound ports.

[Create a locally-managed tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-networks/get-started/create-local-tunnel/) using `cloudflared`

Take a note of the name, and create a `cloudflare_tunnel` data block to reference it:

```
data "cloudflare_tunnel" "cheap_host" {
  account_id = var.cloudflare_account_id
  name       = "cheap_host"
}

```

You can then, assuming you have the domain pointing at Cloudflare's nameservers, define an ingress rule which will link the public hostname to the internal service:

```
resource "cloudflare_tunnel_config" "cheap_host" {
  account_id = var.cloudflare_account_id
  tunnel_id  = data.cloudflare_tunnel.cheap_host.id

  config {
    ingress_rule {
      hostname = "mywebsite.com"
      service  = "http://127.0.0.1:5000"
    }
  }
}
```