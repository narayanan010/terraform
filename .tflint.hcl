###########################
# General Config
###########################

config {
    module = true
    force = false
}

plugin "aws" {
    enabled = true
    version = "0.17.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

# Disallow deprecated (0.11-style) interpolation
rule "terraform_deprecated_interpolation" {
    enabled = true
}
 
# Disallow legacy dot index syntax.
rule "terraform_deprecated_index" {
    enabled = false

}
 
# Disallow variables, data sources, and locals that are declared but never used.
rule "terraform_unused_declarations" {
    enabled = true
}
 
# Disallow // comments in favor of #.
rule "terraform_comment_syntax" {
    enabled = false
}
 
# Disallow output declarations without description.
rule "terraform_documented_outputs" {
    enabled = false
}
 
# Disallow variable declarations without description.
rule "terraform_documented_variables" {
    enabled = false
}
 
# Disallow variable declarations without type.
rule "terraform_typed_variables" {
    enabled = true
}
 
# Disallow specifying a git or mercurial repository as a module source without pinning to a version.
rule "terraform_module_pinned_source" {
    enabled = false
}
 
# Enforces naming conventions
rule "terraform_naming_convention" {
    enabled = true
    custom = "(^[a-zA-Z0-9/].*([._-][a-zA-Z0-9-]+))|([a-zA-Z0-9/])"
    module {
        custom = "^[a-zA-Z0-9]+([_-][a-zA-Z0-9]+)*"
    }
}

# Disallow terraform declarations without require_version.
rule "terraform_required_version" {
    enabled = true
}
 
# Require that all providers have version constraints through required_providers.
rule "terraform_required_providers" {
    enabled = true
}
 
# Ensure that a module complies with the Terraform Standard Module Structure
rule "terraform_standard_module_structure" {
    enabled = true
}
 
# terraform.workspace should not be used with a "remote" backend with remote execution.
rule "terraform_workspace_remote" {
    enabled = true
}
