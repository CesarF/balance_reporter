output "api_arn" {
  description = "API gateway ARN"
  value       = aws_api_gateway_rest_api.main.arn
}

output "api_id" {
  description = "API gateway ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "root_resource_id" {
  description = "API root resource id"
  value       = aws_api_gateway_rest_api.main.root_resource_id
}

output "execution_arn" {
  description = "API execution arn. It is required for lambdas to provide permissions"
  value       = aws_api_gateway_rest_api.main.execution_arn
}

output "access_log_name" {
  description = "Access log name"
  value       = aws_cloudwatch_log_group.access_logs.name
}

output "stage_name" {
  value = aws_api_gateway_stage.main.stage_name
}

output "api_gateway_id" {
  value = aws_api_gateway_rest_api.main.id
}
