const express = require('express');
const app = express();
const port = 3000;
const oracleService = require('./oracle');

app.get('/data', async (req, res) => {
  const data = await oracleService.getData();
  res.json(data);
});

app.listen(port, () => {
  console.log(`Oracle service listening at http://localhost:${port}`);
});
