


resource "aws_vpc" main {
  cidr_block = var.vpc_cidr
  instance_tenancy = "default"
  tags = { Name = var.vpc_name }
}

resource "aws_subnet" priv_subnets {
  count = length(var.azs)
  vpc_id = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block = element(var.priv_subnets_cidr, count.index)
  tags = merge({ Name = "priv_${var.vpc_name}" })
}

resource "aws_subnet" pub_subnets {
  count = length(var.azs)
  vpc_id = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block = element(var.pub_subnets_cidr, count.index)
  tags = merge({ Name = "pub_${var.vpc_name}" })
}

resource "aws_eip" "eip" {
  count = length(var.azs)
  vpc   = true
  tags= { Name = "eip-${var.vpc_name}-${count.index}" }
}

resource aws_nat_gateway nat {
  count = length(var.azs)
  allocation_id = element(aws_eip.eip,count.index).id
  subnet_id = element(aws_subnet.pub_subnets,count.index).id
  tags = { Name = "nat_gt_${var.vpc_name}" }
}

resource aws_internet_gateway igw {
  vpc_id = aws_vpc.main.id
  tags = merge({ Name = "igw_${var.vpc_name}" })
}

resource aws_route_table priv_rt {
  count = length(var.azs)
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id =  element(aws_nat_gateway.nat,count.index).id
  }
  tags = merge({ Name = "priv_rt_${var.vpc_name}" })
}

resource aws_route_table pub_rt {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge({ Name = "pub_rt_${var.vpc_name}" })
}

resource aws_route_table_association priv_subnet_association {
  count = length(var.azs)
  subnet_id = element(aws_subnet.priv_subnets.*.id, count.index)
  route_table_id = element(aws_route_table.priv_rt.*.id, count.index)
}

resource aws_route_table_association pub_subnet_association {
  count = length(var.azs)
  subnet_id = element(aws_subnet.pub_subnets.*.id, count.index)
  route_table_id = aws_route_table.pub_rt.id
}