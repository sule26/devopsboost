locals {
  azs_map = { for idx, az in data.aws_availability_zones.available.names : idx => az }
}

locals {
  filtered_subnets = [for subnet in aws_subnet.private_subnets : subnet.id if subnet.availability_zone != "${data.aws_region.current.name}e"]
}
