module "lambda" {
  source        = "../../modules/lambda"
  function_name = "${var.service}_${terraform.workspace}"
  image_version = var.image_version
  registry      = "${var.service}-${terraform.workspace}"
  env_variables = local.environment
}

module "api_gateway" {
  source               = "../../modules/api_gateway"
  api_gw_name          = "${var.service}-${terraform.workspace}"
  api_gw_stage         = "v1"
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_name
}

resource "random_string" "random" {
  length  = 32
  special = false
  lower   = true
  upper   = false
}

module "bucket" {
  source      = "../../modules/s3_bucket"
  bucket_name = "${var.service}-${terraform.workspace}--${random_string.random.result}"
}

module "table" {
  source     = "../../modules/dynamo"
  table_name = "${var.service}-${terraform.workspace}"
}
