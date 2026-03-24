#!/bin/sh

set -e

echo "Running database migrations..."
npx medusa db:migrate

echo "Starting Medusa production server..."
npm run start