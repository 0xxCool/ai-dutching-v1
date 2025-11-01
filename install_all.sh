#!/bin/bash
# ============================================================
# 🚀 AI-DUTCHING ML SYSTEM - COMPLETE INSTALLATION SCRIPT
# ============================================================
# 
# Usage: bash install_all.sh
# 
# This script installs all required packages for the 
# AI Dutching ML Training System with GPU Support
#
# ============================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ============================================================
# HELPER FUNCTIONS
# ============================================================
print_header() {
    echo -e "${BLUE}============================================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}============================================================${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

check_command() {
    if command -v $1 &> /dev/null; then
        print_success "$1 is installed"
        return 0
    else
        print_error "$1 is not installed"
        return 1
    fi
}

# ============================================================
# MAIN INSTALLATION
# ============================================================
main() {
    print_header "🚀 AI-DUTCHING ML SYSTEM INSTALLATION"
    echo "Starting complete installation process..."
    echo ""

    # --------------------------------------------------------
    # STEP 1: SYSTEM UPDATES
    # --------------------------------------------------------
    print_header "📦 STEP 1: System Updates & Build Tools"
    
    apt-get update -qq
    apt-get upgrade -y -qq
    
    # Install build essentials
    apt-get install -y -qq \
        build-essential \
        cmake \
        git \
        wget \
        curl \
        vim \
        htop \
        libgomp1 \
        libnccl2 \
        libnccl-dev \
        > /dev/null 2>&1
    
    print_success "System packages updated"

    # --------------------------------------------------------
    # STEP 2: PYTHON PACKAGE MANAGERS
    # --------------------------------------------------------
    print_header "🐍 STEP 2: Python Package Managers"
    
    # Update pip
    pip install --upgrade pip setuptools wheel -q
    print_success "pip updated to $(pip --version | cut -d' ' -f2)"
    
    # Update conda if available
    if command -v conda &> /dev/null; then
        conda update -n base conda -y -q
        print_success "conda updated"
    else
        print_warning "conda not found, skipping"
    fi

    # --------------------------------------------------------
    # STEP 3: REMOVE OLD XGBOOST
    # --------------------------------------------------------
    print_header "🧹 STEP 3: Clean Old XGBoost Installations"
    
    # Remove pip version
    pip uninstall xgboost -y -q 2>/dev/null || true
    
    # Remove conda version if conda exists
    if command -v conda &> /dev/null; then
        conda remove xgboost py-xgboost libxgboost _py-xgboost-mutex -y 2>/dev/null || true
    fi
    
    print_success "Old XGBoost installations removed"

    # --------------------------------------------------------
    # STEP 4: CORE ML LIBRARIES
    # --------------------------------------------------------
    print_header "🤖 STEP 4: Core ML Libraries"
    
    echo "Installing PyTorch with CUDA..."
    pip install torch==2.3.1 torchvision torchaudio --index-url https://download.pytorch.org/whl/cu121 -q
    print_success "PyTorch installed"
    
    echo "Installing XGBoost with GPU support..."
    pip install xgboost==2.1.2 --no-cache-dir -q
    print_success "XGBoost installed"
    
    echo "Installing LightGBM..."
    pip install lightgbm --config-settings=cmake.define.USE_GPU=ON -q 2>/dev/null || pip install lightgbm -q
    print_success "LightGBM installed"

    # --------------------------------------------------------
    # STEP 5: DATA SCIENCE STACK
    # --------------------------------------------------------
    print_header "📊 STEP 5: Data Science Stack"
    
    pip install -q \
        numpy==1.26.4 \
        pandas==2.2.3 \
        scipy==1.14.1 \
        scikit-learn==1.5.2 \
        statsmodels==0.14.4 \
        imbalanced-learn==0.12.4 \
        category_encoders==2.6.4 \
        feature-engine==1.8.1
    
    print_success "Data Science libraries installed"

    # --------------------------------------------------------
    # STEP 6: ML OPTIMIZATION
    # --------------------------------------------------------
    print_header "⚡ STEP 6: ML Optimization Tools"
    
    pip install -q \
        optuna==4.1.0 \
        hyperopt==0.2.7 \
        scikit-optimize==0.10.2
    
    print_success "Optimization libraries installed"

    # --------------------------------------------------------
    # STEP 7: VISUALIZATION
    # --------------------------------------------------------
    print_header "📈 STEP 7: Visualization Libraries"
    
    pip install -q \
        matplotlib==3.9.2 \
        seaborn==0.13.2 \
        plotly==5.24.1 \
        tensorboard==2.18.0
    
    print_success "Visualization libraries installed"

    # --------------------------------------------------------
    # STEP 8: DATABASE & WEB
    # --------------------------------------------------------
    print_header "🌐 STEP 8: Database & Web Libraries"
    
    pip install -q \
        psycopg2-binary==2.9.10 \
        sqlalchemy==2.0.36 \
        pymongo==4.10.1 \
        redis==5.2.0 \
        requests==2.32.3 \
        aiohttp==3.11.10 \
        beautifulsoup4==4.12.3 \
        selenium==4.27.1
    
    print_success "Database & Web libraries installed"

    # --------------------------------------------------------
    # STEP 9: ML TRACKING & DEPLOYMENT
    # --------------------------------------------------------
    print_header "📦 STEP 9: ML Tracking & Deployment"
    
    pip install -q \
        mlflow==2.18.0 \
        fastapi==0.115.5 \
        uvicorn==0.32.1 \
        streamlit==1.41.0
    
    print_success "MLOps tools installed"

    # --------------------------------------------------------
    # STEP 10: UTILITIES
    # --------------------------------------------------------
    print_header "🛠️ STEP 10: Utilities & Helper Libraries"
    
    pip install -q \
        tqdm==4.67.1 \
        rich==13.9.4 \
        colorama==0.4.6 \
        loguru==0.7.2 \
        pyyaml==6.0.2 \
        toml==0.10.2 \
        python-dotenv==1.0.1 \
        jsonschema==4.23.0
    
    print_success "Utility libraries installed"

    # --------------------------------------------------------
    # STEP 11: GPU MONITORING
    # --------------------------------------------------------
    print_header "🚀 STEP 11: GPU Monitoring Tools"
    
    pip install -q \
        nvidia-ml-py==12.560.30 \
        gpustat==1.1.1 \
        py3nvml==0.2.7 \
        pynvml==11.5.3
    
    print_success "GPU monitoring tools installed"

    # --------------------------------------------------------
    # STEP 12: JUPYTER (Optional)
    # --------------------------------------------------------
    print_header "📓 STEP 12: Jupyter Environment (Optional)"
    
    read -p "Install Jupyter? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pip install -q \
            jupyter==1.1.1 \
            jupyterlab==4.3.3 \
            ipykernel==6.29.5 \
            ipywidgets==8.1.5 \
            nbconvert==7.16.4
        
        python -m ipykernel install --user --name ai-dutching --display-name "AI Dutching" 2>/dev/null
        print_success "Jupyter environment installed"
    else
        print_warning "Skipping Jupyter installation"
    fi

    # --------------------------------------------------------
    # STEP 13: TESTING & PROFILING (Optional)
    # --------------------------------------------------------
    print_header "🧪 STEP 13: Testing & Profiling (Optional)"
    
    read -p "Install testing & profiling tools? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        pip install -q \
            pytest==8.3.4 \
            pytest-cov==6.0.0 \
            hypothesis==6.122.1 \
            memory_profiler==0.61.0 \
            line_profiler==4.2.0 \
            py-spy==0.4.0 \
            black==24.10.0 \
            flake8==7.1.1 \
            pylint==3.3.2 \
            mypy==1.13.0 \
            isort==5.13.2
        
        print_success "Testing & profiling tools installed"
    else
        print_warning "Skipping testing tools"
    fi

    # --------------------------------------------------------
    # STEP 14: PROJECT SETUP
    # --------------------------------------------------------
    print_header "📁 STEP 14: Project Directory Setup"
    
    # Create directories
    mkdir -p /workspace/{models/registry,data/{raw,processed},logs,notebooks,outputs}
    print_success "Project directories created"
    
    # Set permissions
    chmod -R 755 /workspace
    print_success "Permissions set"

    # --------------------------------------------------------
    # VERIFICATION
    # --------------------------------------------------------
    print_header "🔍 VERIFICATION"
    
    echo "Running installation verification..."
    python3 << 'PYTHON_EOF'
import sys
import warnings
warnings.filterwarnings('ignore')

def test_import(name, module):
    try:
        __import__(module)
        print(f"✅ {name:20} OK")
        return True
    except ImportError as e:
        print(f"❌ {name:20} FAILED - {e}")
        return False

print("\nCore Libraries:")
print("-" * 40)
tests = [
    ("PyTorch", "torch"),
    ("NumPy", "numpy"),
    ("Pandas", "pandas"),
    ("XGBoost", "xgboost"),
    ("Scikit-learn", "sklearn"),
    ("LightGBM", "lightgbm"),
    ("MLflow", "mlflow"),
    ("FastAPI", "fastapi"),
    ("Optuna", "optuna"),
]

all_ok = all(test_import(name, module) for name, module in tests)

# GPU Check
print("\nGPU Support:")
print("-" * 40)

try:
    import torch
    if torch.cuda.is_available():
        print(f"✅ CUDA Available: {torch.cuda.get_device_name(0)}")
        print(f"   VRAM: {torch.cuda.get_device_properties(0).total_memory / 1e9:.1f} GB")
    else:
        print("⚠️  CUDA Not Available")
except Exception as e:
    print(f"❌ CUDA Check Failed: {e}")

try:
    import xgboost as xgb
    import numpy as np
    X = np.random.rand(10, 5)
    y = np.random.randint(0, 2, 10)
    dtrain = xgb.DMatrix(X, label=y)
    params = {'tree_method': 'gpu_hist', 'gpu_id': 0}
    bst = xgb.train(params, dtrain, num_boost_round=1, verbose_eval=False)
    print("✅ XGBoost GPU Support: Active")
except Exception:
    print("⚠️  XGBoost GPU Support: Not Available")

print("\n" + "=" * 40)
if all_ok:
    print("✅ Installation Complete!")
else:
    print("⚠️  Some packages failed to install")
PYTHON_EOF

    # --------------------------------------------------------
    # COMPLETION
    # --------------------------------------------------------
    print_header "✅ INSTALLATION COMPLETE!"
    
    echo ""
    echo "Next steps:"
    echo "1. Create .env file with your API keys"
    echo "2. Test GPU: python test_xgboost_gpu.py"
    echo "3. Start training: python train_ml_models.py"
    echo "4. Run system: python sportmonks_dutching_system.py"
    echo ""
    
    # Create quick test script
    cat > /workspace/quick_test.py << 'EOF'
#!/usr/bin/env python3
import torch
import xgboost as xgb
import numpy as np

print(f"PyTorch CUDA: {torch.cuda.is_available()}")
if torch.cuda.is_available():
    print(f"GPU: {torch.cuda.get_device_name(0)}")

# Test XGBoost GPU
try:
    X = np.random.rand(100, 10)
    y = np.random.randint(0, 3, 100)
    dtrain = xgb.DMatrix(X, label=y)
    params = {'tree_method': 'gpu_hist', 'gpu_id': 0, 'objective': 'multi:softmax', 'num_class': 3}
    bst = xgb.train(params, dtrain, num_boost_round=1, verbose_eval=False)
    print("XGBoost GPU: ✅ Working")
except Exception as e:
    print(f"XGBoost GPU: ❌ {e}")
EOF
    chmod +x /workspace/quick_test.py
    
    echo "Quick test script created: /workspace/quick_test.py"
    echo ""
    
    # Save installation log
    echo "Installation completed at $(date)" > /workspace/installation.log
    pip freeze >> /workspace/installation.log
    
    print_success "Installation log saved to /workspace/installation.log"
}

# ============================================================
# RUN MAIN FUNCTION
# ============================================================
main "$@"
