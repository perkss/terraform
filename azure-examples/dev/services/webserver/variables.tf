variable "vm_name" {
    description = "VM name, up to 15 characters, numbers and letters, no special characters except hyphen -"
}

variable "admin_username"{
    description = "Admin user name for the virtual machine"
}

variable "location" {
    description = "Azure region"
}

variable "environment" {
    default = "dev"
}
variable "vm_size" {
    default = {
        "dev"  = "Standard_B2s"
        "prod" = "Standard_D2s_v3"
    }
}