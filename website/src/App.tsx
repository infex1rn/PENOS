import React, { useState } from 'react';
import { Book, Download, Cpu, Activity, Globe, Github } from 'lucide-react';

const Wiki = () => {
  const [activePage, setActivePage] = useState('home');

  const pages = {
    home: (
      <div>
        <h1>PENOS Wiki</h1>
        <p>Welcome to the official documentation for <strong>PENOS</strong> (Portable Environment for Networked Operating Systems).</p>
        <p>PENOS is an ultra-lightweight Linux distribution designed for high-performance terminal workflows on iOS via UTM SE.</p>
        <a href="https://penos.indevstudio.dev/download/release/" className="download-btn">Download Latest ISO</a>
        
        <h2>Quick Start</h2>
        <ul>
          <li><strong>Platform:</strong> ARM64 (Virtualization)</li>
          <li><strong>Base:</strong> Alpine Linux</li>
          <li><strong>Focus:</strong> Persistence, Portability, Performance</li>
        </ul>
      </div>
    ),
    installation: (
      <div>
        <h1>Installation Guide</h1>
        <p>Follow these steps to set up PENOS on your iOS device using UTM SE.</p>
        <h2>UTM Configuration</h2>
        <pre>{`1. Create a new VM > Virtualize > Linux
2. Select penos.iso as boot image
3. Hardware: 1GB RAM, 1 CPU Core
4. Drives: Add a 2GB VirtIO drive for /storage`}</pre>
        <p>The system will automatically detect and format the storage drive on first boot.</p>
      </div>
    ),
    management: (
      <div>
        <h1>Package Management</h1>
        <p>PENOS uses the <code>pen</code> wrapper to manage software.</p>
        <h2>Commands</h2>
        <pre>{`pen install <package>  # Add new tools
pen remove <package>   # Remove tools
pen update            # Check for OS updates`}</pre>
      </div>
    ),
    ota: (
      <div>
        <h1>OTA Update System</h1>
        <p>PENOS features an atomic update system that preserves your data.</p>
        <p>Updates are downloaded to <code>/storage/update</code> and verified via SHA256 before being applied on the next reboot.</p>
      </div>
    )
  };

  return (
    <div className="layout">
      <div className="sidebar">
        <div style={{fontSize: '1.25rem', fontWeight: 800, marginBottom: '2rem'}}>PENOS Wiki</div>
        
        <div className="nav-header">Introduction</div>
        <a href="#" className="nav-item" onClick={() => setActivePage('home')}>Welcome</a>
        
        <div className="nav-header">Getting Started</div>
        <a href="#" className="nav-item" onClick={() => setActivePage('installation')}>Installation</a>
        <a href="#" className="nav-item" onClick={() => setActivePage('management')}>Package Management</a>
        
        <div className="nav-header">System</div>
        <a href="#" className="nav-item" onClick={() => setActivePage('ota')}>OTA Updates</a>
        
        <div className="nav-header">Links</div>
        <a href="https://github.com/infex1rn/PENOS" className="nav-item" style={{display: 'flex', alignItems: 'center'}}>
          <Github size={16} style={{marginRight: 8}} /> GitHub
        </a>
      </div>

      <div className="main-content">
        {pages[activePage]}
      </div>
    </div>
  );
};

export default Wiki;
