resource "aws_s3_bucket" "new_bucket" {
  bucket = "dev-planner"

  tags = {
    Name        = "dev-planner"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_policy" "dev-planner_policy" {
  bucket = aws_s3_bucket.new_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "PublicReadGetObject",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::dev-planner/*"
      }
  ]
}
POLICY
}