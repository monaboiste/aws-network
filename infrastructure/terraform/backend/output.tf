output "s3_bucket_terraform_state" {
  value = aws_s3_bucket.terraform_state.bucket
}

output "dynamodb_terraform_state_locks" {
  value = aws_dynamodb_table.terraform_locks.name
}
