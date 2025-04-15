# Product Recommendation System

A machine learning system for predicting and recommending banking products to customers based on their historical behavior and characteristics.

## Project Structure

- `data/` - Data storage (raw data not committed, only processed data if needed)
  - `data.csv` - Raw input data
  - `data_cleaned.csv` - Cleaned and preprocessed data
  
- `notebooks/` - Jupyter notebooks for experimentation
  - `data_cleaning.ipynb` - Notebook for data exploration and cleaning.
  - `baseline_model.ipynb` - Implements a simple baseline model.
  - `xgb-model.ipynb` - Develops the XGBoost model for product recommendation.
  - `xgb-fe.ipynb` -  Implements XGBoost with additional feature engineering techniques.
  
- `src/` - Main source code
  - `data_cleaning/` - Data cleaning modules
    - `data_types.py` - Data type definitions
    - `data_loader.py` - Data loading utilities
    - `data_cleaner.py` - Data cleaning functions
  - `feature_engineering/` - Feature engineering modules
    - `constants.py` - Feature engineering constants
    - `flank_features.py` - Time-based feature generation
    - `preprocessor.py` - Main preprocessing pipeline
  - `models/` - Model implementations
    - `xgboost_model.py` - XGBoost-based product recommender
    
- `models/` - Trained model artifacts
- `docs/` - Documentation
- `requirements.txt` - Python dependencies
- `Dockerfile` - Container definition for reproducible environment

## Features

- Data cleaning and preprocessing pipeline
- Feature engineering with time-based product change analysis
- XGBoost-based multi-product recommendation system
- Docker containerization

## Requirements

- Python 3.8+
- Docker (optional)

## Installation

### Option 1: Local Installation

1. Create and activate a virtual environment:
   ```bash
   # Create virtual environment
   python -m venv venv

   # Activate on Linux/Mac
   source venv/bin/activate

   # Activate on Windows
   .\venv\Scripts\activate
   ```

2. Clone the repository:
   ```bash
   git clone https://github.com/DataNova/Product-Recommendation.git
   cd Product-Recommendation
   ```

3. Install the package:
   ```bash
   # For development
   pip install -e .
   ```

### Option 2: Docker Installation

1. Build the Docker image:
   ```bash
   docker build -t product-recommender .
   ```

2. Run the container:
   ```bash
   # Show usage information
   docker run product-recommender

   # Run data preprocessing
   docker run -v $(pwd)/data:/app/data -v $(pwd)/output:/app/output \
       product-recommender python scripts/preprocess_data.py

   # Run feature engineering
   docker run -v $(pwd)/data:/app/data -v $(pwd)/output:/app/output \
       product-recommender python scripts/engineer_features.py

   # Train model and generate recommendations
   docker run -v $(pwd)/data:/app/data -v $(pwd)/output:/app/output \
       product-recommender python scripts/train_model.py
   ```

   The `-v` flags create volume mounts to persist data and output files on your local machine.

## Usage - Run Individual Steps

1. Data Preprocessing:
   ```bash
   python scripts/preprocess_data.py
   ```
   Options:
   - `--input_path`: Path to input CSV (default: `./data/data.csv`)
   - `--output_path`: Path for cleaned data (default: `./output/data/cleaned_data.parquet`)

2. Feature Engineering:
   ```bash
   python scripts/engineer_features.py
   ```
   Options:
   - `--input_path`: Path to cleaned data (default: `./output/data/cleaned_data.parquet`)
   - `--output_path`: Path for processed data (default: `./output/data/processed_data.parquet`)
   - `--preprocessor_path`: Path to save preprocessor (default: `./output/data/preprocessor.pkl`)

3. Train and Generate Recommendations:
   ```bash
   python scripts/train_model.py
   ```
   Options:
   - `--input_path`: Path to processed data (default: `./output/data/processed_data.parquet`)
   - `--preprocessor_path`: Path to preprocessor (default: `./output/data/preprocessor.pkl`)
   - `--model_path`: Path to save model (default: `./output/data/model.pkl`)
   - `--predictions_path`: Path for predictions (default: `./output/data/predictions.csv`)
   - `--top_k`: Number of recommendations per customer (default: 5)

### Option 3: Python API

Use the package in your Python code:
```python
from product_recommendation.data_cleaning import load_data, clean_data
from product_recommendation.feature_engineering import DataPreprocessor
from product_recommendation.models import ProductRecommender

# Load and clean data
df = load_data('data/data.csv')
df_cleaned = clean_data(df)

# Create features
preprocessor = DataPreprocessor()
df_processed, feature_columns = preprocessor.fit_transform(df_cleaned)

# Train model and get recommendations
recommender = ProductRecommender()
recommender.train(df_processed, feature_columns)
recommendations = recommender.recommend_products(
    df_processed,
    feature_columns,
    top_k=5
)
```

## Model Performance

The XGBoost-based recommender system is trained separately for each product, using:
- Binary classification with logistic loss
- Tree depth of 8
- Learning rate of 0.1
- Feature subsampling for robustness

## Contributing

1. Fork the repository
2. Create your feature branch
3. Commit your changes
4. Push to the branch
5. Create a new Pull Request

## License

This project is licensed under the MIT License - see the LICENSE file for details.