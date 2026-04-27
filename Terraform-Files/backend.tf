terraform {
  backend "s3" {
    bucket         = "todo-app-save" # must be globally unique
    key            = "todo-app/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true                 # encrypts state file at rest
    dynamodb_table = "todo-app-lockFiles" # must exist before terraform init
  }
}
