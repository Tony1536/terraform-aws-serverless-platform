output "queue_url" {
  value = aws_sqs_queue.sqs_main.url
}

output "queue_arn" {
  value = aws_sqs_queue.sqs_main.arn
}

output "sqs_dlq_url" {
  value = aws_sqs_queue.sqs_dlq.url
}

output "sqs_dlq_arn" {
  value = aws_sqs_queue.sqs_dlq.arn
}