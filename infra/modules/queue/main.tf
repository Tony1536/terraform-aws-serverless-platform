resource "aws_sqs_queue" "sqs_dlq" {
  name                      = var.name_dlq
  message_retention_seconds = var.message_retention_seconds
  tags                      = var.tags
}

resource "aws_sqs_queue" "sqs_main" {
  name                       = var.name_main
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.sqs_dlq.arn
    maxReceiveCount     = var.max_receive_count
  })
  tags = var.tags
}
