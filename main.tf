
# Create a new S3 bucket policy
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

# Create a new security group
resource "aws_security_group" "ec2_security_group" {
  name        = "ec2-security-group"
  description = "New security group for EC2 instances"

  vpc_id = "vpc-0f511b17db48eda52"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}



