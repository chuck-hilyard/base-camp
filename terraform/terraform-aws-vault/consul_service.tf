/*
* - this is the endpoint health check for this service
* - the address should be the endpoint you want monitored
* - make certain tags are provided, otherwise prometheus may not monitor correctly
* - tag format is "endpoint_health_check", "prometheus module", "return code", "return message"
*/
resource "consul_service" "service" {
	address = "http://${var.service_name}/${var.service_name}/health/status" 
	name = "${var.service_name}-${var.environment}-${var.platform}"
	tags = ["url_health_check", "http_2xx", "200"]
}

