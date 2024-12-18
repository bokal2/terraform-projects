# Internet Gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.common_tags, { Name = "${var.project_name}-igw" })
}

# Elastic IPs for NAT Gateways
resource "aws_eip" "nat_eip" {
  for_each = toset(var.azs)
  tags     = merge(local.common_tags, { Name = "nat-eip-${each.key}" })
}

# NAT Gateways
resource "aws_nat_gateway" "nat" {
  for_each      = toset(var.azs)
  allocation_id = aws_eip.nat_eip[each.key].id
  subnet_id     = aws_subnet.public[element(var.public_subnets, index(var.azs, each.key))].id

  tags = merge(local.common_tags, { Name = "nat-gateway-${each.key}" })
}
