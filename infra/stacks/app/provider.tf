provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      "author" : "cesarf",
      "product" : "balance"
    }
  }
}
