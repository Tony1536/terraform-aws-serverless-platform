output "lambda_api_role_arn" {
  value = aws_iam_role.lambda_api.arn
}

output "lambda_worker_role_arn" {
  value = aws_iam_role.lambda_worker.arn
}