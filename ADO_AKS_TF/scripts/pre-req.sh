#!/bin/bash

RESOURCE_GROUP_NAME=ado-terraform-state-rg
STAGE_SA_ACCOUNT=tfstagebackend2025syam
DEV_SA_ACCOUNT=tfdevbackend2025syam
CONTAINER_NAME=tfstate


# Create resource group
az.cmd group create --name $RESOURCE_GROUP_NAME --location southindia

# Create storage account for staging environment
az.cmd storage account create --resource-group $RESOURCE_GROUP_NAME --name $STAGE_SA_ACCOUNT --sku Standard_LRS --encryption-services blob

# Create storage account for dev environment
az.cmd storage account create --resource-group $RESOURCE_GROUP_NAME --name $DEV_SA_ACCOUNT --sku Standard_LRS --encryption-services blob

# Create blob container for staging environment
az.cmd storage container create --name $CONTAINER_NAME --account-name $STAGE_SA_ACCOUNT

# Create blob container for dev environment
az.cmd storage container create --name $CONTAINER_NAME --account-name $DEV_SA_ACCOUNT