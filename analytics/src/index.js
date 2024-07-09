const express = require('express');
const app = express();
const port = 4000;
const analyticsService = require('./analytics');

app.get('/stats', async (req, res) => {
  const stats = await analyticsService.getStats();
  res.json(stats);
});

app.listen(port, () => {
  console.log(`Analytics service listening at http://localhost:${port}`);
});
