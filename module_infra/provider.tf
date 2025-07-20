terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.29.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "ff2c3052-bd08-443f-80dd-1cabe7cbcd50"
}
