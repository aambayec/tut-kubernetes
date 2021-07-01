import React from "react";
import logo from "./logo.svg";
import "./App.css";
import { BrowserRouter as Router, Route, Link } from "react-router-dom";
import OtherPage from "./OtherPage";
import Fib from "./Fib";

function App() {
  return (
    <Router>
      <div className="App">
        <header>
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Fib Calculator version KUBERNETES!</h1>
        </header>
        <Link to="/">Home</Link>
        &nbsp;&nbsp;
        <Link to="/otherpage">Other Page</Link>
        <br />
        <Route exact path="/" component={Fib} />
        <Route path="/otherpage" component={OtherPage} />
      </div>
    </Router>
  );
}

export default App;
