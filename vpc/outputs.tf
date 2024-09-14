#Include outputs.tf file to output vpc_id, public_subnet_ids, private_subnet_ids


# output "instance_id"{
#     value = aws_instance.web.*.id
# }
# #to get all instance ids

output "vpc_id"{
    value = aws_vpc.main.id
}

output "public_subnet_ids"{
    value = aws_subnet.public.*.id
}

output "private_subnet_ids"{
    value = aws_subnet.private.*.id
}
