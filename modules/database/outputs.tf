output "instance_name" {
  value = google_sql_database_instance.db.name
}

output "private_ip" {
  value = google_sql_database_instance.db.private_ip_address
}

output "database_name" {
  value = google_sql_database.todoapp.name
}

output "database_user" {
  value = google_sql_user.todouser.name
}

output "database_password" {
  value     = google_sql_user.todouser.password
  sensitive = true
}

output "connection_name" {
  value = google_sql_database_instance.db.connection_name
}
