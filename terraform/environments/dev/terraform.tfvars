project_id                 = "your-project-id" # replace with your project id
region                     = "asia-northeast1"     # replace with your region
deepclaude_version         = "latest"
nginx_repository_id        = "deepclaude-nginx-repo"
web_repository_id          = "deepclaude-web-repo"
api_repository_id          = "deepclaude-api-repo"
secret_key                 = "NbZIVZCrQoyGshzu8o+6WQnw81r1axlYUk3435cJmvGmDLHWPhJebvfC" # replace with a generated value (run command `openssl rand -base64 42`)
cloud_run_ingress          = "INGRESS_TRAFFIC_ALL" # recommend to setup load balancer and use "INGRESS_TRAFFIC_INTERNAL_LOAD_BALANCER"
