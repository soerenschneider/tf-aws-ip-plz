locals {
  env = basename(abspath(path.module))
}

module "lambda" {
  source   = "../../modules/aws-lambda"
  env      = local.env
  env_vars = var.lambda_env
}

module "lambda-apigateway" {
  source               = "../../modules/aws-lambda-apigateway"
  env                  = local.env
  lambda_invoke_arn    = module.lambda.lambda_invoke_arn
  lambda_function_name = module.lambda.lambda_function_name
}
