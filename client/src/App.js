import React from 'react';
import { BrowserRouter as Router, Route, Switch } from 'react-router-dom';
import HomePage from './pages/HomePage';
import BetPage from './pages/BetPage';
import './App.css';

function App() {
  return (
    <Router>
      <div className="App">
        <Switch>
          <Route path="/" exact component={HomePage} />
          <Route path="/bet" component={BetPage} />
        </Switch>
      </div>
    </Router>
  );
}

export default App;
