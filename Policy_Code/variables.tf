variable "location" {
    type = list(string)
    description = "List of locations where resources will be deployed"
    default = [ "centralindia", "southindia", "canadacentral" ]
}

variable "allowed_tags" {
    type = list(string)
    description = "A list of tags to add to all resources"
    default = [ "Department","Project" ]
}

variable "vm_sizes" {
    type = list(string)
    description = "List of allowed VM sizes"
    default = [ "Standard_B2s","Standard_B2ms" ]  
}