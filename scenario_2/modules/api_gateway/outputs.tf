output "invoke_url" {
  value = "${aws_api_gateway_stage.prod.invoke_url}/query"
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.this.id
}
