provider "aws" {
  region = "eu-west-2"
}

provider "cloudflare" {
  api_token = data.aws_secretsmanager_secret_version.cloudflare_api_token.secret_string
}