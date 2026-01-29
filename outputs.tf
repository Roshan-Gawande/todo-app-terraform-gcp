output "frontend_url" {
  description = "URL to access the TODO application"
  value       = "http://${module.frontend.public_ip}"
}

output "frontend_public_ip" {
  description = "Frontend VM public IP address"
  value       = module.frontend.public_ip
}

output "backend_private_ip" {
  description = "Backend VM private IP address"
  value       = module.backend.private_ip
}

output "database_private_ip" {
  description = "Cloud SQL database private IP address"
  value       = module.database.private_ip
}

output "database_connection_name" {
  description = "Cloud SQL instance connection name"
  value       = module.database.connection_name
}

output "instructions" {
  description = "Instructions to access and test the application"
  value       = <<-EOT
    ========================================
    TODO Application Deployed Successfully!
    ========================================
    
    Frontend URL: http://${module.frontend.public_ip}
    
    Please wait 2-3 minutes for the VMs to complete their startup scripts.
    Then open the URL above in your browser to access the TODO application.
    
    To verify backend health:
      curl http://${module.frontend.public_ip}/health
  EOT
}
