locals {
    key1 = "AKIA6LZDI4XDKZWHKNWN"
    key2 = "hy2mSIfd6ZGKsA9n7735gNXPxkqvInoLH/OxLJa9"
    sshEC2 = join(" ", ["ssh -i","MyKeyPair.pem","ec2-user@ec2-44-199-252-224.compute-1.amazonaws.com"])
}
resource "aws_secretsmanager_secret" "secretEC2" {
   name = "EC2Secret"
}
 
# Creating a AWS secret versions for database master account (Masteraccoundb)
 
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id = aws_secretsmanager_secret.secretEC2.id
  secret_string = <<EOF
   {
    "key": "AKIA6LZDI4XDKZWHKNWN",
    "key_id": "hy2mSIfd6ZGKsA9n7735gNXPxkqvInoLH/OxLJa9",
    "keyPair": "MyKeyPair.pem" ,
    "ec2_link": "ec2-user@ec2-44-199-252-224.compute-1.amazonaws.com"
   }
EOF
}