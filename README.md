# EKS Todo

Monorepo scaffold for a simple todo app built with React, Express.js, Mongoose, and a local DocumentDB-compatible database.

## Structure

- `frontend` - React UI
- `backend` - Express MVC API
- `developmentTools/db` - local DocumentDB Docker Compose setup
- `mongoose` - migration scripts and runner

## Local setup

1. Install dependencies from the repo root.
2. Copy each `*.env.example` file to `*.env` in the matching folder.
3. Start DocumentDB with Docker Compose from `developmentTools/db`.
4. Start the backend and frontend workspaces.

## DocumentDB

The local database image is wired for port `10260`.

If you want to use the command you shared directly, it is:

```bash
docker run -dt -p 10260:10260 --name docdb ghcr.io/documentdb/documentdb/documentdb-local:latest --username demo --password demo
```

Adjust the username, password, and database settings in the env files to match your local setup.

## Notes for K8s practice

This scaffold keeps the app split into separate frontend, backend, database tooling, and migration areas so it can later be mapped into Kubernetes Deployments, Services, and ConfigMaps without restructuring the codebase.