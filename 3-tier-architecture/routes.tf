# Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public-rt"
  }
}

# Associate Public Subnets with Public Route Table
resource "aws_route_table_association" "public" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

# Private Route Tables for App and DB Subnets
resource "aws_route_table" "private" {
  for_each = toset(var.azs)
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

  tags = {
    Name = "private-rt-${each.key}"
  }
}

# Associate App Private Subnets with Private Route Tables
resource "aws_route_table_association" "app" {
  for_each       = aws_subnet.app-subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[element(var.azs, index(var.app_subnets, each.key))].id
}

resource "aws_route_table_association" "db" {
  for_each       = aws_subnet.db-subnet
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[element(var.azs, index(var.db_subnets, each.key))].id
}
