output "project" {
  value = local.name_prefix
}
output "dynamodb_table_name" {
  value = module.dynamodb.table_name
}

output "dynamodb_table_arn" {
  value = module.dynamodb.table_arn
}

output "sqs_queue_url" {
  value = module.queue.queue_url
}

output "sqs_queue_arn" {
  value = module.queue.queue_arn
}

output "sqs_dlq_url" {
  value = module.queue.sqs_dlq_url
}

output "sqs_dlq_arn" {
  value = module.queue.sqs_dlq_arn
}
output "lambda_api_name" { value = module.lambda_api.function_name }
output "lambda_worker_name" { value = module.lambda_worker.function_name }

output "api_url" {
  value = module.api.api_url
}