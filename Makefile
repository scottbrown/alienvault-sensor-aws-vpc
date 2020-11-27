.DEFAULT_GOAL: help

# Taken from https://cybersecurity.att.com/documentation/usm-anywhere/deployment-guide/aws/deploying-aws-sensor.htm 
download.location := https://s3.amazonaws.com/downloads.alienvault.cloud/usm-anywhere/sensor-images
output.file := usm-anywhere-sensor-aws-vpc.template

yaml.file := $(output.file).yml

.PHONY: help
help: ## show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: download-original
download-original: ## Download the original CFN template from AT&T
	curl -o $(output.file) "$(download.location)/$(output.file)"

.PHONY: convert-to-yaml
convert-to-yaml: ## Convert JSON template to YAML
	@ruby -e "require 'json'; require 'yaml'; puts YAML.dump(JSON.parse(File.read('$(output.file)')))" > $(yaml.file)

.PHONY: list-amis
list-amis: ## Lists the AMIs available for use with the sensor
	@jq '.Mappings.RegionMap | to_entries[] | [.key, .value.AMI]' $(output.file)

.PHONY: ami
ami: ## Lists the AMI for a given REGION
ifndef REGION
	@echo "You need to supply a REGION"; exit 1
endif
	@jq '.Mappings.RegionMap | to_entries[] | [.key, .value.AMI] | select(.[0] == "$(REGION)")' $(output.file)
