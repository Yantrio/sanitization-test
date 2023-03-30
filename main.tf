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
    "this_is" = "unsanitized1234"
  }
}

resource "random_password" "password" {
  length = 12
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
  value     = "abc"
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

resource "random_integer" "random_id" {
  min = 100
  max = 999
}

resource "random_string" "random_name" {
  length  = 8
  special = false
}

resource "null_resource" "nested_resource" {
  provisioner "local-exec" {
    command = "echo 'Hello, World!'"
  }
}

resource "local_file" "example_file" {
  content  = "This is some extended example content"
  filename = "example.txt"
}

resource "null_resource" "file_permission" {
  triggers = {
    file_contents = local_file.example_file.content
  }

  provisioner "local-exec" {
    command = "chmod 644 ${local_file.example_file.filename}"
  }
}

output "nested_resources" {
  value = {
    random_integer = {
      id    = random_integer.random_id.id
      value = random_integer.random_id.result
    }
    random_string = {
      id    = random_string.random_name.id
      value = random_string.random_name.result
      nested_resources = {
        null_resource = {
          triggers = null_resource.nested_resource.triggers
          nested_resources = {
            local_file = {
              filename = local_file.example_file.filename
              content  = local_file.example_file.content
              nested_resources = {
                null_resource = {
                  triggers = null_resource.file_permission.triggers
                }
              }
            }
          }
        }
      }
    }
  }
}
