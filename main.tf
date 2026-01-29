module "network" {
  source = "./modules/network"
  region = var.region
}

module "database" {
  source                = "./modules/database"
  region                = var.region
  vpc_id                = module.network.vpc_id
  authorized_network_ip = var.authorized_network_ip
  database_name         = var.database_name
  database_user         = var.database_user
  database_password     = var.database_password

  depends_on = [module.network]
}

module "backend" {
  source       = "./modules/backend"
  zone         = var.zone
  subnet_id    = module.network.private_subnet
  db_host      = module.database.private_ip
  db_name      = module.database.database_name
  db_user      = module.database.database_user
  db_password  = module.database.database_password
  repo_url     = var.github_repo_url
  vm_name      = var.backend_vm_name
  machine_type = var.backend_machine_type
  image_name   = var.backend_image

  depends_on = [module.database]
}

module "frontend" {
  source       = "./modules/frontend"
  zone         = var.zone
  subnet_id    = module.network.public_subnet
  backend_ip   = module.backend.private_ip
  repo_url     = var.github_repo_url
  vm_name      = var.frontend_vm_name
  machine_type = var.frontend_machine_type
  image_name   = var.frontend_image

  depends_on = [module.backend]
}
