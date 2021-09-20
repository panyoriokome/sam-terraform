provider "aws" {
  region                      = "ap-northeast-1"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  endpoints {
    dynamodb = "http://dynamodb-local:8000"
  }
}

module "dynamodb" {
  source = "../../modules/"
}