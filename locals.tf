# contains configuration that parses the team memberships and repository permissions defined in the CSV files.
# Create local values to retrieve items from CSVs
# A locals block allows you to define values that you reference throughout your configuration.  Terraform evaluates local values independently of your resource definitions, so you can experiment with local values before including them in your resource configuration and keep any pre-processing separate.
locals {
  # Parse team member files
  # The team_members_path local value defines the directory Terraform should look for the team membership CSV files.
  team_members_path = "team-members"
  #  it creates an object with the file name as the key and the file contents as the value. It uses the csvdecode function to transform the file contents into a format Terraform can use
  team_members_files = {
    for file in fileset(local.team_members_path, "*.csv") :
    trimsuffix(file, ".csv") => csvdecode(file("${local.team_members_path}/${file}"))
  }
  # Create temp object that has team ID and CSV contents
  team_members_temp = flatten([
    for team, members in local.team_members_files : [
      for tn, t in github_team.all : {
        name    = t.name
        id      = t.id
        slug    = t.slug
        members = members
      } if t.slug == team
    ]
  ])

  # Create object for each team-user relationship
  # The team_members local value unnests the members from the team, creating a list of objects containing the relationship name,  ("${team.slug}-${member.username}"), the team ID, the username, and the role. 
  team_members = flatten([
    for team in local.team_members_temp : [
      for member in team.members : {
        name     = "${team.slug}-${member.username}"
        team_id  = team.id
        username = member.username
        role     = member.role
      }
    ]
  ])

  # Parse repo team membership files
  # The repo_teams_path local value defines the directory containing the repositories' team permissions CSV files.
  repo_teams_path = "repos-team"
  # The repo_teams_files local value parses each file in repo_teams_path directory and creates an object with the file name as the key and the file contents as the value.
  repo_teams_files = {
    for file in fileset(local.repo_teams_path, "*.csv") :
    trimsuffix(file, ".csv") => csvdecode(file("${local.repo_teams_path}/${file}"))
  }
}
