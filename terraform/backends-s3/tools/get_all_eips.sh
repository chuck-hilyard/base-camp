#!/bin/bash

function cleanup {
  rm -f all_eips_rl_media_sandbox.src all_eips_rl_tools.src
  rm -f all_eips_rl_media_sandbox.txt all_eips_rl_tools.txt
}

function format_tf_file {

cat <<HereDoc > all_eips.tf
variable "elastic_ips_preprod" {
  default = [ $(cat all_eips_rl_media_sandbox.txt) ]
}
variable "elastic_ips_prod" {
  default = [ $(cat all_eips_rl_tools.txt) ]
}
HereDoc
}

regions="ap-southeast-2 us-east-1 eu-central-1 us-west-2"

echo "reading rl-media-sanddbox"
aws ec2 describe-addresses --no-paginate --profile rl-media-sandbox --region us-west-2 |jq -r '.Addresses |.[] |.PublicIp' > all_eips_rl_media_sandbox.src

echo "reading rl-tools"
for region in $regions
  do
    aws ec2 describe-addresses --no-paginate --profile rl-tools --region ${region} |jq -r '.Addresses |.[] |.PublicIp' >> all_eips_rl_tools.src
  done

ip_count=$(wc -l all_eips_rl_media_sandbox.src |awk '{print $1}')
while read ip
  do
    if [ ${ip_count} -eq 1 ]
      then echo -e "\"${ip}/32\"\c" >> all_eips_rl_media_sandbox.txt

      else echo -e "\"${ip}/32\", \c" >> all_eips_rl_media_sandbox.txt
    fi
    ip_count=$(expr ${ip_count} - 1)
  done <all_eips_rl_media_sandbox.src

ip_count=$(wc -l all_eips_rl_tools.src |awk '{print $1}')
while read ip
  do
    if [ ${ip_count} -eq 1 ]
      then echo -e "\"${ip}/32\"\c" >> all_eips_rl_tools.txt

      else echo -e "\"${ip}/32\", \c" >> all_eips_rl_tools.txt
    fi
    ip_count=$(expr ${ip_count} - 1)
  done <all_eips_rl_tools.src




format_tf_file

cleanup
