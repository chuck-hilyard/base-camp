
 # the local_service_ads nice name to the vip
 resource"aws_route53_record" "local_service_ads_vip" {
   name = "local-service-ads"
   zone_id = "${data.aws_route53_zone.route53_zone.zone_id}"
   type = "CNAME"
   ttl = "300"
   records = [
     "${aws_elb.terraform_elb.dns_name}"
   ]
 }
