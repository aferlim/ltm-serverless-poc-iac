# Ltm Serverless PoC - IAC using Terraform

## Prerequisites

- Git Hub Account
- Azure Cloud Account
- Terraform CLI version ">= 0.12"

## Set Az Cli Subscription

    az login
    az account set --subscription "XXX"
    az account show

## Creating an Azure storage

For storage the tf state:

    ./az-storage-tfstate.sh

Set the az subscription

    $ az account set --subscription="SUBSCRIPTION_ID"
