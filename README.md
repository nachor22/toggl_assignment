# toggl_assignment
## Toggl SRE Home Assignment


Doc

## Reqs
In order to execute this provisioning, you need to:
- Create GCP clean project
- Create service account, with at least roles: `Editor` and `IAM Security Admin`
- Add and download json key

Environment variables expected to be set:
- `GOOGLE_APPLICATION_CREDENTIALS` path to json key file
- `TF_VAR_project` GCP project id
- `TF_VAR_dns_zone` DNS zone, used to create records with Cloud DNS. Default:`nachor22.tk`

### Running provisioning
- Terraform installed
- Above env vars defined
- Run `terraform init`
- Run `terraform apply`
- When you are done `terraform destroy`

##Outputs
- Load Balancer IP
- Nameservers to point your DNS Zone.

##API
The app is deployed using Docker.
Docker image was built (see `data/Dockerfile`) and pushed to `https://hub.docker.com/layers/nachor22/toggl_api/`

##GCP Region & Zone
defaults and separated because quota

##DB
docker

##Load Balancer
routes

##Consul servers
autojoin

###DNS
Creates toggl_test.\{dns_zone\} record, pointing to the Load Balancer IP.
Set `TF_VAR_dns_zone` and point NS of your zone to the shown in outputs.
By default `toggl_test.nachor22.tk`
