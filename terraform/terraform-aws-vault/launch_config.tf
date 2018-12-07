// In order to update a Launch Configuration, Terraform will destroy the existing resource and create a replacement.
resource "aws_launch_configuration" "terraform_launch_configuration" {
  image_id = "${var.ecs_optimized_image_id}"
  instance_type = "t2.medium"
  key_name = "${var.key_name}"
  security_groups = ["${data.aws_security_group.default_security_group.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.launch_config_instance_profile.name}"
  user_data = <<HereDoc
#!/bin/bash
# core comands
rm -f /var/lib/ecs/data/ecs_agent_data.json
echo ECS_CLUSTER=${var.service_name}-${var.environment}-${var.platform} > /etc/ecs/ecs.config
echo ECS_CHECKPOINT=false >> /etc/ecs/ecs.config
stop ecs
echo prepend domain-name-servers ${var.on_prem_dns}\; >> /etc/dhcp/dhclient.conf
echo supersede domain-search \"${var.fqdn}\"\; >> /etc/dhcp/dhclient.conf
yum update -y
ln -sf /usr/share/zoneinfo/${var.timezone} /etc/localtime
echo -e "ZONE=\"${var.timezone}\"\nUTC=true" > /etc/sysconfig/clock
mkdir -p /rl/{product,data/shared/configs,data/logs};chmod -R 777 /rl
sleep 2
reboot
HereDoc

  // aws won't change/delete a launch configuration tied to an auto scaling group.
  lifecycle {
    create_before_destroy = true
  }
}
#"  <--- this is here to fix the color formatting in vim.  the above here doc escapes screwed it up
