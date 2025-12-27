# Init Python Project Script (pyenv + Poetry)

Este repositorio contiene un **script Bash** que permite **inicializar rápidamente proyectos Python** siguiendo **buenas prácticas modernas** de desarrollo profesional.

El objetivo principal es **reducir errores, ahorrar tiempo y estandarizar** la creación de nuevos proyectos Python usando herramientas ampliamente adoptadas en la industria.

## 🎯 Objetivo del script
Este script automatiza:

-   La instalación (local) de la versión correcta de Python con **pyenv**
-   La creación de un proyecto con **Poetry**
-   La configuración de:
    -   entornos virtuales
    -   dependencias de desarrollo
    -   estructura de proyecto basada en `src/`
    -   herramientas de calidad de código
    -   Git y pre-commit
-   La validación inicial del proyecto

Todo esto **sin modificar configuraciones globales del sistema**.


## 🧠 Conceptos básicos (explicados fácil)

### ¿Qué problema resuelve?

Crear proyectos Python manualmente suele implicar:

-   versiones incorrectas de Python
-   entornos virtuales inconsistentes
-   dependencias mal separadas
-   proyectos con estructuras distintas
-   errores repetitivos en cada inicio

Este script **elimina esos problemas**.


### Herramientas

| Herramienta        | Para qué sirve           |
| ------------- |-------------|
| pyenv      | Gestiona múltiples versiones de Python|
| Poetry | Maneja dependencias y entornos virtuales |
| Git | Control de versions|
| black | Formateo estático de código |
| flake8 | Análisis estático |
| pytest | Pruebas |
| pre-commit | prevalidaciones automáticas antes de commits|


## 📋 Requisitos previos

Antes de ejecutar el script debes tener instalado:

-   **Linux o macOS**
-   **bash**
-   **git**
-   **pyenv**
-   **Poetry (v2.x)**

Verifica con:

```bash
pyenv --version
poetry --version
git --version
```

## 🚀 Cómo usar el script

### 1\. Dar permisos de ejecución

```bash
chmod +x init-python-project.sh
```

### 2\. Ejecutar el script

#### Opción A: con nombre y versión de Python

```bash
./init-python-project.sh mi-proyecto 3.13.5
```

#### Opción B: solo nombre (usa Python 3.14.2 por defecto)

```bash
./init-python-project.sh mi-proyecto
```

#### Opción C: sin argumentos (nombre aleatorio + Python por defecto)

```bash
./init-python-project.sh
```

## 📂 Estructura generada

```text
mi-proyecto/
├── src/
│   └── mi-proyecto/
│       ├── __init__.py
│       └── main.py
├── tests/
├── .gitignore
├── .env.example
├── README.md
├── pyproject.toml
├── poetry.lock
└── .python-version
```

## 📦 Gestión de dependencias

### Dependencias de producción

```bash
poetry add requests
```

Estas dependencias:

-   se instalan por defecto
-   se usan en producción

### Dependencias de desarrollo

```bash
poetry add --group dev black flake8
```

Se usan solo para:

-   desarrollo 
-   análisis
-   formateo

### Dependencias de pruebas

```bash
poetry add --group test pytest
```


## 🔐 Pre-commit: qué es y por qué usarlo

**pre-commit** ejecuta validaciones **antes de cada commit**:

-   formatea código
-   valida estilo
-   ejecuta pruebas


Esto evita que:

-   código mal formateado llegue al repositorio
-   errores triviales se propaguen
-   el equipo pierda tiempo en revisiones innecesarias

El script instala y configura pre-commit automáticamente.



## ✅ Beneficios de esta aproximación

-   Entornos reproducibles
-   Menos errores humanos
-   Flujo compatible con CI/CD
-   Aislamiento entre proyectos
-   Fácil adopción por equipos
-   Estándar profesional


## ⚠️ Consideraciones importantes

-   Aunque Python 3.14 es una versión reciente (Diciembre 2025), este script implementa 3.13 por defecto.
    → recomendado para aprendizaje, laboratorios y proyectos nuevos
-   Para producción crítica, evalúa compatibilidad de dependencias
-   El script es **idempotente**, pero está pensado para proyectos nuevos


## 🏆 Buenas prácticas incluidas

-   Patrón `src/`
-   Separación de dependencias por grupos
-   Uso de `poetry run`
-   Versionado de `poetry.lock`
-   Uso de pre-commit
-   No modificar configuraciones globales


## 📌 Recomendaciones finales

-   Usa **un proyecto = un repositorio**
-   Nunca instales dependencias con `pip` directamente
-   Ejecuta siempre comandos con `poetry run`
-   Mantén el `poetry.lock` versionado
-   Usa este script como base, no como dogma

## 🤝 Contribuciones

Las contribuciones son bienvenidas:

-   mejoras al script
-   soporte para más versiones
-   optimizaciones
-   documentación adicional

## 📄 Licencia

MIT License.

