provider "aws" {
  region = "us-east-2"
  profile = "default"
}

provider "kubernetes" {
  config_path = local_file.kube_cluster_yaml.filename
}