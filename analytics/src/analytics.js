async function getStats() {
  // Simulated analytics data
  return {
    totalBets: 1000,
    totalAmount: 50000,
    successfulBets: 750,
    failedBets: 250
  };
}

module.exports = { getStats };
