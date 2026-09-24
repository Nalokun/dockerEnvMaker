# to run envs
## projectAlzero_Strapi&Next.js
```bash
docker build -t my-app .
docker run -p 8080:8080 my-app
```
## Obsidian
```bash
mkdir -p config vault
docker compose up -d
# بعدها فاتحhttps://localhost:3001
```
## delete allenv :
```bash
docker system prune -a --volumes -f
```

