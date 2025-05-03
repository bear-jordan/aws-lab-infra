resource "aws_instance" "hello_world_0" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet_0.id

  user_data = <<-EOF
             #!/bin/bash
             sudo apt-get update
             sudo apt-get install -y nginx
             sudo systemctl start nginx
             sudo systemctl enable nginx
             echo '<!doctype html>
             <html lang="en"><h1>Home page!</h1></br>
             <h3>(Instance 0)</h3>
             </html>' | sudo tee /var/www/html/index.html
             EOF
}

resource "aws_instance" "hello_world_1" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet_1.id

  user_data = <<-EOF
             #!/bin/bash
             sudo apt-get update
             sudo apt-get install -y nginx
             sudo systemctl start nginx
             sudo systemctl enable nginx
             echo '<!doctype html>
             <html lang="en"><h1>Home page 1!</h1></br>
             <h3>(Instance 1)</h3>
             </html>' | sudo tee /var/www/html/index.html
             EOF
}

resource "aws_instance" "hello_world_2" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"

  subnet_id = aws_subnet.public_subnet_2.id

  user_data = <<-EOF
             #!/bin/bash
             sudo apt-get update
             sudo apt-get install -y nginx
             sudo systemctl start nginx
             sudo systemctl enable nginx
             echo '<!doctype html>
             <html lang="en"><h1>Home page!</h1></br>
             <h3>(Instance 2)</h3>
             </html>' | sudo tee /var/www/html/index.html
             EOF
}
