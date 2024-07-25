

resource "aws_s3_bucket" "create_bucket" {
  bucket = var.name_bucket

  force_destroy = true

  tags = {
    Name        = "Bucket para uso em conjunto com o Amazon EMR"
    Environment = "Scripts"
  }
}

resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.create_bucket.id
  depends_on = [aws_s3_bucket.create_bucket]
  versioning_configuration {
    status = var.versioning_bucket
  }
}

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.create_bucket.id


  block_public_policy     = true

  restrict_public_buckets = true
}

module "s3_objects" {
  source = "./s3_objects"
  name_bucket = var.name_bucket
  files_bucket = var.files_bucket
  files_bash = var.files_bash
  files_data = var.files_data
  
  versioning_bucket = var.versioning_bucket 

  depends_on = [ aws_s3_bucket.create_bucket, 
  aws_s3_bucket_versioning.bucket_versioning, 
  aws_s3_bucket_public_access_block.example ]

}