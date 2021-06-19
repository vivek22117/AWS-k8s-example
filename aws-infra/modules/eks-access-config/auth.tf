
locals {
  certificate_authority_data_list          = coalescelist(data.terraform_remote_state.eks-vpc.outputs.eks_cluster_certificate_authority, [[{ data : "" }]])
  certificate_authority_data_list_internal = local.certificate_authority_data_list[0]
  certificate_authority_data_map           = local.certificate_authority_data_list_internal[0]
  certificate_authority_data               = local.certificate_authority_data_map["data"]

  configmap_auth_template_file = var.configmap_auth_template_file == "" ? join("/", [path.module, "data-script/configmap-auth.yaml.tpl"]) : var.configmap_auth_template_file
  configmap_auth_file          = var.configmap_auth_file == "" ? join("/", [path.module, "data-script/configmap-auth.yaml"]) : var.configmap_auth_file

  cluster_name = join("", data.terraform_remote_state.eks-vpc.outputs.eks_cluster_id)

  # Add worker nodes role ARNs (could be from many worker groups) to the ConfigMap
  map_worker_roles = [
    for role_arn in var.workers_role_arns : {
      rolearn : role_arn
      username : "system:node:{{EC2PrivateDNSName}}"
      groups : [
        "system:bootstrappers",
        "system:nodes"
      ]
    }
  ]

  map_worker_roles_yaml            = trimspace(yamlencode(local.map_worker_roles))
  map_additional_iam_roles_yaml    = trimspace(yamlencode(var.map_additional_iam_roles))
  map_additional_iam_users_yaml    = trimspace(yamlencode(var.map_additional_iam_users))
  map_additional_aws_accounts_yaml = trimspace(yamlencode(var.map_additional_aws_accounts))
}

data "template_file" "configmap_auth" {
  count    = var.enabled && var.apply_config_map_aws_auth ? 1 : 0
  template = file(local.configmap_auth_template_file)

  vars = {
    map_worker_roles_yaml            = local.map_worker_roles_yaml
    map_additional_iam_roles_yaml    = local.map_additional_iam_roles_yaml
    map_additional_iam_users_yaml    = local.map_additional_iam_users_yaml
    map_additional_aws_accounts_yaml = local.map_additional_aws_accounts_yaml
  }
}

resource "local_file" "configmap_auth" {
  count    = var.enabled && var.apply_config_map_aws_auth ? 1 : 0
  content  = join("", data.template_file.configmap_auth.*.rendered)
  filename = local.configmap_auth_file
}

resource "null_resource" "apply_configmap_auth" {
  count = var.enabled && var.apply_config_map_aws_auth ? 1 : 0

  triggers = {
    cluster_updated                     = join("", data.terraform_remote_state.eks-vpc.outputs.eks_cluster_id)
    worker_roles_updated                = local.map_worker_roles_yaml
    additional_roles_updated            = local.map_additional_iam_roles_yaml
    additional_users_updated            = local.map_additional_iam_users_yaml
    additional_aws_accounts_updated     = local.map_additional_aws_accounts_yaml
    configmap_auth_file_content_changed = join("", local_file.configmap_auth.*.content)
    configmap_auth_file_id_changed      = join("", local_file.configmap_auth.*.id)
  }

  depends_on = [local_file.configmap_auth]

  provisioner "local-exec" {
    interpreter = [var.local_exec_interpreter, "-c"]

    command = <<EOT
      set -e

      echo 'Applying Auth ConfigMap with kubectl...'
      aws eks update-kubeconfig --name=${local.cluster_name} --region=${var.default_region} --kubeconfig=${var.kubeconfig_path} ${var.aws_eks_update_kubeconfig_additional_arguments}
      kubectl version --kubeconfig ${var.kubeconfig_path}
      kubectl apply -f ${local.configmap_auth_file} --kubeconfig ${var.kubeconfig_path}
      echo 'Applied Auth ConfigMap with kubectl'
    EOT
  }
}
