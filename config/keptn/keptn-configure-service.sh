#!/bin/bash

set -o errexit
set -o nounset

proj_name=dotnetcoretest

export GIT_USER=ironreality
export GIT_REMOTE_URL=https://github.com/ironreality/dotnet-core-test-config
export GIT_TOKEN=

echo "Creating keptn's project..."
keptn create project "${proj_name}" --shipyard=./shipyard.yaml --git-user=$GIT_USER --git-token=$GIT_TOKEN --git-remote-url=$GIT_REMOTE_URL

echo "Creating keptn's service..."
keptn onboard service "${proj_name}" --project="${proj_name}" --chart=../charts/dotnetcoretest

echo "Adding keptn's test configuration..."
keptn add-resource --project="${proj_name}" --stage=qa --service="${proj_name}" --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
keptn add-resource --project="${proj_name}" --stage=staging --service="${proj_name}" --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx

# keptn send event new-artifact --project="${proj_name}" --service="${proj_name}" --image=ironreality/dotnet-core-test --tag=0.0.2

# prometheus
keptn configure monitoring prometheus --project="${proj_name}" --service="${proj_name}"

keptn add-resource --project="${proj_name}" --stage=staging --service="${proj_name}" --resource=sli-config-prometheus-bg.yaml --resourceUri=prometheus/sli.yaml
keptn add-resource --project="${proj_name}" --stage=staging --service="${proj_name}" --resource=slo-quality-gates.yaml --resourceUri=slo.yaml
