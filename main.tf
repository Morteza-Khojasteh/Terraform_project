
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


# Create a new EC2 key pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "ec2_key_pair"
  public_key = file("~/.ssh/Sec-Key.pub")
}

#  Create a new EC2 instance
resource "aws_instance" "new_instance" {
  ami             = "ami-0faab6bdbac9486fb"
  instance_type   = "t2.micro"
  key_name        = aws_key_pair.ec2_key_pair.key_name
  security_groups = [aws_security_group.ec2_security_group.name]

  tags = {
    Name = "new_instance"
  }
}


# Create a new RDS instance 
resource "aws_db_instance" "new_db_instance" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  instance_class       = "db.t3.micro"
  username             = "postgres"
  password             = "password"

  tags = {
    Name = "new_db_instance"
  }
}
