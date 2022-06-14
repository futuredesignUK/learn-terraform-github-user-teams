# defines your organization's teams and adds members to teams as defined in the CSV files.
resource "github_team" "all" {
  for_each = {
    for team in csvdecode(file("teams.csv")) :
    # resource block uses the team name as the key in the for_each meta-argument. This lets you reference the team attributes with the team name.
    team.name => team
  }

  name                      = each.value.name
  description               = each.value.description
  privacy                   = each.value.privacy
  create_default_maintainer = true
}

# github_team_membership.members resource assigns members to teams as defined in the respective team CSV files in /team-members. This resource references the local.team_members value defined in the locals.tf to determine the resource arguments.
resource "github_team_membership" "members" {
  for_each = { for tm in local.team_members : tm.name => tm }

  team_id  = each.value.team_id
  username = each.value.username
  role     = each.value.role
}
# Terraform manages most resource dependencies for you, but using dynamically-sized elements in for_each is an edge case. Terraform cannot determine the number of team membership resources to create since the number of elements in local.team_members is determined by the contents of your CSV files.