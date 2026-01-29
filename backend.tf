terraform {
  backend "gcs" {
    bucket = "tf-state-prod-bucket-synapse"
    prefix = "terraform/state"
  }
}
