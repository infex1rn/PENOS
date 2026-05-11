-- Create the releases table
CREATE TABLE IF NOT EXISTS releases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  version TEXT NOT NULL,
  changelog TEXT NOT NULL,
  download_url TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Enable RLS
ALTER TABLE releases ENABLE ROW LEVEL SECURITY;

-- Create policy to allow anyone to read releases
CREATE POLICY "Allow public read access" ON releases
  FOR SELECT USING (true);

-- Enable storage
-- Note: Buckets and Storage policies are often managed via the Supabase Dashboard
-- but these are the SQL commands for reference.

INSERT INTO storage.buckets (id, name, public) 
VALUES ('os-images', 'os-images', true)
ON CONFLICT (id) DO NOTHING;

-- Storage policies
CREATE POLICY "Public Access"
ON storage.objects FOR SELECT
USING ( bucket_id = 'os-images' );

CREATE POLICY "Allow Uploads"
ON storage.objects FOR INSERT
WITH CHECK ( bucket_id = 'os-images' );
