# defines your organization's users. The resource block in this file manages the users specified in members.csv.

#  resource blocks have two strings in the first line of the block: the resource type and the resource name, which together form a resource ID. This github_membership resource block is named all, so the resource ID is github_membership.all.
resource "github_membership" "all" {
  # dynamically generates resources for members with a for_each meta-argument that iterates over the CSV
  for_each = {
    for member in csvdecode(file("members.csv")) :
    member.username => member
  }

  # The resource block references a specific user's information with each.value.attribute_name, where attribute_name maps to the header row in the CSV file. For example, each.value.username maps to the username column.
  username = each.value.username
  role     = each.value.role
}