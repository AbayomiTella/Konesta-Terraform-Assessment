terraform {
 backend "s3" {
    bucket  = "BUCKET-NAME"
    key     = "konesta-vpc.tfstate"
    region  = "us-east-1"
    encrypt = true
 }
}