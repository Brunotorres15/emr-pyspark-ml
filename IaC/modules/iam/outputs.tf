output "ec2_emr_instance_profile_arn" {
    value = aws_iam_instance_profile.ec2_emr_instance_profile.arn
}

output "service_role" {
  value = aws_iam_role.iam_emr_service_role.arn
}