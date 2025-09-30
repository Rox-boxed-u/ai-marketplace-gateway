#!/bin/bash

echo "🚀 Setting up AI Marketplace Gateway..."

# Create all directories
echo "📁 Creating directories..."
mkdir -p router marketplace auth config

# Create package.json
echo "📦 Creating package.json..."
cat > package.json << 'PACKAGE'
{
  "name": "ai-marketplace-gateway",
  "version": "1.0.0",
  "description": "Secure gateway for AI services",
  "main": "server.js",
  "scripts": {
    "start": "node server.js",
    "dev": "nodemon server.js"
  },
  "dependencies": {
    "express": "^4.18.2",
    "axios": "^1.6.0",
    "cors": "^2.8.5",
    "helmet": "^7.0.0",
    "bcrypt": "^5.1.1",
    "jsonwebtoken": "^9.0.2",
    "dotenv": "^16.3.1"
  }
}
PACKAGE

# Create server.js
echo "🖥️  Creating server.js..."
cat > server.js << 'SERVER'
require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('marketplace'));

// Mock router for testing
app.post('/api/service/:serviceId', (req, res) => {
    const { serviceId } = req.params;
    const { input } = req.body;
    
    // Mock response
    res.json({
        success: true,
        service: serviceId,
        output: `Processed: ${input}`,
        metrics: {
            processingTime: Math.floor(Math.random() * 500) + 200,
            accuracy: Math.floor(Math.random() * 10) + 90
        }
    });
});

// Health check
app.get('/health', (req, res) => {
    res.json({ status: 'healthy', timestamp: Date.now() });
});

// Start server
app.listen(PORT, () => {
    console.log(`✅ Gateway running on port ${PORT}`);
    console.log(`🌐 Open http://localhost:${PORT} in your browser`);
});
SERVER

# Create marketplace HTML
echo "🎨 Creating marketplace interface..."
cat > marketplace/index.html << 'HTML'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>AI Marketplace Gateway</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 20px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            overflow: hidden;
        }
        
        header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 40px;
            text-align: center;
        }
        
        h1 { font-size: 2.5rem; margin-bottom: 10px; }
        
        .services {
            padding: 40px;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 30px;
        }
        
        .service-card {
            border: 2px solid #e1e8ed;
            border-radius: 12px;
            padding: 25px;
            transition: all 0.3s ease;
        }
        
        .service-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            border-color: #667eea;
        }
        
        button {
            background: #667eea;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            width: 100%;
            margin-top: 15px;
        }
        
        button:hover {
            background: #764ba2;
        }
        
        .output {
            margin-top: 15px;
            padding: 15px;
            background: #f5f8fa;
            border-radius: 6px;
            font-family: monospace;
            font-size: 12px;
            display: none;
        }
        
        .output.show { display: block; }
    </style>
</head>
<body>
    <div class="container">
        <header>
            <h1>🚀 AI Marketplace Gateway</h1>
            <p>Test your AI services in a secure sandbox</p>
        </header>
        
        <div class="services">
            <div class="service-card">
                <h3>📊 EPAE</h3>
                <p>Enterprise Process Automation Engine</p>
                <button onclick="testService('epae', this)">Test Service</button>
                <div class="output" id="epae-output"></div>
            </div>
            
            <div class="service-card">
                <h3>✨ CREATE</h3>
                <p>AI Content Generation Platform</p>
                <button onclick="testService('create', this)">Test Service</button>
                <div class="output" id="create-output"></div>
            </div>
            
            <div class="service-card">
                <h3>📈 Forecast</h3>
                <p>Predictive Analytics System</p>
                <button onclick="testService('forecast', this)">Test Service</button>
                <div class="output" id="forecast-output"></div>
            </div>
            
            <div class="service-card">
                <h3>📄 Skanr</h3>
                <p>Document Intelligence & OCR</p>
                <button onclick="testService('skanr', this)">Test Service</button>
                <div class="output" id="skanr-output"></div>
            </div>
            
            <div class="service-card">
                <h3>🔮 Futr</h3>
                <p>Market Trends Analysis</p>
                <button onclick="testService('futr', this)">Test Service</button>
                <div class="output" id="futr-output"></div>
            </div>
            
            <div class="service-card" style="opacity: 0.5;">
                <h3>💰 Budee</h3>
                <p>AI Budget Assistant (Coming Soon)</p>
                <button disabled>Coming Soon</button>
            </div>
        </div>
    </div>
    
    <script>
        async function testService(service, button) {
            button.disabled = true;
            button.textContent = 'Testing...';
            
            try {
                const response = await fetch(`/api/service/${service}`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ input: 'Test input data' })
                });
                
                const data = await response.json();
                const output = document.getElementById(`${service}-output`);
                output.textContent = JSON.stringify(data, null, 2);
                output.classList.add('show');
            } catch (error) {
                alert('Error: ' + error.message);
            } finally {
                button.disabled = false;
                button.textContent = 'Test Service';
            }
        }
    </script>
</body>
</html>
HTML

# Create .env.example
echo "🔐 Creating environment template..."
cat > .env.example << 'ENV'
# Gateway Configuration
NODE_ENV=production
PORT=3000

# Your Service URLs (update with actual URLs)
EPAE_RENDER_URL=https://your-epae.onrender.com
CREATE_RENDER_URL=https://your-create.onrender.com
FORECAST_RENDER_URL=https://your-forecast.onrender.com
SKANR_RENDER_URL=https://your-skanr.onrender.com
FUTR_RENDER_URL=https://your-futr.onrender.com

# API Keys (generate unique ones)
EPAE_API_KEY=your-key-here
CREATE_API_KEY=your-key-here
FORECAST_API_KEY=your-key-here
SKANR_API_KEY=your-key-here
FUTR_API_KEY=your-key-here
ENV

# Copy to .env for local testing
cp .env.example .env

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Run: npm install"
echo "2. Run: npm start"
echo "3. Open: http://localhost:3000"
echo ""
