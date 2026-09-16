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
  region = var.aws_region
}

module "vpc" {
  source      = "../../modules/vpc"
  environment = var.environment
}

module "ecr" {
  source      = "../../modules/ecr"
  environment = var.environment
}

data "aws_iam_role" "github_actions" {
    name = "github-actions-role"
}

module "eks" {
  source                  = "../../modules/eks"
  environment             = var.environment
  private_subnet_ids      = module.vpc.private_subnet_ids
  github_actions_role_arn = data.aws_iam_role.github_actions.arn
}

module "aws_load_balancer_controller" {
  source                  = "../../modules/aws-load-balancer-controller"
  environment             = var.environment
  aws_region              = var.aws_region
  cluster_name            = module.eks.cluster_name
  cluster_oidc_issuer_url = module.eks.cluster_oidc_issuer_url
  vpc_id                  = module.vpc.vpc_id

  depends_on = [
    module.eks
  ]
}

module "metrics-server" {
  source      = "../../modules/metrics-server"
  environment = var.environment

  depends_on = [
    module.eks
  ]
}