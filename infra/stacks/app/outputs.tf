output "bucket_name" {
  value = module.bucket.bucket_name
}

output "apigateway_url" {
  value = "https://${module.api_gateway.api_id}.execute-api.us-east-1.amazonaws.com/${module.api_gateway.stage_name}"
}
