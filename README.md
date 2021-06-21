# Toggl SRE Home Assignment
Provision and configure required infrastructure in GCP.

### Reqs
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

### Outputs
- Load Balancer IP
- Nameservers to point your DNS Zone.

## Components description
#### Instances
Installation, configuration, etc inside the instances is done using user-data at launch. 

#### API
The app is deployed using Docker.
Docker image was built (see `data/Dockerfile`) and pushed to `https://hub.docker.com/r/nachor22/toggl_api/`
Autoscale is configured based on CPU utilization.

#### GCP Region & Zone
Region `us-central1` and zone `us-central1` are used by default to create resources.
Beacuse of the `IN_USE_ADDRESS` quota that limits to 4 IPs, the consul cluster is created in zone `us-east1-b`

#### DB
Postgres 9.6 deployed using Docker.
Creates DB, user and pass for api

#### Load Balancer
Accesible via IP (terraform output) or domain (toggl_test.example.com)
- Static content served from bucket
- `/` redirects to `/index.html`
- `/api/*` routed to API servers
- `/ui/` routed to Consul UI

#### Consul servers
Consul cluster with 3 servers.
DB and API instances run client agents and register services with healthchecks.
Members join the cluster using Cloud Auto-Join

#### DNS
Creates toggl_test.\{dns_zone\} record, pointing to the Load Balancer IP.
Set `TF_VAR_dns_zone` and point NS of your zone to the shown in outputs.
By default `toggl_test.nachor22.tk`

## Note
Many decisions or configurations where made considering this is a test and in order to keep it simple.
