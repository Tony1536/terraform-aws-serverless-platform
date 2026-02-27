# API Lambda Role + Policies
resource "aws_iam_role" "lambda_api" {
  name = "${var.name_prefix}-lambda-api-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "api_basic" {
  role       = aws_iam_role.lambda_api.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "api_ddb_rw" {
  name = "${var.name_prefix}-api-ddb-rw"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem",
        "dynamodb:DeleteItem",
        "dynamodb:Query",
        "dynamodb:Scan"
      ]
      Resource = [var.table_arn]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "api_ddb_rw_attach" {
  role       = aws_iam_role.lambda_api.name
  policy_arn = aws_iam_policy.api_ddb_rw.arn
}

resource "aws_iam_policy" "api_sqs_send" {
  name = "${var.name_prefix}-api-sqs-send"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect   = "Allow"
      Action   = ["sqs:SendMessage"]
      Resource = [var.queue_arn]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "api_sqs_send_attach" {
  role       = aws_iam_role.lambda_api.name
  policy_arn = aws_iam_policy.api_sqs_send.arn
}


# Worker Lambda Role + Policies
resource "aws_iam_role" "lambda_worker" {
  name = "${var.name_prefix}-lambda-worker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "worker_basic" {
  role       = aws_iam_role.lambda_worker.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_policy" "worker_sqs_consume" {
  name = "${var.name_prefix}-worker-sqs-consume"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "sqs:ReceiveMessage",
        "sqs:DeleteMessage",
        "sqs:GetQueueAttributes",
        "sqs:ChangeMessageVisibility"
      ]
      Resource = [var.queue_arn]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_sqs_consume_attach" {
  role       = aws_iam_role.lambda_worker.name
  policy_arn = aws_iam_policy.worker_sqs_consume.arn
}


resource "aws_iam_policy" "worker_ddb_rw" {
  name = "${var.name_prefix}-worker-ddb-rw"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "dynamodb:GetItem",
        "dynamodb:PutItem",
        "dynamodb:UpdateItem"
      ]
      Resource = [var.table_arn]
    }]
  })
}

resource "aws_iam_role_policy_attachment" "worker_ddb_rw_attach" {
  role       = aws_iam_role.lambda_worker.name
  policy_arn = aws_iam_policy.worker_ddb_rw.arn
}