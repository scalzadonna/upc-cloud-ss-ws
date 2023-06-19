module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["one", "two", "three"])

  name = "instance-${each.key}"

  ami                    = "ami-02f3f602d23f1659d"
  instance_type          = "t2.micro"
  key_name               = "lab1"
  user_data = << EOF
#! /bin/bash
sudo apt-get update
sudo apt-get install -y apache2
sudo systemctl start apache2
sudo systemctl enable apache2
echo "<h1>Deployed via Terraform</h1>" | sudo tee /var/www/html/index.html
	EOF
  monitoring             = true
  vpc_security_group_ids = ["sg-0a81b547aa6e1761b"]  
  subnet_id              = "subnet-01c27b0910dcd5003"

  tags = {
    Lab   = "5"
    
  }
}
