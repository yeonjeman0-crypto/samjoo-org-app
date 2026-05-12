// server.js  -  Express API + static frontend host
const express = require('express');
const cors    = require('cors');
const path    = require('path');

const companies   = require('./routes/companies');
const org         = require('./routes/org');
const fleet       = require('./routes/fleet');
const particulars = require('./routes/particulars');
const duties      = require('./routes/duties');
const safety      = require('./routes/safety');
const shoreSafety = require('./routes/shoreSafety');
const staff       = require('./routes/staff');

const PORT = process.env.PORT || 3000;
const app  = express();

app.use(cors());
app.use(express.json());

app.use('/api/companies',                companies);
app.use('/api/companies/:code/org',      org);
app.use('/api/companies/:code/fleet',    fleet);
app.use('/api/particulars',              particulars);
app.use('/api/duties',                   duties);
app.use('/api/safety',                   safety);
app.use('/api/shore-safety',             shoreSafety);
app.use('/api/staff',                    staff);

app.use(express.static(path.resolve(__dirname, '..', 'frontend')));
app.get('/api/health', (req, res) => res.json({ status: 'ok', time: new Date().toISOString() }));

app.listen(PORT, () => {
  console.log('SAMJOO SM & DORIKO  -  Org & Fleet API');
  console.log('http://localhost:' + PORT);
});
