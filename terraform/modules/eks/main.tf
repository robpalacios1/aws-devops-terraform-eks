provider "aws" {
  region = "us-east-1"
}

# ====================================================================
# 1. IAM Role for EKS Cluster (control plane)
# ====================================================================

resource "aws_iam_role" "eks_cluster_role" {
  name = "eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.environment}-eks-cluster-role"
    environment = var.environment
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# ====================================================================
# 2. EKS Cluster
# ====================================================================

resource "aws_eks_cluster" "main" {
    name = "${var.environment}-eks-cluster"
    role_arn = aws_iam_role.eks_cluster_role.arn
    version = var.cluster_version

    vpc_config {
        subnet_ids = var.private_subnet_ids
    }

    depends_on = [
        aws_iam_role_policy_attachment.eks_cluster_policy
    ]

    tags = {
        Name        = "${var.environment}-eks-cluster"
        environment = "${var.environment}"
    }
}

# ====================================================================
# 3. IAM Role for EKS Node Group (worker nodes)
# ====================================================================

resource "aws_iam_role" "eks_node_role" {
    name = "${var.environment}-eks-node-group"

    assume_role_policy = jsonencode({
        "Version" : "2012-10-17"
        "Statement" : [
            {
                "Effect" : "Allow"
                "Principal" : {
                    "Service" : "ec2.amazonaws.com"
                },
                "Action" : "sts:AssumeRole"
            }
        ]
    })

    tags = {
        Name        = "${var.environment}-eks-node-group"
        environment = "${var.environment}"
    }
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "eks_ecr_read_only" {
    role = aws_iam_role.eks_node_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# ====================================================================
# 4. EKS Node Group
# ====================================================================

resource "aws_eks_node_group" "main" {
    cluster_name    = aws_eks_cluster.main.name
    node_group_name = "${var.environment}-node-group"
    node_role_arn = aws_iam_role.eks_node_role.arn

    subnet_ids      = var.private_subnet_ids

    scaling_config {
        desired_size = 3
        max_size     = 4
        min_size     = 2
    }

    instance_types = ["t3.medium"]
    capacity_type = "ON_DEMAND"
    
    depends_on = [
        aws_iam_role_policy_attachment.eks_worker_node_policy,
        aws_iam_role_policy_attachment.eks_cni_policy,
        aws_iam_role_policy_attachment.eks_ecr_read_only
    ]

    tags = {
        Name        = "${var.environment}-node-group"
        environment = "${var.environment}"
    }
}

