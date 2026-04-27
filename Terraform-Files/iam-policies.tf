# ─────────────────────────────────────────
# POLICY ATTACHMENTS — EKS CLUSTER ROLE
# ─────────────────────────────────────────

# allows EKS to manage AWS resources on your behalf
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}


# ─────────────────────────────────────────
# POLICY ATTACHMENTS — JENKINS EC2 ROLE
# ─────────────────────────────────────────

# allows Jenkins to push/pull images from ECR
resource "aws_iam_role_policy_attachment" "jenkins_ecr" {
  role       = aws_iam_role.jenkins_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}

# allows Jenkins to interact with EKS cluster
resource "aws_iam_role_policy_attachment" "jenkins_eks" {
  role       = aws_iam_role.jenkins_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# allows Jenkins to describe EC2 resources
resource "aws_iam_role_policy_attachment" "jenkins_ec2_readonly" {
  role       = aws_iam_role.jenkins_ec2.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}


# ─────────────────────────────────────────
# POLICY ATTACHMENTS — EKS NODE ROLE
# ─────────────────────────────────────────

# allows nodes to connect to the EKS cluster
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

# allows the CNI plugin to manage pod networking (assign IPs to pods)
resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

# allows nodes to pull Docker images from ECR
resource "aws_iam_role_policy_attachment" "eks_ecr_readonly" {
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}
