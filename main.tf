 # https://spacelift.io/blog/terraform-commands-cheat-sheet
#  defines your GitHub provider and retrieves user information about the owner of the personal access token.
# github provider block is empty because it automatically uses the personal access token and organization name you set as environment variables earlier
provider "github" {}

# A data source block allows you to retrieve information defined outside of Terraform and reference it in your configuration.
# github_user data source block is named self, so the data source ID is data.github_user.self.
# Retrieve information about the currently (PAT) authenticated user
data "github_user" "self" {
  username = ""
}
