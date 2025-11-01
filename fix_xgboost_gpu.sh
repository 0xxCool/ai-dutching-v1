#!/bin/bash

echo "=========================================="
echo "🚀 XGBoost GPU Installation Fix"
echo "=========================================="

# Entferne die bestehende XGBoost Installation
echo "📦 Entferne alte XGBoost Installation..."
conda remove xgboost py-xgboost libxgboost _py-xgboost-mutex -y

# Option 1: Installiere XGBoost direkt über pip (empfohlen)
echo ""
echo "🔧 Option 1: Installation über pip (EMPFOHLEN)"
echo "----------------------------------------"
pip install --upgrade pip
pip install xgboost -U

# Teste die Installation
python -c "
import xgboost as xgb
print('XGBoost Version:', xgb.__version__)

# Prüfe GPU Support
try:
    # Erstelle einen kleinen Test-Datensatz
    import numpy as np
    X = np.random.rand(100, 10)
    y = np.random.randint(0, 3, 100)
    
    dtrain = xgb.DMatrix(X, label=y)
    
    # Versuche GPU Training
    params = {
        'tree_method': 'gpu_hist',
        'gpu_id': 0,
        'objective': 'multi:softmax',
        'num_class': 3
    }
    
    bst = xgb.train(params, dtrain, num_boost_round=1, verbose_eval=False)
    print('✅ GPU Support funktioniert!')
    
except Exception as e:
    print('❌ GPU Support fehlgeschlagen:', str(e))
    print('')
    print('Versuche Option 2...')
"

# Falls Option 1 fehlschlägt, biete Alternative
echo ""
echo "=========================================="
echo "Falls Option 1 fehlschlägt, versuche:"
echo ""
echo "🔧 Option 2: Kompiliere XGBoost from Source"
echo "----------------------------------------"
echo "# 1. Clone XGBoost Repository"
echo "git clone --recursive https://github.com/dmlc/xgboost"
echo "cd xgboost"
echo ""
echo "# 2. Build mit GPU Support"
echo "mkdir build"
echo "cd build"
echo "cmake .. -DUSE_CUDA=ON -DUSE_NCCL=ON"
echo "make -j$(nproc)"
echo ""
echo "# 3. Python Package installieren"
echo "cd ../python-package"
echo "pip install -e ."
echo ""
echo "=========================================="

# Option 3: Conda-forge mit spezieller GPU Version
echo ""
echo "🔧 Option 3: Conda-forge GPU Version"
echo "----------------------------------------"
echo "conda install -c conda-forge py-xgboost-gpu --solver=libmamba"
echo ""
echo "=========================================="
