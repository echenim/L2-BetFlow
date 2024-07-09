const axios = require('axios');

async function getData() {
  const response = await axios.get('https://api.sportsdata.io/v3/soccer/scores/json/CompetitionDetails');
  return response.data;
}

module.exports = { getData };
