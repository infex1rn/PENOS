import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, useNavigate } from 'react-router-dom';
import { Terminal, HardDrive, RefreshCcw, Download } from 'lucide-react';
import ReleaseHistory from './pages/ReleaseHistory';
import AdminDashboard from './pages/AdminDashboard';

const Nav = () => (
  <nav className="nav-bar">
    <div className="container nav-content">
      <Link to="/" style={{fontSize: '1.5rem', fontWeight: 700, color: '#333', textDecoration: 'none'}}>PENOS</Link>
      <div className="nav-links">
        <Link to="/">Home</Link>
        <Link to="/download/release">Releases</Link>
        <a href="https://github.com/infex1rn/PENOS">GitHub</a>
      </div>
    </div>
  </nav>
);

const Home = () => (
  <>
    <header className="hero">
      <div className="container">
        <h1>The future of mobile virtualization.</h1>
        <p>PENOS is the ultra-lightweight, persistent Linux environment designed specifically for iOS.</p>
        <div style={{marginTop: '2rem'}}>
          <Link to="/download/release" className="btn-orange">View Releases</Link>
        </div>
      </div>
    </header>
    <section className="container section">
      <div className="grid">
        <div className="card">
          <Terminal size={32} color="#E95420" />
          <h3>Terminal First</h3>
          <p>Designed for power users. No bloat, no desktop environment, just pure performance on ARM64.</p>
        </div>
        <div className="card">
          <HardDrive size={32} color="#E95420" />
          <h3>True Persistence</h3>
          <p>Your data stays with you. PENOS automatically configures virtual disks to survive updates.</p>
        </div>
        <div className="card">
          <RefreshCcw size={32} color="#E95420" />
          <h3>OTA Updates</h3>
          <p>Stay current with verified system updates that mount seamlessly at boot time.</p>
        </div>
      </div>
    </section>
  </>
);

const App = () => {
  return (
    <Router>
      <Nav />
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/download/release" element={<ReleaseHistory />} />
        <Route path="/admin" element={<AdminDashboard />} />
      </Routes>
      <footer className="footer">
        <div className="container">
          <p>&copy; 2026 PENOS Project. All rights reserved. Open source under MIT.</p>
        </div>
      </footer>
    </Router>
  );
};

export default App;
