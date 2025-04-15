# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set environment variables
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    PIP_NO_CACHE_DIR=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Set work directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker cache
COPY requirements.txt .
COPY setup.py .
COPY README.md .

# Install Python dependencies
RUN pip install --no-cache-dir -e .

# Copy the rest of the application
COPY src/ src/
COPY scripts/ scripts/
COPY data/ data/

# Create output directory
RUN mkdir -p output/data

# Set default command to show usage
CMD ["python", "-c", "import sys; print('Product Recommendation System\\n\\nAvailable commands:\\n1. Data Preprocessing:\\n   python scripts/preprocess_data.py\\n\\n2. Feature Engineering:\\n   python scripts/engineer_features.py\\n\\n3. Train Model:\\n   python scripts/train_model.py\\n\\nFor more options, add --help to any command.')"]
