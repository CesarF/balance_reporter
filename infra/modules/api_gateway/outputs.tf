output "api_id" {
  description = "API gateway ID"
  value       = aws_api_gateway_rest_api.main.id
}

output "stage_name" {
  value = aws_api_gateway_stage.main.stage_name
}
