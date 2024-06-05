#build variables
variable "EnvName" {
  type        = string
  description = "Name of the Env"
}

variable "AccountNumber" {
  type        = string
  description = "AWS accounmt number for env"
}

variable "snapshot_retention" {
  type        = number
  description = "numer of snapshots to retain"
}