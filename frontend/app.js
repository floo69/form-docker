const express = require('express');
const axios = require('axios');
const path = require('path'); 

const app = express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use(express.static('public'));

app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));

const BACKEND_URL = process.env.BACKEND_URL || 'http://localhost:5000';

app.get('/', (req, res) => {
    res.render('index', { error: null });
});

app.post('/submit', async (req, res) => {
    try {
        console.log('Form data received:', req.body);

        const response = await axios.post(`${BACKEND_URL}/api/submit`, req.body, {
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

app.get('/success', (req, res) => {
    res.render('success');
});

app.listen(3000, '0.0.0.0', () => {
    console.log('Frontend server running on 3000');
});
