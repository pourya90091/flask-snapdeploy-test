# Use an official, slim Python image
FROM python:3.12-slim

# Set environment variables to keep Python from buffering output
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Copy only requirements first to leverage Docker layer caching
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application code
COPY . .

# Expose the port (SnapDeploy detects this, but good practice)
EXPOSE 8000

# Run the application with Gunicorn
# Bind to 0.0.0.0 so SnapDeploy can reach it, and use the PORT env var if set
CMD ["sh", "-c", "gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 --threads 4 app:app"]