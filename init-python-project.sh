#!/usr/bin/env bash
set -Eeuo pipefail

# ============================
# PARÁMETROS DE ENTRADA
# ============================
PROJECT_NAME="${1:-}"
PYTHON_VERSION="${2:-3.11.14}"

# ============================
# GENERAR NOMBRE ALEATORIO
# ============================
if [[ -z "$PROJECT_NAME" ]]; then
  RAND_SUFFIX="$(date +%s | sha256sum | cut -c1-6)"
  PROJECT_NAME="python-project-${RAND_SUFFIX}"
fi

PACKAGE_NAME="${PROJECT_NAME//-/-}"

# ============================
# VALIDACIONES DE HERRAMIENTAS
# ============================
for cmd in pyenv poetry git; do
  command -v "$cmd" >/dev/null 2>&1 || {
    echo "ERROR: '$cmd' no está instalado o no está en el PATH"
    exit 1
  }
done

# ============================
# VALIDAR PYTHON PARA BLACK
# ============================
PY_MAJOR="$(echo "$PYTHON_VERSION" | cut -d. -f1)"
PY_MINOR="$(echo "$PYTHON_VERSION" | cut -d. -f2)"

BLACK_TARGET_VERSION="py${PY_MAJOR}${PY_MINOR}"

case "$BLACK_TARGET_VERSION" in
  py310|py311|py312|py313|py314) ;;
  *)
    echo "ERROR: Black no soporta la versión de Python ${PY_MAJOR}.${PY_MINOR}"
    exit 1
    ;;
esac

# ============================
# CREAR PROYECTO
# ============================
mkdir -p "$PROJECT_NAME"
cd "$PROJECT_NAME"

# ============================
# INSTALAR PYTHON (SI NO EXISTE)
# ============================
if ! pyenv prefix "$PYTHON_VERSION" >/dev/null 2>&1; then
  pyenv install "$PYTHON_VERSION"
fi


# ============================
# FIJAR PYTHON LOCAL
# ============================
pyenv local "$PYTHON_VERSION"

# ============================
# INICIALIZAR POETRY
# ============================
poetry init \
  --name "$PROJECT_NAME" \
  --description "" \
  --author "Your Name <you@example.com>" \
  --python ">=${PY_MAJOR}.${PY_MINOR},<${PY_MAJOR}.$((PY_MINOR + 1))" \
  --no-interaction

# ============================
# ESTRUCTURA BASE
# ============================
mkdir -p src/"$PACKAGE_NAME"
touch src/"$PACKAGE_NAME"/__init__.py
touch src/"$PACKAGE_NAME"/main.py

mkdir tests

# ===========================
# smoke test
#============================
cat <<EOF > tests/test_smoke.py
def test_smoke():
    assert True
EOF

#===========================
# README.md
#==========================
cat <<EOF > README.md
# $PROJECT_NAME

Proyecto inicializado automáticamente con Poetry y pyenv.
EOF


# ============================
# GENERAR .gitignore
# ============================
cat <<'EOF' > .gitignore
# ==================================================
# Python + Poetry + VS Code
# ==================================================

# ------------------------------
# Entornos virtuales
# ------------------------------
.venv/
venv/
ENV/
env/

# ------------------------------
# Variables de entorno
# ------------------------------
.env
.env.*
!.env.example

# ------------------------------
# Caché y archivos generados por Python
# ------------------------------
__pycache__/
*.py[cod]

# ------------------------------
# Distribuciones y empaquetado
# ------------------------------
build/
dist/
*.egg-info/
.eggs/

# ------------------------------
# Pytest / Coverage
# ------------------------------
.pytest_cache/
.coverage
coverage.xml
htmlcov/

# ------------------------------
# Mypy
# ------------------------------
.mypy_cache/

# ------------------------------
# Ruff
# ------------------------------
.ruff_cache/

# ------------------------------
# Jupyter
# ------------------------------
.ipynb_checkpoints/

# ------------------------------
# Logs y archivos temporales
# ------------------------------
*.log
*.tmp
*.bak
*.swp
*.swo

# ------------------------------
# IDEs
# ------------------------------
.vscode/
.idea/

# ------------------------------
# Sistema operativo
# ------------------------------
.DS_Store
Thumbs.db
EOF


# ============================
# GENERAR .env.example
# ============================
cat <<'EOF' > .env.example
# Variables de entorno de ejemplo
# Copiar este archivo a .env y completar los valores reales

APP_ENV=development
APP_DEBUG=true

# Ejemplo de configuración
# DATABASE_URL=postgresql://user:password@localhost:5432/dbname
EOF


# ============================
# DEPENDENCIAS DE DESARROLLO
# ============================
poetry add --group dev black flake8 pre-commit
poetry add --group test pytest

# ============================
# CONFIGURACIÓN PYPROJECT
# ============================
cat <<EOF >> pyproject.toml

[tool.poetry]
packages = [{ include = "$PACKAGE_NAME", from = "src" }]

[tool.black]
line-length = 88
target-version = ["$BLACK_TARGET_VERSION"]

[tool.flake8]
max-line-length = 88
ignore = ["E203", "W503"]
exclude = [".venv", "__pycache__", "build", "dist"]
EOF


# ============================
# CONFIGURACIÓN PRE-COMMIT
# ============================
cat <<EOF > .pre-commit-config.yaml
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v4.6.0
    hooks:
      - id: check-yaml
      - id: check-toml
      - id: end-of-file-fixer
      - id: trailing-whitespace

  - repo: https://github.com/psf/black
    rev: 25.1.0
    hooks:
      - id: black
        language_version: python${PY_MAJOR}.${PY_MINOR}

  - repo: https://github.com/PyCQA/flake8
    rev: 7.3.0
    hooks:
      - id: flake8
        args:
          - --max-line-length=88
          - --extend-ignore=E203,W503

  - repo: local
    hooks:
      - id: pytest
        name: pytest
        entry: poetry run pytest
        language: system
        pass_filenames: false
        stages: [pre-commit]
EOF


# ============================
# ENTORNO VIRTUAL
# ============================
poetry env use python

# ============================
# GIT + PRE-COMMIT
# ============================
git init
git branch -m main

git add .gitignore .env.example README.md pyproject.toml src tests .python-version poetry.lock .pre-commit-config.yaml
git commit -m "chore: initial project structure"

poetry run pre-commit install
poetry run pre-commit run --all-files || true


# ============================
# LOCK + INSTALL
# ============================
poetry lock
poetry install

# ============================
# VERIFICACIONES
# ============================
poetry check
poetry run black .
poetry run flake8
poetry run pytest || true

echo
echo "Proyecto inicializado correctamente"
echo "Nombre del proyecto : $PROJECT_NAME"
echo "Paquete Python      : $PACKAGE_NAME"
echo "Python              : $PYTHON_VERSION"
echo "Black target        : $BLACK_TARGET_VERSION"
