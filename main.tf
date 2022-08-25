terraform {
}

variable "sensitive_variable" {
  type      = string
  default   = "This is a sensitive variable"
  sensitive = true
}

variable "non_sensitive_variable" {
  type      = string
  default   = "This is a non-sensitive updated variable"
  sensitive = false
}


variable "test" {
  type = map(string)

  default = {
    "foo"     = "bar"
    "this_is" = "unsanitized"
  }
}

resource "random_password" "password" {
  length = 26
}

output "sensitive_output" {
  value     = random_password.password.result
  sensitive = true
}

output "non_sensitive_string_output" {
  value     = var.test.this_is
  sensitive = false
}

output "non_sensitive_number_output" {
  value     = 12
  sensitive = false
}


output "non_sensitive_map_output" {
  value     = var.test
  sensitive = false
}


output "sensitive_variable_output" {
  value     = var.sensitive_variable
  sensitive = true
}

output "non_sensitive_variable_output" {
  value     = var.non_sensitive_variable
  sensitive = false
}
