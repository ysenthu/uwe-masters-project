output "pub_subnets"{
  value = aws_subnet.pub_subnets.*.id
}
output "priv_subnets"{
  value = aws_subnet.priv_subnets.*.id
}