terraform {
 backend "s3" {
   bucket = "terraform-eks-cicd-1206"
   key    = "eks/terraform.tfstate"
   region = "ap-northeast-1"
 } 
}