resource "aws_dynamodb_table" "sam_sample" {
  name = "sam-sample"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "UserId"

    attribute {
      name = "UserId"
      type = "S"
    }
}