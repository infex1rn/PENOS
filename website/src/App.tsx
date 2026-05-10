import React from 'react';
import { Download, Cpu, Zap, Database, ShieldCheck } from 'lucide-react';

function App() {
  return (
    <div className="container">
      <nav>
        <div className="logo">PENOS</div>
        <div className="links">
          <a href="#features" style={{color: 'var(--text-dim)', textDecoration: 'none', marginRight: '2rem'}}>Features</a>
          <a href="https://github.com/infex1rn/PENOS" style={{color: 'var(--text-dim)', textDecoration: 'none'}}>GitHub</a>
        </div>
      </nav>

      <section className="hero">
        <h1>Terminal Freedom for iOS.</h1>
        <p>The fastest and lightest persistent Linux environment designed specifically for iPhone and iPad virtualization.</p>
        <div style={{display: 'flex', gap: '1rem', justifyContent: 'center'}}>
          <a href="https://penos.indevstudio.dev/download/release/" className="btn btn-primary">
            <Download size={18} style={{marginRight: '0.5rem', verticalAlign: 'middle'}} />
            Download ISO
          </a>
        </div>

        <div className="terminal-mockup">
          <div style={{color: '#666', marginBottom: '0.5rem'}}># Booting PENOS v0.1.0...</div>
          <div><span className="blue">root@penos</span>:~# pen update</div>
          <div className="blue">累 Checking for PENOS system updates...</div>
          <div className="green">PENOS is already up to date (v0.1.0).</div>
          <div><span className="blue">root@penos</span>:~# <span className="cursor">█</span></div>
        </div>
      </section>

      <section id="features" className="features">
        <div className="card">
          <Zap className="blue" />
          <h3>Instant Boot</h3>
          <p>Optimized OpenRC init system specifically tuned for ARM64 virtualization. Boots in 3-5 seconds.</p>
        </div>
        <div className="card">
          <Database className="blue" />
          <h3>Persistent Storage</h3>
          <p>Automatic mounting of secondary virtual disks. Your data survives reboots, crashes, and OS updates.</p>
        </div>
        <div className="card">
          <ShieldCheck className="blue" />
          <h3>Atomic Updates</h3>
          <p>Secure OTA updates with SHA256 verification. Move between versions with a single command.</p>
        </div>
      </section>

      <footer style={{textAlign: 'center', padding: '4rem 0', color: 'var(--text-dim)', fontSize: '0.875rem'}}>
        &copy; 2026 PENOS Project by IndevStudio. Open Source under MIT.
      </footer>
    </div>
  );
}

export default App;
