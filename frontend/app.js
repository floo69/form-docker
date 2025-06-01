// frontend/app.js
const express = require('express');
const axios = require('axios');
const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static('public'));
app.set('view engine', 'ejs');

// Home page with form
app.get('/', (req, res) => {
    res.render('index', { error: null });
});

// Handle form submission
app.post('/submit', async (req, res) => {
    try {
        console.log('Form data received:', req.body);
        
        const response = await axios.post('http://localhost:5000/api/submit', req.body, {
            headers: {
                'Content-Type': 'application/json'
            }
        });
        
        console.log('Backend response:', response.data);
        res.redirect('/success');
    } catch (error) {
        console.log('Error:', error.response?.data);
        const errorMessage = error.response?.data?.error || 'Submission failed';
        res.render('index', { error: errorMessage });
    }
});

// Success page
app.get('/success', (req, res) => {
    res.render('success');
});

app.listen(3000, () => {
    console.log('Frontend server running on http://localhost:3000');
});