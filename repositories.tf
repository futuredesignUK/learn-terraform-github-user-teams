# defines your organization's repositories. It also manages team permissions for the repositories as specified in the files in the repos-team directory.
# Create infrastructure repository
resource "github_repository" "infrastructure" {
  name = "learn-tf-infrastructure"
}

# Add memberships for infrastructure repository
resource "github_team_repository" "infrastructure" {
  for_each = {
    # references the local.repo_teams_files value and specifies "infrastructure" as the key.
    for team in local.repo_teams_files["infrastructure"] :
    team.team_name => {
      # retrieves the team ID by referencing the github_team.all resource with the team name as the key.
      team_id    = github_team.all[team.team_name].id
      permission = team.permission
      # uses the lookup function to ensure the team exists in the github_team.all resource.
    } if lookup(github_team.all, team.team_name, false) != false
  }

  team_id    = each.value.team_id
  repository = github_repository.infrastructure.id
  permission = each.value.permission
}

# Create application repository
resource "github_repository" "application" {
  name = "learn-tf-application"
}

# Add memberships for application repository
resource "github_team_repository" "application" {
  for_each = {
    // application is the key  - populates the resource with data from repos-team/application.csv.
    for team in local.repo_teams_files["application"] :
    team.team_name => {
      team_id    = github_team.all[team.team_name].id
      permission = team.permission
    } if lookup(github_team.all, team.team_name, false) != false
  }

  team_id    = each.value.team_id
  repository = github_repository.application.id
  permission = each.value.permission
}

# Create API repository
resource "github_repository" "api" {
  name = "learn-tf-api"
}

# Add memberships for api repository
resource "github_team_repository" "api" {
  for_each = {
    for team in local.repo_teams_files["api"] :
    team.team_name => {
      team_id    = github_team.all[team.team_name].id
      permission = team.permission
    } if lookup(github_team.all, team.team_name, false) != false
  }

  team_id    = each.value.team_id
  repository = github_repository.api.id
  permission = each.value.permission
}
