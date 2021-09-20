output "dynamodb_table_name" {
  value       = aws_dynamodb_table.sam_sample.name
  description = "The name of the DynamoDB table"
}