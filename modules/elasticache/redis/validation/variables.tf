variable "validation" {
    type = bool
    description = "Consolidation of `var.node_type` & `var.snapshot_retention_limit`"
    validation {
        condition     = var.validation == true
        error_message = "Invalid convination of values. Snapshot retention between [1-99] and node_type = cache.t1.micro is not allowed."
    }
}