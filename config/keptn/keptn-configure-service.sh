#!/bin/bash

set -o errexit
set -o nounset

proj_name=dotnetcoretest

echo "Creating keptn's service..."
keptn onboard service "${proj_name}" --project="${proj_name}" --chart=../charts/dotnetcoretest
echo

echo "Adding Jmeter's basic test configuration for qa stage..."
keptn add-resource --project="${proj_name}" --stage=qa --service="${proj_name}" --resource=jmeter/basiccheck.jmx --resourceUri=jmeter/basiccheck.jmx
echo

echo "Adding Jmeter's performance test configuration for staging stage..."
keptn add-resource --project="${proj_name}" --stage=staging --service="${proj_name}" --resource=jmeter/load.jmx --resourceUri=jmeter/load.jmx
echo

# prometheus
echo "Configure Prometheus monitoring..."
keptn configure monitoring prometheus --project="${proj_name}" --service="${proj_name}"
echo

echo "Creating SLI config for stage: staging..."
keptn add-resource --project="${proj_name}" --stage=staging --service="${proj_name}" --resource=sli-config-prometheus-bg.yaml --resourceUri=prometheus/sli.yaml
echo

echo "Creating SLO config for stage: staging..."
keptn add-resource --project="${proj_name}" --stage=staging --service="${proj_name}" --resource=slo-quality-gates.yaml --resourceUri=slo.yaml
echo

echo "Creating SLI config for stage: production..."
keptn add-resource --project="${proj_name}" --stage=production --service="${proj_name}" --resource=sli-prod.yaml --resourceUri=prometheus/sli.yaml
echo

echo "Creating SLI/SLO configs for stage: production..."
keptn add-resource --project="${proj_name}" --stage=production --service="${proj_name}" --resource=slo-prod.yaml --resourceUri=slo.yaml
echo
