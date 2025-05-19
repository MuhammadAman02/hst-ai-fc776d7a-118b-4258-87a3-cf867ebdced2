# Build stage
FROM python:3.10-slim AS builder

WORKDIR /app

# Install build dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends gcc python3-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Python dependencies
COPY requirements.txt /app/requirements.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir wheel setuptools && \
    pip wheel --no-cache-dir --wheel-dir=/app/wheels -r requirements.txt

# Final stage
FROM python:3.10-slim

WORKDIR /app

# Copy wheels from builder stage
COPY --from=builder /app/wheels /app/wheels

# Install dependencies from wheels
RUN pip install --no-cache-dir --no-index --find-links=/app/wheels/ /app/wheels/* && \
    rm -rf /app/wheels

# Copy application code
COPY app /app/app
COPY templates /app/templates
COPY static /app/static
COPY main.py /app/main.py

# Ensure template and static directories exist
RUN mkdir -p /app/templates /app/static

# Copy templates and static files to the correct locations
RUN cp -r /app/templates/* /app/app/templates/ 2>/dev/null || true
RUN cp -r /app/static/* /app/app/static/ 2>/dev/null || true

EXPOSE 8000

# Run setup script to ensure templates and static files are properly set up
RUN python -c "import os; os.makedirs('/app/app/templates', exist_ok=True); os.makedirs('/app/app/static', exist_ok=True)"

# Copy templates and static files to app directory
RUN cp -r /app/templates/* /app/app/templates/ 2>/dev/null || true
RUN cp -r /app/static/* /app/app/static/ 2>/dev/null || true

# Run with production settings
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "4", "--proxy-headers"]