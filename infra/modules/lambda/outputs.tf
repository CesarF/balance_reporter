output "lambda_name" {
  description = "Final lambda function name, it includes the name and the product prefix."
  value       = aws_lambda_function.main.function_name
}

output "lambda_invoke_arn" {
  description = "ARN to invoke Lambda Function from other services. e.g API Gateway"
  value       = aws_lambda_function.main.invoke_arn
}
