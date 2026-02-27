module "dynamodb" {
  source = "./modules/dynamodb"

  name     = "${local.name_prefix}-items"
  hash_key = "pk"
  tags     = local.tags
}

module "queue" {
  source = "./modules/queue"

  name_main = "${local.name_prefix}-events"
  name_dlq  = "${local.name_prefix}-events-dlq"

  max_receive_count          = 5
  visibility_timeout_seconds = 30
  message_retention_seconds  = 345600

  tags = local.tags
}
module "iam" {
  source      = "./modules/iam"
  name_prefix = local.name_prefix
  table_arn   = module.dynamodb.table_arn
  queue_arn   = module.queue.queue_arn
  tags        = local.tags
}

module "lambda_api" {
  source        = "./modules/lambda-api"
  function_name = "${local.name_prefix}-api"
  role_arn      = module.iam.lambda_api_role_arn
  table_name    = module.dynamodb.table_name
  queue_url     = module.queue.queue_url

  source_dir = "${path.root}/../app/api/src"
  tags       = local.tags
}

module "lambda_worker" {
  source        = "./modules/lambda-worker"
  function_name = "${local.name_prefix}-worker"
  role_arn      = module.iam.lambda_worker_role_arn
  queue_arn     = module.queue.queue_arn
  queue_url     = module.queue.queue_url

  source_dir = "${path.root}/../app/worker/src"
  tags       = local.tags
  batch_size = 10
}

module "api" {
  source = "./modules/api"

  name       = "${local.name_prefix}-http"
  lambda_name = module.lambda_api.function_name
  lambda_arn  = module.lambda_api.function_arn

  tags = local.tags
}