#!/bin/bash

set -o errexit
set -o pipefail

HOST=https://your.host.name
KEY=""

set -o nounset

echo "Exporting Grafana dashboards from $HOST"
rm -rf dashboards
mkdir -p dashboards
for dash in $(curl -s -H "Authorization: Bearer $KEY" "$HOST/api/search?query=&" | jq -r '.[] | select(.type == "dash-db") | .uid'); do
	curl -s -H "Authorization: Bearer $KEY" "$HOST/api/dashboards/uid/$dash" | jq -r > dashboards/${dash}.json
	slug=$(cat dashboards/${dash}.json | jq -r '.meta.slug')
	mv dashboards/${dash}.json dashboards/${dash}-${slug}.json
done
