# outputs.tf

output "backend_private_key_pem" {
  value     = tls_private_key.backend.private_key_pem
  sensitive = true
}

output "frontend_private_key_pem" {
  value     = tls_private_key.frontend.private_key_pem
  sensitive = true
}

output "edge_gateway_private_key_pem" {
  value     = tls_private_key.edge_gateway.private_key_pem
  sensitive = true
}
