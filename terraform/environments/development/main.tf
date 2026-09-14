provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
      command     = "aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = "dev"
}

module "ecr" {
  source      = "../../modules/ecr"
  environment = "dev"
}

module "eks" {
  source                  = "../../modules/eks"
  environment             = "dev"
  private_subnet_ids      = module.vpc.private_subnet_ids
  github_actions_role_arn = module.github_oidc.role_arn
}

module "github_oidc" {
  source      = "../../modules/github-oidc"
  environment = "dev"
}

module "aws_load_balancer_controller" {
  source                  = "../../modules/aws-load-balancer-controller"
  environment             = "dev"
  aws_region              = "us-east-1"
  cluster_name            = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  vpc_id                  = module.vpc.vpc_id

  depends_on = [
    module.eks
  ]
}