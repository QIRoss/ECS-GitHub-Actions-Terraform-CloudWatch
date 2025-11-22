import pytest
from fastapi.testclient import TestClient
import sys
import os

# Adiciona o src ao path para importar o app
sys.path.append(os.path.join(os.path.dirname(__file__), '../src'))

from app import app

client = TestClient(app)

def test_health_endpoint():
    """Testa o endpoint /health"""
    response = client.get("/health")
    assert response.status_code == 200
    data = response.json()
    assert data["status"] == "healthy"
    assert "version" in data

def test_hello_endpoint():
    """Testa o endpoint /api/hello"""
    response = client.get("/api/hello")
    assert response.status_code == 200
    data = response.json()
    assert data["message"] == "Hello from Eloquent AI!"
    assert "environment" in data

def test_health_response_structure():
    """Testa a estrutura da resposta do health check"""
    response = client.get("/health")
    data = response.json()
    
    # Verifica se tem as chaves esperadas
    assert "status" in data
    assert "version" in data
    
    # Verifica os valores
    assert data["status"] == "healthy"
    assert data["version"] == "1.0.0"  # Valor default

def test_hello_response_structure():
    """Testa a estrutura da resposta do hello endpoint"""
    response = client.get("/api/hello")
    data = response.json()
    
    # Verifica se tem as chaves esperadas
    assert "message" in data
    assert "environment" in data
    
    # Verifica o valor da mensagem
    assert data["message"] == "Hello from Eloquent AI!"