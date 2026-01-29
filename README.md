# TODO Application - GCP Deployment

A full-stack TODO application deployed on Google Cloud Platform using Terraform.

## Architecture

```
┌─────────────────┐     ┌─────────────────┐     ┌──────────────────┐
│   Frontend VM   │────▶│   Backend VM    │────▶│  Cloud SQL DB    │
│  (NGINX + UI)   │     │  (Node.js API)  │     │    (MySQL)       │
│   Public IP     │     │   Private IP    │     │   Private IP     │
└─────────────────┘     └─────────────────┘     └──────────────────┘
```

- **Frontend**: Ubuntu VM with NGINX serving HTML/CSS/JavaScript TODO interface
- **Backend**: Ubuntu VM with Node.js/Express REST API
- **Database**: Cloud SQL MySQL instance with private IP
- **Network**: VPC with public and private subnets, VPC peering for Cloud SQL

## Prerequisites

1. **Google Cloud Platform Account** with billing enabled
2. **GCP Project** created
3. **Service Account Key** with permissions:
   - Compute Admin
   - Cloud SQL Admin
   - Service Networking Admin
4. **Terraform** installed (v1.0+)
5. **GCP APIs** enabled:
   - Compute Engine API
   - Cloud SQL Admin API
   - Service Networking API

## Quick Start

### 1. Configure Variables

Edit `terraform.tfvars`:
```hcl
project_id  = "your-gcp-project-id"
credentials = "path/to/your-service-account-key.json"
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review Plan

```bash
terraform plan
```

### 4. Deploy Infrastructure

```bash
terraform apply
```

Wait 5-7 minutes for deployment to complete and VMs to finish startup scripts.

### 5. Access Application

After deployment, Terraform will output the frontend URL:

```
frontend_url = "http://XX.XX.XX.XX"
```

Open this URL in your browser to access the TODO application.

## Features

✅ Create new TODO items  
✅ Mark TODOs as complete/incomplete  
✅ Delete TODO items  
✅ Filter by All/Active/Completed  
✅ Persistent storage in MySQL database  
✅ Modern, responsive UI with animations  
✅ Real-time updates  

## Database Credentials

- **Host**: Private IP (shown in Terraform outputs)
- **Database**: `todoapp`
- **User**: `todouser`
- **Password**: `Todo@123`

## Troubleshooting

### Frontend not loading

```bash
# SSH into frontend VM
gcloud compute ssh front-end --zone=us-central1-a

# Check NGINX status
sudo systemctl status nginx

# Check NGINX logs
sudo tail -f /var/log/nginx/error.log
```

### Backend API not responding

```bash
# SSH into backend VM
gcloud compute ssh backend-vm --zone=us-central1-a

# Check backend service status
sudo systemctl status todoapp

# Check backend logs
sudo journalctl -u todoapp -f
```

### Database connection issues

```bash
# From backend VM, test database connection
mysql -h <DB_PRIVATE_IP> -u todouser -pTodo@123 todoapp
```

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Cost Estimate

- Frontend VM (e2-micro): ~$7/month
- Backend VM (e2-micro): ~$7/month
- Cloud SQL (db-f1-micro): ~$15/month
- **Total**: ~$29/month

## Project Structure

```
.
├── main.tf                 # Main configuration
├── variables.tf           # Variable definitions
├── outputs.tf            # Output definitions
├── provider.tf           # GCP provider config
├── terraform.tfvars      # Variable values
├── modules/
│   ├── network/          # VPC, subnets, firewall
│   ├── database/         # Cloud SQL instance
│   ├── backend/          # Backend VM + API
│   └── frontend/         # Frontend VM + UI
└── app/
    ├── backend/          # Node.js API code
    └── frontend/         # HTML/CSS/JS files
```

## License

MIT
