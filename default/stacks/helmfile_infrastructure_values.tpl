---
### IMPORTANT this file is generated by terraform from the terragrunt repository
### Do NOT change these values manually from the eks-bootstrapper repository

clusterName: ${cluster_name}
awsRegion: ${aws_region}

#https://artifacthub.io/packages/helm/node-local-dns/node-local-dns
nodelocaldns:
  resources:
      cpu: 50m
      memory: 50Mi

#https://artifacthub.io/packages/helm/aws/aws-vpc-cni
awsNode:
  chartVersion: 1.1.1
  image:
    tag: v1.7.5
  init:
    image:
      tag: v1.7.5

certManager:
  installCRDs: true
  prometheus:
    enabled: true
  webhook:
    replicaCount: 1
  cainjector:
    enabled: true
  resources:
    limits:
      cpu: 100m
      memory: 512Mi 
      
awsLoadBalancerController:
  iamRole: '${load_balancer_controller_role_arn}'
  repo_image: '${aws-lb-repository}'

clusterAutoscaler:
  iamRole: '${cluster_autoscaler_role_arn}'
  chartVersion: 9.1.0
  image:
    tag: v1.18.2

externalDns:
  iamRole: '${external_dns_role_arn}'
  domainFilters: ${route53_zone_ids}
  batchChangeSize: 100

cloudwatchExporter:
  role: '${cloudwatch_exporter_role_arn}'
  
awsNodeTerminationHandler:
  podTerminationGracePeriod: -1 # Use termination grace period defined in pod

externalSecrets:
  serviceAccount:
    role: '${external_secrets_role_arn}'
    name: ${external_secrets_serviceaccount_name}
  secretStores:
    - name: ${external_secrets_parameter_store_secret_store_name}
      service: ${external_secrets_parameter_store_service_name}
      kind: ${external_secrets_parameter_store_secret_store_kind}
      serviceAccountName: ${external_secrets_serviceaccount_name}
      serviceAccountNamespace: ${external_secrets_serviceaccount_namespace}
      retrySettings:
            maxRetries: 5
            retryInterval: "30s"

ebsCsi:
  role: '${ebs_csi_controller_role_arn}'
  kms_arn: '${ebs_csi_controller_kms_arn}'

efsCsi:
  role: '${efs_csi_controller_role_arn}' 


fluentBit:
  RoleArn: '${fluent_bit_role_arn}'
  logRetentionDays: 5

hashicorpVault:
  role: '${vault_role_arn}'
  kmsKeyId: '${vault_kms_key_id}'
