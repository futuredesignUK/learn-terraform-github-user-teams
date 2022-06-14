# defines Terraform settings, including the required providers Terraform will use to provision your resources. Providers are plugins that Terraform uses to interact with APIs.
terraform {
  required_providers {
# Providers are plugins that Terraform uses to interact with APIs.
# The GitHub provider is used to interact with GitHub resources.
# The provider allows you to manage your GitHub organization's members and teams easily. It needs to be configured with the proper credentials before it can be used.
    github = {
      # the source attribute defines an optional hostname, a namespace, and the provider type for each provider
      source  = "integrations/github"
      //  constrain the provider version so that Terraform does not install a provider version that may not work with your configuration.
      version = "4.26.1"
    }
  }

  # Allows only the rightmost TF version component to increment. 
  # required_version = "~> 1.0.5"
  required_version = "~> 1.2.2"
}