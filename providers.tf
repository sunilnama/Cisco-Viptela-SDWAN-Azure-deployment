provider "azurerm" {
  features {}

  resource_provider_registrations = "none"   # disable auto RP registration if you lack rights

  subscription_id = "0cfe2870-d256-4119-b0a3-16293ac11bdc"
  client_id       = "d5bd05d7-f339-4d99-8aec-232bd20bddee"   # AppId of Service Principal
  client_secret   = "Max8Q~xQ8E5ycDsliRMyE36bgpxTSto0vKgWCb3B"
  tenant_id       = "84f1e4ea-8554-43e1-8709-f0b8589ea118"
}