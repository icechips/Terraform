#setup logging to cloudwatch for opensearch
resource "aws_cloudwatch_log_group" "opensearch_log_group" {
  name              = "${local.ClientName}-${var.EnvName}-${local.App}-log-group"
  retention_in_days = 731 #needs to be commented out in initial build because SEA env controls dont allow us to set retention
}

data "aws_iam_policy_document" "opensearch_log_policy" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["es.amazonaws.com"]
    }

    actions = [
      "logs:PutLogEvents",
      "logs:PutLogEventsBatch",
      "logs:CreateLogStream",
    ]

    resources = ["arn:aws:logs:*"]
  }
}

resource "aws_cloudwatch_log_resource_policy" "opensearch_log_resource_policy" {
  policy_name     = "${local.ClientName}-${var.EnvName}-${local.App}-log-policy"
  policy_document = data.aws_iam_policy_document.opensearch_log_policy.json
}

#service link role for opensearch use in VPC
resource "aws_iam_service_linked_role" "opensearch_service_linked_role" {
  aws_service_name = "opensearchservice.amazonaws.com"
}

#opensearch domain
resource "aws_opensearch_domain" "opensearch_domain" {
  domain_name    = "${local.ClientName}-${var.EnvName}-${local.App}-domain"
  engine_version = var.opensearch_engine_version

  cluster_config {
    instance_type            = var.opensearch_instance_type
    instance_count           = var.opensearch_instance_count
    zone_awareness_enabled   = var.multi_az
    dedicated_master_enabled = var.master_enabled
    dedicated_master_count   = 3
    dedicated_master_type    = var.master_instance_type
  }

  vpc_options {
    subnet_ids         = var.opensearch_subnet_ids
    security_group_ids = var.opensearch_security_group_ids
  }
  
  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.opensearch_volume_size
  }

  log_publishing_options {
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.opensearch_log_group.arn
    log_type                 = var.opensearch_log_type
  }

  tags = {
    Env  = var.EnvName
    App  = local.App
  }

  depends_on = [aws_iam_service_linked_role.opensearch_service_linked_role]
}

#opensearch domain policy, not needed when using a VPC endpoint for the opensearch domain
data "aws_iam_policy_document" "opensearch_domain_policy_document" {
  statement {
    effect = "Allow"

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    actions   = ["es:*"]
    resources = ["${aws_opensearch_domain.opensearch_domain.arn}/*"]
  }
}

resource "aws_opensearch_domain_policy" "opensearch_domain_policy" {
  domain_name     = aws_opensearch_domain.opensearch_domain.domain_name
  access_policies = data.aws_iam_policy_document.opensearch_domain_policy_document.json

  depends_on = [aws_opensearch_domain.opensearch_domain]
}