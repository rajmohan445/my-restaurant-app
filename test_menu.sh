#!/bin/bash
echo "--- Starting Automated Quality Assurance Tests ---"

# Test 1: Make sure the file actually contains the Diner Title
if grep -q "The Jenkins Diner" index.html; then
    echo "✅ Test 1 Passed: Restaurant branding is intact."
else
    echo "❌ Test 1 Failed: Restaurant branding missing!"
    exit 1
fi

# Test 2: Catch accidental massive price typos (e.g., checking for any triple-digit prices like $100-$999)
if grep -q '\$[0-9]\{3\}\.[0-9]\{2\}' index.html; then
    echo "❌ Test 2 Failed: Found a suspicious menu price over $100! Rejecting build."
    exit 1
else
    echo "✅ Test 2 Passed: All prices are within normal ranges."
fi

echo "🎉 All tests passed successfully! Code is safe to bundle."
