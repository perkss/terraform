resource "azurerm_resource_group" "k8s" {
  name     = var.resource_group_name
  location = var.location
}

resource "random_id" "log_analytics_workspace_name_suffix" {
  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "test" {
  # The WorkSpace name has to be unique across the whole of azure, not just the current subscription/tenant.
  name                = "${var.log_analytics_workspace_name}-${random_id.log_analytics_workspace_name_suffix.dec}"
  location            = var.log_analytics_workspace_location
  resource_group_name = azurerm_resource_group.k8s.name
  sku                 = var.log_analytics_workspace_sku
}

resource "azurerm_log_analytics_solution" "test" {
  solution_name         = "ContainerInsights"
  location              = azurerm_log_analytics_workspace.test.location
  resource_group_name   = azurerm_resource_group.k8s.name
  workspace_resource_id = azurerm_log_analytics_workspace.test.id
  workspace_name        = azurerm_log_analytics_workspace.test.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/ContainerInsights"
  }
}

resource "azurerm_kubernetes_cluster" "example" {
  name                = var.cluster_name
  location            = azurerm_resource_group.k8s.location
  resource_group_name = azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix

  agent_pool_profile {
    name            = "default"
    count           = 1
    vm_size         = "Standard_D1_v2"
    os_type         = "Linux"
    os_disk_size_gb = 30
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  tags = {
    Environment = "Development"
  }
}