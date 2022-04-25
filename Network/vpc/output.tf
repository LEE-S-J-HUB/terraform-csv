output "vpc" {
    value = aws_vpc.this
}

output "internet_gateway" {
    value = aws_internet_gateway.this
}

output "subnet" {
    value = aws_subnet.this
}

output "nat_gateway" {
    value = aws_nat_gateway.this
}