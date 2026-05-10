import React, { useEffect, useState } from 'react';
import { Download, ChevronRight } from 'lucide-react';
import { supabase } from '../supabase';

const ReleaseHistory = () => {
  const [releases, setReleases] = useState([]);

  useEffect(() => {
    const fetchReleases = async () => {
      const { data } = await supabase
        .from('releases')
        .select('*')
        .order('created_at', { ascending: false });
      setReleases(data || []);
    };
    fetchReleases();
  }, []);

  return (
    <section className="container section">
      <h1>Release History</h1>
      <p>All official PENOS releases and changelogs.</p>

      {releases.map((rel) => (
        <div className="download-card" key={rel.id} style={{marginBottom: '2rem'}}>
          <div style={{display: 'flex', justifyContent: 'space-between', alignItems: 'center'}}>
            <div>
              <h2 style={{margin: 0}}>PENOS {rel.version}</h2>
              <p style={{color: '#666'}}>Released on {new Date(rel.created_at).toLocaleDateString()}</p>
            </div>
            <a href={rel.download_url} className="btn-orange">
              <Download size={18} style={{marginRight: 8, verticalAlign: 'middle'}} />
              Download ISO
            </a>
          </div>
          <div style={{marginTop: '1.5rem', borderTop: '1px solid #dbdbdb', paddingTop: '1rem'}}>
            <h4 style={{margin: '0 0 0.5rem 0'}}>What's New:</h4>
            <p style={{color: '#444', whiteSpace: 'pre-line'}}>{rel.changelog}</p>
          </div>
        </div>
      ))}

      {releases.length === 0 && <p>No releases found. Check back soon!</p>}
    </section>
  );
};

export default ReleaseHistory;
