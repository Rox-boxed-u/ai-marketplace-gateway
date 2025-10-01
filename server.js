require('dotenv').config();
const express = require('express');
const cors = require('cors');
const path = require('path');
const axios = require('axios');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());
app.use(express.static('marketplace'));

// API router for real services
app.post('/api/service/:serviceId', async (req, res) => {
    const { serviceId } = req.params;
    const { input, type, lang } = req.body;
    
    // Service configuration
    const services = {
        epae: {
            url: 'https://epae-api.onrender.com',
            endpoint: '/predict', // ✅ Correct endpoint
            method: 'POST'
        },
        create: {
            url: 'https://www.teamfandomly.com',
            endpoint: '/api/create', // UPDATE THIS with actual endpoint
            method: 'POST'
        },
        forecast: {
            url: 'mock'
        },
        skanr: {
            url: 'mock'
        },
        futr: {
            url: 'mock'
        }
    };
    
    const service = services[serviceId];
    
    // Mock response for services not yet deployed
    if (!service || service.url === 'mock') {
        return res.json({
            success: true,
            service: serviceId,
            output: `Mock: ${input}`,
            metrics: {
                processingTime: Math.floor(Math.random() * 500) + 200,
                accuracy: Math.floor(Math.random() * 10) + 90
            }
        });
    }
    
    try {
        // Call real service
        const response = await axios({
            method: service.method,
            url: service.url + service.endpoint,
            data: { 
                content: input,  // EPAE expects 'content' not 'text'
                platform: 'instagram',  // Default platform
                instagram_followers: 10000  // Default follower count
            },
            timeout: 30000
        });
        
        res.json({
            success: true,
            service: serviceId,
            ...response.data
        });
        
    } catch (error) {
        console.error(`Service ${serviceId} error:`, error.message);
        res.json({
            success: false,
            error: 'Service temporarily unavailable',
            service: serviceId
        });
    }
});
