locals {
  common_tags = {
    Project = var.project_name
  }
}

# VPC
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = merge(local.common_tags, { Name = "${var.project_name}-vpc" })
}

# Public Subnets
resource "aws_subnet" "public" {
  for_each                = toset(var.public_subnets)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = each.key
  availability_zone       = element(var.azs, index(var.public_subnets, each.key))
  map_public_ip_on_launch = true
  tags                    = merge(local.common_tags, { Name = "public-subnet-${each.key}" })
}

# App Subnets
resource "aws_subnet" "app-subnet" {
  for_each          = toset(var.app_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = element(var.azs, index(var.app_subnets, each.key))
  tags              = merge(local.common_tags, { Name = "app-subnet-${each.key}" })
}

# DB Subnets
resource "aws_subnet" "db-subnet" {
  for_each          = toset(var.db_subnets)
  vpc_id            = aws_vpc.main.id
  cidr_block        = each.key
  availability_zone = element(var.azs, index(var.db_subnets, each.key))
  tags              = merge(local.common_tags, { Name = "db-subnet-${each.key}" })
}
