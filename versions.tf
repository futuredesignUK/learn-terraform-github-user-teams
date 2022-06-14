terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "4.26.1"
    }
  }

  # Allows only the rightmost version component to increment. 
  # required_version = "~> 1.0.5"
  required_version = "~> 1.2.2"
}