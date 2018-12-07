
/* 
* CAUTION: TOP LEVEL CONFIGURATION
*/

// data sources
data "consul_keys" "private" {
	datacenter = "${var.environment}-${var.platform}"
	key {
		name = "sumo_access_id"
		path = "human_maintained/sumo_access_id"
		default = "no_key_found"
	}
	key {
		name = "sumo_access_key"
		path = "human_maintained/sumo_access_key"
		default = "no_key_found"
	}
	key {
		name = "newrelic_license"
		path = "human_maintained/newrelic_license"
		default = "no_key_found"
	}
}


// inputs
variable "secret_key" { default = "" }
variable "access_key" { default = "" }
variable "on_prem_dns" {
  type = "map"
  default = {
    dev-usa  = "10.10.21.1"
    qa-aus   = "10.10.21.1"
    qa-can   = "10.10.21.1"
    qa-eur   = "10.10.21.1"
    qa-gbr   = "10.10.21.1"
    qa-jpn   = "10.10.21.1"
    qa-usa   = "10.10.21.1"
    prod-aus = "10.10.21.1"
    prod-can = "10.104.16.20"
    prod-eur = "10.107.16.20"
    prod-gbr = "10.107.16.20"
    prod-jpn = "10.106.16.20"
    prod-usa = "10.10.21.1"
  }
}
variable "ecs_optimized_image_id" {
  type = "map"
  default = {
    us-west-2      = "ami-10ed6968"
    us-east-1      = "ami-a7a242da"
    ap-southeast-2 = "ami-ee884f8c"
    eu-central-1   = "ami-0799fa68"
    ap-northeast-1 = "ami-68ef940e"
  }
}
// values reflect /usr/share/zoneinfo/ files on ecs-optimized AWS ami's
variable "timezones" {
  type = "map"
  default = {
    us-west-2      = "America/Los_Angeles"
    us-east-1      = "America/New_York"
    ap-southeast-2 = "Australia/Sydney"
    eu-central-1   = "Europe/Zurich"
    ap-northeast-1 = "Asia/Tokyo"
  }
}
variable "top_level_domains" {
  type = "map"
  default = {
    dev-usa  = "reachlocal.com"
    qa-aus   = "reachlocal.com"
    qa-can   = "reachlocal.com"
    qa-eur   = "reachlocal.com"
    qa-gbr   = "reachlocal.com"
    qa-jpn   = "reachlocal.com"
    qa-usa   = "reachlocal.com"
    prod-aus = "reachlocal.com.au"
    prod-can = "reachlocal.ca"
    prod-eur = "reachlocal.eu"
    prod-gbr = "reachlocal.co.uk"
    prod-jpn = "reachlocal.co.jp"
    prod-usa = "reachlocal.com"
  }
}
variable "subnets_web" {
  type = "map"
  default = {
    dev-usa  = ["subnet-8497e4e3", "subnet-cab32683"]
    qa-aus   = ["subnet-8497e4e3", "subnet-cab32683"]
    qa-can   = ["subnet-8497e4e3", "subnet-cab32683"]
    qa-eur   = ["subnet-8497e4e3", "subnet-cab32683"]
    qa-gbr   = ["subnet-8497e4e3", "subnet-cab32683"]
    qa-jpn   = ["subnet-8497e4e3", "subnet-cab32683"]
    qa-usa   = ["subnet-8497e4e3", "subnet-cab32683"]
    prod-aus = ["subnet-deee3497", "subnet-50c86337"]
    prod-can = ["subnet-dac20a87", "subnet-3a67015e"]
    prod-eur = ["subnet-27e7794c", "subnet-4be03136"]
    prod-gbr = ["subnet-27e7794c", "subnet-4be03136"]
    prod-jpn = ["subnet-2597db6c", "subnet-c2883099"]
    prod-usa = ["subnet-f97c8680", "subnet-7ab15531"]
  }
}
variable "subnets_app" {
  type = "map"
  default = {
    dev-usa  = ["subnet-a295e6c5", "subnet-63b92c2a"]
    qa-aus   = ["subnet-a295e6c5", "subnet-63b92c2a"]
    qa-can   = ["subnet-a295e6c5", "subnet-63b92c2a"]
    qa-eur   = ["subnet-a295e6c5", "subnet-63b92c2a"]
    qa-gbr   = ["subnet-a295e6c5", "subnet-63b92c2a"]
    qa-jpn   = ["subnet-a295e6c5", "subnet-63b92c2a"]
    qa-usa   = ["subnet-a295e6c5", "subnet-63b92c2a"]
    prod-aus = ["subnet-50ea3019", "subnet-24f55e43"]
    prod-can = ["subnet-90cc04cd", "subnet-09197f6d"]
    prod-eur = ["subnet-fbe97790", "subnet-42e3323f"]
    prod-gbr = ["subnet-fbe97790", "subnet-42e3323f"]
    prod-jpn = ["subnet-4794d80e", "subnet-7f972f24"]
    prod-usa = ["subnet-56b3571d", "subnet-517b8128"]
  }
}
variable "subnets_admin" {
  type = "map"
  default = {
    dev-usa  = ["subnet-4299ea25", "subnet-39bd2870"]
    qa-aus   = ["subnet-4299ea25", "subnet-39bd2870"]
    qa-can   = ["subnet-4299ea25", "subnet-39bd2870"]
    qa-eur   = ["subnet-4299ea25", "subnet-39bd2870"]
    qa-gbr   = ["subnet-4299ea25", "subnet-39bd2870"]
    qa-jpn   = ["subnet-4299ea25", "subnet-39bd2870"]
    qa-usa   = ["subnet-4299ea25", "subnet-39bd2870"]
    prod-aus = ["subnet-4def3504", "subnet-c4f75ca3"]
    prod-can = ["subnet-b9d911e4", "subnet-611a7c05"]
    prod-eur = ["subnet-cbe779a0", "subnet-47e0313a"]
    prod-gbr = ["subnet-cbe779a0", "subnet-47e0313a"]
    prod-jpn = ["subnet-6b90dc22", "subnet-be942ce5"]
    prod-usa = ["subnet-95b054de", "subnet-d47e84ad"]
  }
}
variable "subnets_db" {
  type = "map"
  default = {
    dev-usa  = ["subnet-a395e6c4", "subnet-45bd280c"]
    qa-aus   = ["subnet-a395e6c4", "subnet-45bd280c"]
    qa-can   = ["subnet-a395e6c4", "subnet-45bd280c"]
    qa-eur   = ["subnet-a395e6c4", "subnet-45bd280c"]
    qa-gbr   = ["subnet-a395e6c4", "subnet-45bd280c"]
    qa-jpn   = ["subnet-a395e6c4", "subnet-45bd280c"]
    qa-usa   = ["subnet-a395e6c4", "subnet-45bd280c"]
    prod-aus = ["subnet-57f42e1e", "subnet-3ff45f58"]
    prod-can = ["subnet-dac20a87", "subnet-3a67015e"]
    prod-eur = ["subnet-f4e7799f", "subnet-04fe2f79"]
    prod-gbr = ["subnet-f4e7799f", "subnet-04fe2f79"]
    prod-jpn = ["subnet-4494d80d", "subnet-18952d43"]
    prod-usa = ["subnet-55b5511e", "subnet-dd7d87a4"]
  }
}
/* these reside in us-east-1 only
*  aka - "*.dev.usa.reachlocalservices.com, *.prod.gbr.reachlocalservices.com, etc."
*/
variable "subdomain_certs" {
  type = "map"
  default = {
    dev-usa  = "arn:aws:acm:us-east-1:762858336698:certificate/2fec6ed9-b119-450f-b9e4-a4cf312980a2"
    qa-aus   = "arn:aws:acm:us-east-1:762858336698:certificate/018e4fe4-b6a2-4bf7-b6fc-f585094ae226"
    qa-can   = "arn:aws:acm:us-east-1:762858336698:certificate/05cc3cfe-e4d6-4531-8af5-b3ddac9ac6da"
    qa-eur   = "arn:aws:acm:us-east-1:762858336698:certificate/ce9b230c-4816-4497-bc5b-c472a41d3c37"
    qa-gbr   = "arn:aws:acm:us-east-1:762858336698:certificate/baf7ec09-4758-4ffc-a97d-e52509f6ec7d"
    qa-jpn   = "arn:aws:acm:us-east-1:762858336698:certificate/4cef669c-86a9-4a6a-96f2-d8d24f878675"
    qa-usa   = "arn:aws:acm:us-east-1:762858336698:certificate/cd74fe45-9cde-4f59-87ab-a496b31f892d"
    prod-aus = "arn:aws:acm:us-east-1:696165013664:certificate/2d2d7bfc-0e68-4c1d-be86-db6154cb3e63"
    prod-can = "arn:aws:acm:us-east-1:696165013664:certificate/6f1aac9d-0407-42f1-9aa1-3366cf9d2908"
    prod-eur = "arn:aws:acm:us-east-1:696165013664:certificate/95dab1ab-4a1e-4902-aed8-de8106aa3b36"
    prod-gbr = "arn:aws:acm:us-east-1:696165013664:certificate/79940eea-68d6-455d-b541-84b9f788d890"
    prod-jpn = "arn:aws:acm:us-east-1:696165013664:certificate/812f8c87-de70-4098-b779-a87bf87695de"
    prod-usa = "arn:aws:acm:us-east-1:696165013664:certificate/41064092-0535-4263-bfad-90c06241c2ed"
  }
}
/* these reside in us-east-1 only
*  aka - "reachlocal.com, reachlocal.eu, reachlocal.com.au, etc."
*/
variable "top_level_certs" {
  type = "map"
  default = {
    dev-usa  = ""
    qa-aus   = ""
    qa-can   = ""
    qa-eur   = ""
    qa-gbr   = ""
    qa-jpn   = ""
    qa-usa   = ""
    prod-aus = "arn:aws:acm:us-east-1:696165013664:certificate/db7d4d26-2565-4e45-a482-4b203097431e"
    prod-can = "arn:aws:acm:us-east-1:696165013664:certificate/98b722a9-053a-4b29-9e56-c994ca345a29"
    prod-eur = "arn:aws:acm:us-east-1:696165013664:certificate/238158ff-8c35-4699-bcb8-86730c48e9a7"
    prod-gbr = "arn:aws:acm:us-east-1:696165013664:certificate/c96927e0-2ae4-4a38-b0be-d63e1f4a5232"
    prod-jpn = "arn:aws:acm:us-east-1:696165013664:certificate/102b11e9-3c7c-4942-829a-e6d734fdb59e"
    prod-usa = "arn:aws:acm:us-east-1:696165013664:certificate/44646eaa-03da-4254-bcc0-b7800e3b8602"
  }
}
// these reside in their specific region
variable "regional_cert_hash" {
  type = "map"
  default = {
    dev-usa  = "arn:aws:acm:us-west-2:762858336698:certificate/26bf9459-935c-4df1-8fed-4c9c84f2e290"
    qa-aus   = "arn:aws:acm:us-west-2:762858336698:certificate/71873a49-e2bc-4831-bd30-3757c2df8d62"
    qa-can   = "arn:aws:acm:us-west-2:762858336698:certificate/2f1ba5d8-2798-4737-8fae-aa685288ec1f"
    qa-eur   = "arn:aws:acm:us-west-2:762858336698:certificate/63be94e1-06b8-4ebc-b3af-c32578c96f41"
    qa-gbr   = "arn:aws:acm:us-west-2:762858336698:certificate/b0c1a97a-2c58-4bd7-adb4-ab4188222738"
    qa-jpn   = "arn:aws:acm:us-west-2:762858336698:certificate/583ec4ea-d18c-465c-a38f-e5571cfa5ac1"
    qa-usa   = "arn:aws:acm:us-west-2:762858336698:certificate/07fb1a6d-11e0-46a4-a773-35f5b34feab2"
    prod-aus = "arn:aws:acm:ap-southeast-2:696165013664:certificate/27d4b3d2-e03e-4d92-aeb8-d92401504cb5"
    prod-can = "arn:aws:acm:us-east-1:696165013664:certificate/6f1aac9d-0407-42f1-9aa1-3366cf9d2908"
    prod-gbr = "arn:aws:acm:eu-central-1:696165013664:certificate/eced6539-b1f9-42d0-a85a-a753b266f788"
    prod-eur = "arn:aws:acm:eu-central-1:696165013664:certificate/7afc0880-0309-4758-935e-4a33f5a4ae3b"
    prod-jpn = "arn:aws:acm:ap-northeast-1:696165013664:certificate/9ae57693-7a2b-4d87-a711-cbcf04b7ccbc"
    prod-usa = "arn:aws:acm:us-west-2:696165013664:certificate/96f01999-c705-43f3-9418-47efdd95a480"
  }
}

