resource "aws_dlm_lifecycle_policy" "bakery_lifecycle_policy" {
  description        = "automated snapshot policy"
  execution_role_arn = "arn:aws:iam::${var.AccountNumber}:role/service-role/AWSDataLifecycleManagerDefaultRole"
  state              = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]

    schedule {
      name = "snapshot schedule"

      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["09:00"]
      }

      retain_rule {
        count = var.snapshot_retention
      }

      copy_tags = true
    }

    target_tags = {
      Env = var.EnvName
    }
  }
}