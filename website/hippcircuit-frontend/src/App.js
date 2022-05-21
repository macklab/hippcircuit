import './App.css';
import { HashRouter as Router, Route, Routes } from "react-router-dom";

import Home from "./pages/Home";
import About from "./pages/About";
import Visualizer from './pages/Visualizer';
import Results from './pages/Results';

function App() {
  return (
    <div className="App">
      <Router>
        <Routes>
          <Route path="/" exact element={<Home />} />
          <Route path="/about" exact element={<About />} />
          <Route path="/explore" exact element={<Visualizer />} />
          <Route path="/results" exact element={<Results />} />
        </Routes>
      </Router>
    </div>
  );
}

export default App;
