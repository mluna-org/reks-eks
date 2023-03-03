variable "cluster_endpoint_private_access" {
  description = "Indicates whether or not the Amazon EKS private API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_endpoint_public_access" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = bool
  default     = true
}

variable "cluster_name" {
  description = "Indicates whether or not the Amazon EKS public API server endpoint is enabled"
  type        = any
  default     = ""
}

variable "eks_cluster" {
  description = "Map containing all EKS cluster configuration"
  type        = object({
    name                               = string
    cluster_version                    = string
    enable_irsa                        = bool
    manage_aws_auth                    = bool
    cluster_endpoint_private_access    = bool
    cluster_endpoint_public_access     = bool
    cluster_enabled_log_types          = list(string)
    worker_group_cpu_name              = string
    worker_group_spot_name             = string
    default_instance_types             = list(string)
    default_ami_type                   = string
    worker_group_cpu_asg_desired_size  = number
    worker_group_cpu_asg_max_size      = number
    worker_group_cpu_asg_min_size      = number
    worker_group_cpu_root_volume_size  = number
    worker_group_cpu_root_volume_type  = string
    worker_group_cpu_root_encrypted    = bool
    worker_group_spot_asg_desired_size = number
    worker_group_spot_asg_max_size     = number
    worker_group_spot_asg_min_size     = number
    worker_group_spot_root_volume_size = number
    worker_group_spot_root_volume_type = string
    worker_group_spot_root_encrypted   = bool
    aws_auth_roles                     = list(string)
    aws_auth_users                     = list(string)
  })
  default   = {
    name                               = "eks"
    cluster_version                    = "1.23"
    enable_irsa                        = true
    manage_aws_auth                    = true
    cluster_endpoint_private_access    = true
    cluster_endpoint_public_access     = true
    cluster_enabled_log_types          = ["audit", "controllerManager"]
    worker_group_cpu_name              = "nombre"
    worker_group_spot_name             = ""
    default_instance_types             = [""]
    default_ami_type                   = ""
    worker_group_cpu_asg_desired_size  = 1
    worker_group_cpu_asg_max_size      = 1
    worker_group_cpu_asg_min_size      = 1
    worker_group_cpu_root_volume_size  = 100
    worker_group_cpu_root_volume_type  = ""
    worker_group_cpu_root_encrypted    = true
    worker_group_spot_asg_desired_size = 1
    worker_group_spot_asg_max_size     = 1
    worker_group_spot_asg_min_size     = 1
    worker_group_spot_root_volume_size = 100
    worker_group_spot_root_volume_type = ""
    worker_group_spot_root_encrypted   = true
    aws_auth_roles                     = []
    aws_auth_users                     = []
  }
}

variable "cluster_autoscaler_policy" {
  description = "JSON file contents with Cluster Autoscaler's IAM role policy"
  type        = string
  default   = "{}"
}

variable "external_secrets_policy" {
  description = "JSON file contents with External Secrets' IAM role policy"
  type        = string
  default   = "{}"
}

variable "external_dns_policy" {
  description = "JSON file contents with External DNS' IAM role policy"
  type        = string
  default   = "{}"
}

variable "ebs_csi_policy" {
  description = "JSON file contents with EBS CSI Driver's IAM role policy"
  type        = string
  default = "{}"
}

variable "efs_csi_policy" {
  description = "JSON file contents with EFS CSI Driver's IAM role policy"
  type        = string
  default = "{}"
}

variable "fluent_bit_policy" {
  description = "JSON file contents with Fluent Bit's IAM role policy"
  type        = string
  default   = "{}"
}

variable "vault_policy" {
  description = "JSON file contents with Hashicorp Vault IAM role policy"
  type        = string
  default   = "{}"
}

variable "jenkins_policy" {
  description = "JSON file contents with Jenkins role policy"
  type        = string
  default   = "{}"
}

variable "nexus_policy" {
  description = "JSON file contents with Jenkins role policy"
  type        = string
  default     = "{}"
}

variable "load_balancer_controller_policy" {
  description = "JSON file contents with AWS Load Balancer Controller's IAM role policy"
  type        = string
  default   = "{}"
}

variable "k8s_resources" {
  description = "Map of namespaces and serviceaccounts for each k8s object or controller"
  type = map(object({
    namespace      = string
    serviceaccount = string
  }))
  default = {
    "external-dns" = {
      namespace      = ""
      serviceaccount = ""
    }

    "cluster-autoscaler" = {
      namespace      = ""
      serviceaccount = ""
    }

    "external-secrets" = {
      namespace      = ""
      serviceaccount = ""
    }

    "cloudwatch-exporter" = {
      namespace      = ""
      serviceaccount = ""
    }

    "load-balancer-controller" = {
      namespace      = ""
      serviceaccount = ""
    }

    "fluent-bit" = {
      namespace      = ""
      serviceaccount = ""
    }

    "ebs-csi-controller" = {
      namespace      = ""
      serviceaccount = ""
    }

    "efs-csi-controller" = {
      namespace      = ""
      serviceaccount = ""
    }
    "vault" = {
      namespace      = ""
      serviceaccount = ""
    }
  }
}
  

variable "kms_keys" {
  type = object({
    ebs = string
    ecr = string
    cloudwatch = string
  })
  description = "kms_keys"
  default = {
    ebs = ""
    ecr = ""
    cloudwatch = ""
  }
}

