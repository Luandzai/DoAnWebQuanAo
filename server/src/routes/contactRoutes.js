// server/src/routes/contactRoutes.js
const express = require('express');
const router = express.Router();
const { handleContactRequest } = require('../controllers/contactController');

// POST /api/contact/send
router.post('/send', handleContactRequest);

module.exports = router;