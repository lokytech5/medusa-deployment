#!/bin/sh
set -e

cd /server/.medusa/server
export NODE_ENV=production

echo "Running database migrations..."
npx medusa db:migrate

echo "Starting Medusa production server..."
npm run start