variable "private_subnet_ids" {
  description = "List of Subnet IDs where the EKS nodes will be deployed"
  type        = list(string)
  default   = []
}

variable "vpc_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
  default   = ""
}

variable "aws_auth_roles" {
  description = "List of role maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

variable "aws_auth_users" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}


#### Agregados

variable "node_security_group_additional_rules" {
  type = map(object({
    description = string
    protocol    = string
    from_port   = number
    to_port     = number
    type        = string
    self        = bool
    cidr_blocks      = list(string)
    ipv6_cidr_blocks = list(string)
    source_cluster_security_group = bool
  }))
  default   = {
    ingress_self_all = {
      description = ""
      protocol    = ""
      from_port   = 0
      to_port     = 0
      type        = ""
      cidr_blocks      = [""]
      ipv6_cidr_blocks = [""]
      self            = true
      source_cluster_security_group = false
    }
    egress_all = {
      description      = ""
      protocol         = ""
      from_port        = 0
      to_port          = 0
      type             = ""
      cidr_blocks      = [""]
      ipv6_cidr_blocks = [""]
      self            = false
      source_cluster_security_group = false
    }
    allow_access_from_control_plane = {
      type                          = ""
      protocol                      = ""
      from_port                     = 0
      to_port                       = 65535
      description                   = ""
      cidr_blocks      = [""]
      ipv6_cidr_blocks = [""]
      self            = false
      source_cluster_security_group = true
   }
  }
}

variable "node_groups" {
  type        = map(string)
  description = "List of KMS keys that the eks worker group will use for encrypt/decrypt"
  default   = {}
}

variable "tags" {
  type = object({
    application_name = string
    owner            = string
    environment      = string
    prefix           = string
    costCenter       = string
    tagVersion       = number
    role             = string
    project          = string
    expirationDate   = string
  })
  description = "tags"
  default = {
    application_name = ""
    owner            = ""
    environment      = ""
    prefix           = ""
    costCenter       = ""
    tagVersion       = 1
    role             = ""
    project          = ""
    expirationDate   = "2023-09-02"
  }
}

variable "aws_account_id" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
  default   = ""
}

variable "environment" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
  default   = ""
}

variable "region" {
  description = "VPC ID where the EKS cluster will be deployed"
  type        = string
  default   = ""
}

variable "kubelet_common_settings" {
  description = "List of user maps to add to the aws-auth configmap"
  type        = list(any)
  default     = []
}

####
## ROUTE53

variable "external_zone_name" {
  description = "R53 Zone name"
  type        = string
  default   = ""
}


variable "internal_zone_name" {
  description = "R53 Zone name"
  type        = string
  default   = ""
}

variable "internal" {
  description = "Route53 Hosted Zone type"
  type        = bool
  default     = false
}

variable "external" {
  description = "Route53 Hosted Zone type"
  type        = bool
  default     = false
}

variable "enable_external_zone_certificate" {
  description = "This variable enables the creation of a certificate for the external zone name"
  type        = bool
  default     = false
}

variable "certificate_subject_alternative_names" {
  description = "A list of domains that should be SANs in the issued certificate"
  type        = list(string)
  default     = []
}

### KMS

variable "kms_ebs" {
  description = "Map containing all properties for KMS EBS"
  type = object({
    create_kms_key          = bool
    deletion_window_in_days = number
    enable_key_rotation     = string
  })
  default = {
    create_kms_key          = false
    deletion_window_in_days = null
    enable_key_rotation     = null
  }
}

variable "kms_ecr" {
  description = "Map containing all properties for KMS ECR"
  type = object({
    create_kms_key          = bool
    deletion_window_in_days = number
    enable_key_rotation     = string
  })
  default = {
    create_kms_key          = false
    deletion_window_in_days = null
    enable_key_rotation     = null
  }
}

### PRUEBA 
## eks.tf

# variable "eks_cluster_name" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = string
#   default   = ""
# }

# variable "eks_cluster_version" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = string
#   default   = ""
# }

# variable "eks_cluster_endpoint_private_access" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = bool
#   default     = true
# }

# variable "eks_cluster_endpoint_public_access" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = bool
#   default     = true
# }

# variable "eks_cluster_enabled_log_types" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = list(string)
#   default   = []
# }

# variable "eks_cluster_enable_irsa" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = bool
#   default     = true
# }

# variable "eks_cluster_default_ami_type" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = string
#   default   = ""
# }

# variable "eks_cluster_default_instance_types" {
#   description = "VPC ID where the EKS cluster will be deployed"
#   type        = string
#   default   = ""
# }

# variable "eks_cluster_aws_auth_roles" {
#   description = "List of role maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

# variable "eks_cluster_aws_auth_users" {
#   description = "List of user maps to add to the aws-auth configmap"
#   type        = list(any)
#   default     = []
# }

# variable "eks_cluster_manage_aws_auth" {
#   description = "List of user maps to add to the aws-auth configmap"
#   type        = bool
#   default     = true
# }
  

# ### workers_role.tf

variable "worker_group_cpu" {
  description = "VPC ID where the EKS cluster will be deployed"
  type = object({
    name               = string
    assume_role_policy = map(string)
  })
  default   = {
    name               = "nombre"
    assume_role_policy = {}
  }
}

