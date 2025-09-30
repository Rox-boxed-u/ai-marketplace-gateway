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
