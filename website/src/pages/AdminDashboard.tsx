import React, { useState } from 'react';
import { supabase } from '../supabase';

const AdminDashboard = () => {
  const [session, setSession] = useState(null);
  const [version, setVersion] = useState('');
  const [changelog, setChangelog] = useState('');
  const [url, setUrl] = useState('');

  const handlePostRelease = async (e) => {
    e.preventDefault();
    const { error } = await supabase
      .from('releases')
      .insert([{ version, changelog, download_url: url }]);
    
    if (error) alert(error.message);
    else {
      alert("Release posted successfully!");
      setVersion(''); setChangelog(''); setUrl('');
    }
  };

  // Simplified: In production, use Supabase Auth UI or a real login form
  if (!session) {
    return (
      <div className="container section">
        <h1>Admin Login</h1>
        <button className="btn-orange" onClick={() => setSession(true)}>Login with GitHub (Simulated)</button>
      </div>
    );
  }

  return (
    <div className="container section">
      <h1>Post New Release</h1>
      <form onSubmit={handlePostRelease} style={{display: 'flex', flexDirection: 'column', gap: '1rem', maxWidth: '500px'}}>
        <input type="text" placeholder="Version (e.g. 0.1.1)" value={version} onChange={e => setVersion(e.target.value)} required style={{padding: '0.5rem'}} />
        <input type="text" placeholder="Download URL (R2 Link)" value={url} onChange={e => setUrl(e.target.value)} required style={{padding: '0.5rem'}} />
        <textarea placeholder="Changelog..." value={changelog} onChange={e => setChangelog(e.target.value)} rows={5} required style={{padding: '0.5rem'}} />
        <button type="submit" className="btn-orange">Publish Release</button>
      </form>
    </div>
  );
};

export default AdminDashboard;
