provider "azurerm" {
  features {}

  resource_provider_registrations = "none"   # disable auto RP registration if you lack rights

  # Uncomment the following block to enable Azure AD authentication
}