#!/bin/bash
echo "📡 Checking health of the production container..."

# Attempt to fetch the website headers from port 8081
HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:8081 || echo "000")

echo "Container responded with HTTP Status Code: $HTTP_STATUS"

if [ "$HTTP_STATUS" -eq 200 ]; then
    echo "✅ PRODUCTION HEALTH CHECK PASSED: Bunny's Bistro is serving customers safely!"
    exit 0
else
    echo "❌ PRODUCTION HEALTH CHECK FAILED: Web server is unreachable or throwing errors!"
    exit 1
fi
