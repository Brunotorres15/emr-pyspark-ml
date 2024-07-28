resource "aws_iam_role" "iam_emr_service_role" {
  name = "iam_emr_service_role"

  
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceRole"]

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "elasticmapreduce.amazonaws.com"
        }
      },
    ]
  })


  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_role" "iam_emr_profile_role" {
  name = "iam_emr_profile_role"


  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonElasticMapReduceforEC2Role"]

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}


resource "aws_iam_instance_profile" "ec2_emr_instance_profile" {
  name = "ec2_emr_instance_profile"
  role = aws_iam_role.iam_emr_profile_role.name
}

