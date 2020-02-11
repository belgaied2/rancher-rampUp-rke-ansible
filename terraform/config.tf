terraform {
  backend "s3" {
    bucket = "rancher-mhassine-rampup"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }
}