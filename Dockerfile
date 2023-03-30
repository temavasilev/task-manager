# ---- Backend build stage ----
FROM python:3.10-slim-buster as backend-build

WORKDIR /app/backend

COPY backend .

# ---- Frontend build stage ----
FROM node:18-alpine as frontend-build

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm ci

COPY frontend .
RUN npm run build

# ---- Final stage ----
FROM nginx:1.23.4-alpine-slim as production

# Copy the Vue.js build output from the frontend-build stage
COPY --from=frontend-build /app/frontend/dist /usr/share/nginx/html

# Copy the backend files from the backend-build stage
COPY --from=backend-build /app/backend /app/backend

# Install required packages for backend
RUN apk add --no-cache python3 py3-pip
RUN apk add --no-cache supervisor
RUN pip3 install --no-cache-dir gunicorn
RUN pip3 install --no-cache-dir -r /app/backend/requirements.txt

# Create a gunicorn config file
RUN printf 'workers = 2\n\
bind = "0.0.0.0:5000"\n\
chdir = "/app/backend"\n\
wsgi_app = "app:app"\n'\
> /app/backend/gunicorn.conf.py

# Create a supervisord config file
RUN printf '[supervisord]\nnodaemon=true\n\n\
[program:gunicorn]\ncommand=gunicorn -c /app/backend/gunicorn.conf.py\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
stderr_logfile=/dev/stderr\n\
stderr_logfile_maxbytes=0\n\
\n\
[program:nginx]\ncommand=nginx -g "daemon off;"\n\
stdout_logfile=/dev/stdout\n\
stdout_logfile_maxbytes=0\n\
stderr_logfile=/dev/stderr\n\
stderr_logfile_maxbytes=0\n'\
> /app/backend/supervisord.conf

# Expose the ports for the backend and frontend
EXPOSE 5000 80

# Start Nginx and Gunicorn
CMD ["supervisord", "-c", "/app/backend/supervisord.conf"]