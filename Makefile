.DEFAULT_GOAL: help

# Taken from https://cybersecurity.att.com/documentation/usm-anywhere/deployment-guide/aws/deploying-aws-sensor.htm 
download.location := https://s3.amazonaws.com/downloads.alienvault.cloud/usm-anywhere/sensor-images
output.file := usm-anywhere-sensor-aws-vpc.template

.PHONY: help
help: ## show this message
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: download-original
download-original: ## Download the original CFN template from AT&T
	curl -o $(output.file) "$(download.location)/$(output.file)"

