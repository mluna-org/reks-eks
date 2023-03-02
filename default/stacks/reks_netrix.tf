module "reks_netrix" {
  source = "../../"

  # EKS

  aws_account_id = "318949518667"
  environment    = "dev"
  region         = "us-east-1"

  k8s_resources = {
    "external-dns" = {
      namespace      = "kube-system"
      serviceaccount = "external-dns"
    }

    "cluster-autoscaler" = {
      namespace      = "kube-system"
      serviceaccount = "cluster-autoscaler"
    }

    "external-secrets" = {
      namespace      = "kube-system"
      serviceaccount = "external-secrets"
    }

    "cloudwatch-exporter" = {
      namespace      = "monitoring"
      serviceaccount = "cloudwatch-exporter"
    }

    "load-balancer-controller" = {
      namespace      = "ingress"
      serviceaccount = "load-balancer-controller"
    }

    "fluent-bit" = {
      namespace      = "monitoring"
      serviceaccount = "aws-for-fluent-bit"
    }

    "ebs-csi-controller" = {
      namespace      = "kube-system"
      serviceaccount = "ebs-csi-controller-sa"
    }

    "efs-csi-controller" = {
      namespace      = "kube-system"
      serviceaccount = "efs-csi-controller-sa"
    }
    "vault" = {
      namespace      = "kube-system"
      serviceaccount = "vault"
    }
  }

  eks_cluster = {
    name                               = "eks-new"
    cluster_version                    = "1.24"
    enable_irsa                        = true
    manage_aws_auth                    = true
    cluster_endpoint_private_access    = true
    cluster_endpoint_public_access     = false
    cluster_enabled_log_types          = ["audit", "controllerManager"]
    worker_group_cpu_name              = "cpu-worker"
    worker_group_spot_name             = "spot-worker"
    default_instance_types             = ["t3.xlarge"]
    default_ami_type                   = "AL2_x86_64"
    worker_group_cpu_asg_desired_size  = 1
    worker_group_cpu_asg_max_size      = 1
    worker_group_cpu_asg_min_size      = 1
    worker_group_cpu_root_volume_size  = 100
    worker_group_cpu_root_volume_type  = "gp3"
    worker_group_cpu_root_encrypted    = true
    worker_group_spot_asg_desired_size = 1
    worker_group_spot_asg_max_size     = 5
    worker_group_spot_asg_min_size     = 1
    worker_group_spot_root_volume_size = 100
    worker_group_spot_root_volume_type = "gp3"
    worker_group_spot_root_encrypted   = true
    aws_auth_roles = [
      {
        rolearn  = "arn:aws:iam::858348520904:role/REKS-GitHub-Actions" # Edit to assign roles that require authentication to EKS
        username = ""
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::858348520904:role/AWSReservedSSO_AWS_KRATOS_QA_e1c4e9188334c572" # Edit to assign roles that require authentication to EKS. When usign SSO role, remember to delete the characters "aws-reserved/sso.amazonaws.com/" that are included in the arn of the role.
        username = ""
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::858348520904:role/REKS-deployer" # Edit to assign roles that require authentication to EKS
        username = ""
        groups   = ["system:masters"]
      },
      {
        rolearn  = "arn:aws:iam::858348520904:role/AWSReservedSSO_AWS_APOLO_QA_79caff9dc6b9fca5" # Edit to assign roles that require authentication to EKS. When usign SSO role, remember to delete the characters "aws-reserved/sso.amazonaws.com/" that are included in the arn of the role.
        username = ""
        groups   = ["Readonly-Group"]
      }

    ]
    aws_auth_users = [
    ]
  }

  # IAM roles policies
  external_secrets_policy = templatefile("${find_in_parent_folders()}/../../../templates/aws_iam_role_policy_external_secrets.tpl", {
    region      = local.environment_vars.region
    account_id  = local.environment_vars.aws_account_id
    environment = local.environment_vars.environment
  })
  external_dns_policy = templatefile("${find_in_parent_folders()}/../../../templates/aws_iam_role_policy_external_dns.tpl", {
    public_hosted_zone_id = dependency.route53.outputs.public_zone_id, private_hosted_zone_id = dependency.route53.outputs.private_zone_id
  })
  cluster_autoscaler_policy       = file("${find_in_parent_folders()}/../../../templates/aws_iam_role_policy_cluster_autoscaler.tpl")
  load_balancer_controller_policy = file("${find_in_parent_folders()}/../../../templates/aws_iam_role_policy_load_balancer_controller.tpl")
  #ebs_csi_policy                  = file("${find_in_parent_folders()}/../../../templates/aws_iam_policy_ebs_csi.tpl")
  ebs_csi_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ec2:AttachVolume",
          "ec2:CreateSnapshot",
          "ec2:CreateTags",
          "ec2:CreateVolume",
          "ec2:DeleteSnapshot",
          "ec2:DeleteTags",
          "ec2:DeleteVolume",
          "ec2:DescribeAvailabilityZones",
          "ec2:DescribeInstances",
          "ec2:DescribeSnapshots",
          "ec2:DescribeTags",
          "ec2:DescribeVolumes",
          "ec2:DescribeVolumesModifications",
          "ec2:DetachVolume",
          "ec2:ModifyVolume"
        ],
        "Resource" : "*"
      }
    ]
  })

  efs_csi_policy    = file("${find_in_parent_folders()}/../../../templates/aws_iam_policy_efs_csi.tpl")
  fluent_bit_policy = file("${find_in_parent_folders()}/../../../templates/aws_iam_role_policy_fluent_bit.tpl")

  # Infrastructure values
  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids

  kms_keys = {
    ebs = dependency.kms.outputs.ebs_kms_arn
    ecr = dependency.kms.outputs.ecr_kms_arn
  }

  ### TAGS


  tags = {
    application_name = "example-app"
    owner            = "cloud-engineering@edrans.com"
    environment      = "dev"
    prefix           = "edrans"
    costCenter       = "SYSENG"
    tagVersion       = "1"
    role             = "robotize-eks"
    project          = "robotize-eks"
    expirationDate   = "2023-09-02"
  }

  #### workers.tf

  kubelet_common_settings = [
    "--kube-reserved cpu=200m,memory=1Gi,ephemeral-storage=1Gi",
    "--system-reserved cpu=200m,memory=200Mi,ephemeral-storage=1Gi",
    "--eviction-soft memory.available<1Gi,nodefs.available<30%",
    "--eviction-soft-grace-period memory.available=60s,nodefs.available=2m",
    "--eviction-hard memory.available<300Mi,nodefs.available<10%,nodefs.inodesFree<5%,imagefs.available<10%,imagefs.inodesFree<5%",
    "--enable-cadvisor-json-endpoints=true",
  ]

  node_groups = {
    node_group_01 = {
      launch_template_name = "example_lt"
      disk_size            = var.eks_cluster["worker_group_cpu_root_volume_size"]

      name            = "${var.tags["prefix"]}-${var.eks_cluster["worker_group_cpu_name"]}-1"
      description     = "EKS managed node group 1 launch template"
      use_name_prefix = true
      subnet_ids      = [var.private_subnet_ids[0]]

      min_size      = var.eks_cluster["worker_group_cpu_asg_min_size"]
      max_size      = var.eks_cluster["worker_group_cpu_asg_max_size"]
      desired_size  = var.eks_cluster["worker_group_cpu_asg_desired_size"]
      capacity_type = "ON_DEMAND"
      labels = {
        spot = "false"
      }
      block_device_mappings = {
        xvda = {
          device_name = data.aws_ami.eks_default.root_device_name
          ebs = {
            delete_on_termination = true
            encrypted             = var.eks_cluster["worker_group_cpu_root_encrypted"]
            volume_type           = var.eks_cluster["worker_group_cpu_root_volume_type"]
            volume_size           = var.eks_cluster["worker_group_cpu_root_volume_size"]
            kms_key_id            = var.kms_keys["ebs"]
          }
        }
      }

      enable_monitoring = false
      create_iam_role   = false
      iam_role_arn      = aws_iam_role.worker_group_cpu.arn

      create_security_group          = true
      security_group_name            = "eks-managed-ng"
      security_group_use_name_prefix = false
      security_group_description     = "EKS managed node group"

      # Comment/Uncomment the following user-data to use containerd as CRI(EKS 1.21)
      pre_bootstrap_user_data = <<-EOT
    #!/bin/bash
    set -ex
    cat <<-EOF > /etc/profile.d/bootstrap.sh
    export CONTAINER_RUNTIME="containerd"
    export USE_MAX_PODS=false
    export KUBELET_EXTRA_ARGS="--max-pods=110"
    EOF
    # Source extra environment variables in bootstrap script
    sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
    EOT
    },

    # Uncomment the next block to create a Spot Instances node group
    spot_group_01 = {
      launch_template_name = "default_lt_spot"
      disk_size            = var.eks_cluster["worker_group_spot_root_volume_size"]

      name            = "${var.eks_cluster["worker_group_spot_name"]}-2"
      use_name_prefix = true
      subnet_ids      = [var.private_subnet_ids[1]]
      instance_types  = ["t3.xlarge", "t3.large"]
      min_size        = var.eks_cluster["worker_group_spot_asg_min_size"]
      max_size        = var.eks_cluster["worker_group_spot_asg_max_size"]
      desired_size    = var.eks_cluster["worker_group_spot_asg_desired_size"]
      capacity_type   = "SPOT"

      block_device_mappings = {
        xvda = {
          device_name = data.aws_ami.eks_default.root_device_name
          ebs = {
            delete_on_termination = true
            encrypted             = var.eks_cluster["worker_group_spot_root_encrypted"]
            volume_type           = var.eks_cluster["worker_group_spot_root_volume_type"]
            volume_size           = var.eks_cluster["worker_group_spot_root_volume_size"]
            kms_key_id            = var.kms_keys["ebs"]
          }
        }
      }

      enable_monitoring = false
      create_iam_role   = false
      iam_role_arn      = aws_iam_role.worker_group_cpu.arn

      create_security_group          = true
      security_group_name            = "eks-managed-ng-spot"
      security_group_use_name_prefix = false
      security_group_description     = "EKS managed node group"

      # Comment/Uncomment the following user-data to use containerd as CRI(EKS 1.21)
      pre_bootstrap_user_data = <<-EOT
    #!/bin/bash
    set -ex
    cat <<-EOF > /etc/profile.d/bootstrap.sh
    export CONTAINER_RUNTIME="containerd"
    export USE_MAX_PODS=false
    export KUBELET_EXTRA_ARGS="--max-pods=110"
    EOF
    # Source extra environment variables in bootstrap script
    sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
    EOT

      labels = {
        spot  = "true",
        group = "cpu-volatile-spot"
      }
      taints = [
        # {
        #   key    = "volatile"
        #   value  = "true"
        #   effect = "NO_SCHEDULE"
        # }
      ]
    },
    spot_group_02 = {
      launch_template_name = "default_lt_spot"
      disk_size            = var.eks_cluster["worker_group_spot_root_volume_size"]

      name            = "${var.eks_cluster["worker_group_spot_name"]}-2"
      use_name_prefix = true
      subnet_ids      = [var.private_subnet_ids[2]]
      instance_types  = ["t3.xlarge", "t3.large"]
      min_size        = var.eks_cluster["worker_group_spot_asg_min_size"]
      max_size        = var.eks_cluster["worker_group_spot_asg_max_size"]
      desired_size    = var.eks_cluster["worker_group_spot_asg_desired_size"]
      capacity_type   = "SPOT"

      block_device_mappings = {
        xvda = {
          device_name = data.aws_ami.eks_default.root_device_name
          ebs = {
            delete_on_termination = true
            encrypted             = var.eks_cluster["worker_group_spot_root_encrypted"]
            volume_type           = var.eks_cluster["worker_group_spot_root_volume_type"]
            volume_size           = var.eks_cluster["worker_group_spot_root_volume_size"]
            kms_key_id            = var.kms_keys["ebs"]
          }
        }
      }

      enable_monitoring = false
      create_iam_role   = false
      iam_role_arn      = aws_iam_role.worker_group_cpu.arn

      create_security_group          = false
      security_group_name            = "eks-managed-ng-spot"
      security_group_use_name_prefix = false
      security_group_description     = "EKS managed node group"

      # Comment/Uncomment the following user-data to use containerd as CRI(EKS 1.21)
      pre_bootstrap_user_data = <<-EOT
    #!/bin/bash
    set -ex
    cat <<-EOF > /etc/profile.d/bootstrap.sh
    export CONTAINER_RUNTIME="containerd"
    export USE_MAX_PODS=false
    export KUBELET_EXTRA_ARGS="--max-pods=110"
    EOF
    # Source extra environment variables in bootstrap script
    sed -i '/^set -o errexit/a\\nsource /etc/profile.d/bootstrap.sh' /etc/eks/bootstrap.sh
    EOT

      labels = {
        spot  = "true",
        group = "cpu-volatile-spot"
      }
      taints = [
        # {
        #   key    = "volatile"
        #   value  = "true"
        #   effect = "NO_SCHEDULE"
        # }
      ]
    }
  }

  node_security_group_additional_rules = {
    # Allow nodes to communicate between each other without restrictions
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }
    # Allow egress traffic to all destinations from the worker nodes
    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
    # Allow access from control plane to worker nodes
    allow_access_from_control_plane = {
      type                          = "ingress"
      protocol                      = "tcp"
      from_port                     = 0
      to_port                       = 65535
      source_cluster_security_group = true
      description                   = "Allow access from control plane to worker nodes"
    }
  }

}
