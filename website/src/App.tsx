import React, { useState } from 'react';
import { ChevronRight, Download, Terminal, HardDrive, RefreshCcw } from 'lucide-react';

const App = () => {
  const [page, setPage] = useState('home');

  const Nav = () => (
    <nav className="nav-bar">
      <div className="container nav-content">
        <div style={{fontSize: '1.5rem', fontWeight: 700, cursor: 'pointer'}} onClick={() => setPage('home')}>PENOS</div>
        <div className="nav-links">
          <a href="#" onClick={() => setPage('home')}>Home</a>
          <a href="#" onClick={() => setPage('download')}>Download</a>
          <a href="#" onClick={() => setPage('docs')}>Docs</a>
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
            <a href="#" className="btn-orange" onClick={() => setPage('download')}>Get PENOS 0.1.0</a>
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

  const DownloadPage = () => (
    <section className="container section">
      <h1>Download PENOS</h1>
      <p>Choose the official PENOS image for your virtualization platform.</p>
      
      <div className="download-card">
        <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center'}}>
          <div>
            <h2 style={{margin: 0}}>PENOS 0.1.0 LTS</h2>
            <p style={{color: '#666'}}>Architecture: ARM64 (AArch64)</p>
          </div>
          <a href="https://penos.indevstudio.dev/download/release/penos.iso" className="btn-orange">
            <Download size={18} style={{marginRight: 8, verticalAlign: 'middle'}} />
            Download Now
          </a>
        </div>

        <ul className="req-list">
          <li><span>Recommended RAM</span> <span>1 GB</span></li>
          <li><span>Storage Capacity</span> <span>2 GB (VirtIO)</span></li>
          <li><span>Host OS</span> <span>iOS / iPadOS (UTM SE)</span></li>
        </ul>

        <div style={{fontSize: '0.875rem', color: '#666'}}>
          <strong>Verification:</strong> <code>sha256sum penos.iso</code> <br />
          <a href="https://update.pen.indevstudio.dev/release/v1/sha256" style={{color: '#E95420'}}>Verify your download</a>
        </div>
      </div>
    </section>
  );

  const Docs = () => (
    <section className="container section">
      <h1>Documentation</h1>
      <p>Refer to our <a href="https://github.com/infex1rn/PENOS/tree/main/docs" style={{color: '#E95420'}}>official GitHub repository</a> for comprehensive architecture and setup guides.</p>
    </section>
  );

  return (
    <div>
      <Nav />
      {page === 'home' && <Home />}
      {page === 'download' && <DownloadPage />}
      {page === 'docs' && <Docs />}

      <footer className="footer">
        <div className="container">
          <p>&copy; 2026 PENOS Project. All rights reserved. Open source under MIT.</p>
        </div>
      </footer>
    </div>
  );
};

export default App;
