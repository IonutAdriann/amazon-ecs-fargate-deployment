# The purpose of this file is to create the network infrastructure that we need to deploy our application with our own network configuration.

# Fetch the availability zones
data "aws_availability_zones" "available" {}

# Create a VPC
resource "aws_vpc" "main" {
  cidr_block = "172.17.0.0/16"
}

# Create private subnet for an AZ(each different)
resource "aws_subnet" "private" {
    count             = var.az_number
    cidr_block        = cidrsubnet(aws_vpc.main.cidr_block, 8, count.index)
    availability_zone = data.aws_availability_zones.available.names[count.index]
    vpc_id            = aws_vpc.main.id
}

# Create public subnet for an AZ(each different)
resource "aws_subnet" "public" {
    count                   = var.az_number
    cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, var.az_number + count.index)
    availability_zone       = data.aws_availability_zones.available.names[count.index]
    vpc_id                  = aws_vpc.main.id
    map_public_ip_on_launch = true
}

# Create an internet gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id
}

# Route the public subent traffic to the internet gateway
resource "aws_route" "public" {
    route_table_id         = aws_vpc.main.default_route_table_id
    destination_cidr_block = "0.0.0.0/0"
    gateway_id             = aws_internet_gateway.main.id
}

# Create a network adress translation gateway having an Elastic IP for each private subnet in each AZ
# to have internet access
resource "aws_eip" "nat" {
    count      = var.az_number
    domain     = "vpc"
    depends_on = [ aws_internet_gateway.main ]
}

resource "aws_nat_gateway" "nat_gateway" {
    count         = var.az_number
    allocation_id = element(aws_eip.nat.*.id, count.index)
    subnet_id     = element(aws_subnet.public.*.id, count.index)
}

# New route table creation to make the private subnet non-local traffic go through the NAT gateway
# to the internet

resource "aws_route_table" "private" {
    count  = var.az_number
    vpc_id = aws_vpc.main.id

    route {
        cidr_block     = "0.0.0.0/0"
        nat_gateway_id = element(aws_nat_gateway.nat_gateway.*.id, count.index)
    }
}

# We need to associate the created route table with the private subnet 
# to not default to the main route table 

resource "aws_route_table_association" "private_association" {
    count          = var.az_number
    subnet_id      = element(aws_subnet.private.*.id, count.index)
    route_table_id = element(aws_route_table.private.*.id, count.index)
}