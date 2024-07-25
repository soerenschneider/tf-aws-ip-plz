output "lambda_arn" {
  description = "ARN of the Lambda function"
  value       = aws_lambda_function.ip-plz.arn
}

output "lambda_invoke_arn" {
  description = "Invoke ARN of the Lambda function"
  value       = aws_lambda_function.ip-plz.invoke_arn
}

output "lambda_function_name" {
  description = "The name of the created Lambda function."
  value       = aws_lambda_function.ip-plz.function_name
}

output "lambda_role_name" {
  description = "Name of the Lambda role."
  value       = aws_iam_role.ip-plz.name
}

output "lambda_log_group_arn" {
  description = "ARN of the Cloudwatch log group Lambda logs to."
  value       = aws_cloudwatch_log_group.lambda_log_group.arn
}
