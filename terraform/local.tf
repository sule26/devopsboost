locals {
  filtered_subnets = [for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone != "us-east-1e"]
  len_azs          = length(var.azs)
}
