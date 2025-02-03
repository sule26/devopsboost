locals {
  filtered_subnets = [for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone != "${data.aws_region.current.name}e"]
  len_azs          = length(var.azs)
}