variable "encrypted_data_key_hash" {
  type = "map"
  default = {
    dev-usa  = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gERMkkn52bNrPU/5A6/suHKAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMYvb1GiVIoqgej2lyAgEQgDvfQ5FBlIzS0H6dC5aHWqvPIZ7nMeDENirxv9RWPj5ck/v11+qe0JPBXf1S6BROiE+RUsFOxu8t1X2cvw=="
    qa-aus   = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gGHKWG0TQOIKEQv8CZFu6JaAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM/As1W5Jr8e+hb6XyAgEQgDvomHCuzN22ipLJqvZ71+oIFl/US/4ojSDzgkwEFCn/W11QvXZ6uLBXD4/4F65MgDoMWFH860Q8dFRbVA=="
    qa-can   = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gEveeiBLmKZ9YVLTP00VeuCAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM7/HSupYvfi5VYeDQAgEQgDsd+du3lSrpd9WA8Ywm2o1yykKxV6EY/0QKhY1LElGH7SKpNYxUn6/3EN1PsUNvRE9Nk65MNr+kjFAoeA=="
    qa-eur   = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gGwmTcafT+Nzptu2V7RpMngAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQM+ZXCpIwKPmiscFj5AgEQgDtGbPkHsmuUgr7R0l/kGVvAMKuaT7NgTxTBFxYNDdxPl7ctPpP3lj+1sd07plk6+5YhS3btTf+6bTq0tQ=="
    qa-gbr   = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gGeSY/vb9zEWEjlm3jkUKvdAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMkn4pY4fuh7trrLkbAgEQgDvcCuMW2bUwK8k2JD4ARyzzToYzr8h2rW3tMr3m2wxVOSDqmiMgX0frq3FrsFoP0HxCcNA4S+HCTRO8GQ=="
    qa-jpn   = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gHdRJ79/9PIPfpIYI48BtxWAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMTjYJfS5VgFAfW8c3AgEQgDtA0PeShxtyLmennHoFKDJU0+btVmh0lLVPxWA/7gzua3XLgLf4ndxI/zbkHJzgnWNw6rmtn+bxH3NEJw=="
    qa-usa   = "AQIDAHgbrG+sivN8FzLNFXsbZyPOpZj5ofJCjVbjY8yM1aFd/gERMkkn52bNrPU/5A6/suHKAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMYvb1GiVIoqgej2lyAgEQgDvfQ5FBlIzS0H6dC5aHWqvPIZ7nMeDENirxv9RWPj5ck/v11+qe0JPBXf1S6BROiE+RUsFOxu8t1X2cvw=="
    prod-aus = "AQIDAHhkiCUiuJzIb04C8Klek3EZ/5WXKlxHn9/RcLkYBWbXygHubtQszdzwlHNMT6V0wiYwAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMk8GkDMb2+e/zsUyZAgEQgDvh7zJscM/7cetdG/L8fIhV23qZDd4lgZc+0nv4qPqKa6MSocj0/HAXhaYuKkrZ8+fmEvlab8rwie9vbg=="
    prod-can = "AQIDAHgUN7h+3CS8Y+1htsHEW7THZf4pzYc/WaGcGjHytMjVnwFeATRMeCvYUevTfgEK6cakAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMRHcl5zEsLYCCL8c3AgEQgDu0WH95o19nNIhpIS9SueHMzZkJBXNTXdoiX0z43D89chg6Mzf+3II68VlE013uDPDz6J14elV6zTmw9A=="
    prod-gbr = "AQIDAHijSr/yiveSqzlz2PLzpk80mSHnhH4aAjpfBrm1zBUNTAGzm+DMNKk/U7zLpGYxB/ZwAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMRjf/vISGvy6iLE8MAgEQgDvnq+PEJ66hTgfyPHbDRQ7aU5LBNqiVKzn5EhgsWz5wCIFa2upbXhF/ftOQUouurUGUU+QZ12zJpztDiw=="
    prod-eur = "AQIDAHijSr/yiveSqzlz2PLzpk80mSHnhH4aAjpfBrm1zBUNTAGzm+DMNKk/U7zLpGYxB/ZwAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMRjf/vISGvy6iLE8MAgEQgDvnq+PEJ66hTgfyPHbDRQ7aU5LBNqiVKzn5EhgsWz5wCIFa2upbXhF/ftOQUouurUGUU+QZ12zJpztDiw=="
    prod-jpn = "AQIDAHjFZ5COhv2f4MR4pJeBEJHxe3qo2bVOc8+Pa9ER8o5XCAGKu6aMe01LpuqtN5/ktF1hAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMSEHUDqpCrm+okwTNAgEQgDt+msoQHai7xXkGmHl+VWpPl4ihHDt+DaOEbjXs43A5gkqYj8zJWflbxUSLaR+YG/JUeyl2DNPhf4O3OQ=="
    prod-usa = "AQIDAHhv6vNNKd/u79jDu5lkp8lOsBD7aGJXeJ28VzrP4VSgNgGmWEDb4LXUwRWNTmb9pSITAAAAfjB8BgkqhkiG9w0BBwagbzBtAgEAMGgGCSqGSIb3DQEHATAeBglghkgBZQMEAS4wEQQMie14jgnYnizh+qtCAgEQgDuc2UYWyCCf1+RdxfO6fw3FTwualALSOyUuEz2CZlPzDMq5D2yOcZbvz+TsYnosKQNwuSbLWBV+D+uPLQ=="
  }
}


//outputs




