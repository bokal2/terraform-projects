locals {
  common_tags = {
    project = "project01"
  }
}

resource "aws_vpc" "project01-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = merge(local.common_tags, {
    Name = "project01-vpc"
  })
}

resource "aws_subnet" "public-subnet" {
  vpc_id     = aws_vpc.project01-vpc.id
  cidr_block = "10.0.0.0/24"
  tags = merge(local.common_tags, {
    Name = "public-subnet"
  })
}
